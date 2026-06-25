// Boot a bundled Vue-SPA prototype in headless system-Chrome, wait for it to
// "unpack", screenshot the full layout, and dump navigable elements so we can
// discover its screens. Usage: node inspect.mjs <relative-html-path>
import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = path.resolve(fileURLToPath(import.meta.url), '../../..');
const target = process.argv[2];
if (!target) { console.error('pass relative html path'); process.exit(1); }

const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml',
  '.json': 'application/json', '.woff2': 'font/woff2', '.woff': 'font/woff' };

const server = http.createServer((req, res) => {
  try {
    const urlPath = decodeURIComponent(req.url.split('?')[0]);
    const fp = path.join(REPO_ROOT, urlPath);
    if (!fp.startsWith(REPO_ROOT) || !fs.existsSync(fp) || fs.statSync(fp).isDirectory()) {
      res.writeHead(404); return res.end('nope');
    }
    res.writeHead(200, { 'Content-Type': MIME[path.extname(fp).toLowerCase()] || 'application/octet-stream' });
    fs.createReadStream(fp).pipe(res);
  } catch (e) { res.writeHead(500); res.end(String(e)); }
});

await new Promise((r) => server.listen(7331, r));
const url = 'http://localhost:7331/' + target.split(path.sep).map(encodeURIComponent).join('/');
console.log('URL:', url);

const browser = await chromium.launch({ channel: 'chrome', headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 960 }, deviceScaleFactor: 2 });
const logs = [];
page.on('console', (m) => logs.push(`[${m.type()}] ${m.text()}`.slice(0, 200)));
page.on('pageerror', (e) => logs.push(`[pageerror] ${String(e).slice(0, 200)}`));

await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 }).catch((e) => console.log('goto warn:', e.message));
// give the bundler time to unpack + the SPA to mount + fonts to settle
await page.waitForTimeout(3500);

const outDir = path.join(REPO_ROOT, 'tool/prototype_render/out');
fs.mkdirSync(outDir, { recursive: true });
const slug = path.basename(target).replace(/[^a-z0-9]+/gi, '-').toLowerCase();
await page.screenshot({ path: path.join(outDir, `${slug}-full.png`), fullPage: false });

// Discover structure: big rounded "device frame" candidates + clickable nav.
const info = await page.evaluate(() => {
  const vw = innerWidth, vh = innerHeight;
  const rectOf = (el) => { const r = el.getBoundingClientRect(); return { x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) }; };
  const big = [];
  document.querySelectorAll('*').forEach((el) => {
    const r = el.getBoundingClientRect();
    const cs = getComputedStyle(el);
    const radius = parseFloat(cs.borderRadius) || 0;
    // candidate phone/device frame: tall-ish, rounded, reasonable size, on-screen
    if (r.width > 240 && r.width < 900 && r.height > 360 && radius >= 16 && r.y > -50 && r.y < vh) {
      big.push({ tag: el.tagName.toLowerCase(), cls: (el.className || '').toString().slice(0, 60), radius: Math.round(radius), ...rectOf(el) });
    }
  });
  const clickables = [];
  document.querySelectorAll('button, [role="button"], [onclick], a, nav *, [class*="nav"], [class*="tab"]').forEach((el) => {
    const t = (el.innerText || el.getAttribute('aria-label') || '').trim().replace(/\s+/g, ' ').slice(0, 40);
    const r = el.getBoundingClientRect();
    if (r.width > 0 && r.height > 0 && r.y < vh + 200 && t) clickables.push({ tag: el.tagName.toLowerCase(), t, ...rectOf(el) });
  });
  // dedup clickables by text
  const seen = new Set(); const uniq = clickables.filter((c) => { const k = c.t; if (seen.has(k)) return false; seen.add(k); return true; });
  return { vw, vh, scrollH: document.body.scrollHeight, bodyBg: getComputedStyle(document.body).backgroundColor,
    frames: big.sort((a, b) => b.w * b.h - a.w * a.h).slice(0, 8), clickables: uniq.slice(0, 50) };
});

console.log('=== PAGE INFO ===');
console.log('scrollHeight:', info.scrollH, 'bodyBg:', info.bodyBg);
console.log('=== DEVICE-FRAME CANDIDATES (largest first) ===');
console.log(JSON.stringify(info.frames, null, 1));
console.log('=== CLICKABLE / NAV (unique text) ===');
console.log(JSON.stringify(info.clickables, null, 1));
console.log('=== CONSOLE (first 15) ===');
console.log(logs.slice(0, 15).join('\n'));

await browser.close();
server.close();
console.log('screenshot:', `out/${slug}-full.png`);
