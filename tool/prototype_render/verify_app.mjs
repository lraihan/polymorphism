// Serve the built Flutter web app, scroll through it headlessly, and capture the
// Works section at desktop + mobile so we can eyeball the redesign.
import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO = path.resolve(fileURLToPath(import.meta.url), '../../..');
const ROOT = path.join(REPO, 'build/web');
const OUT = path.join(REPO, 'tool/prototype_render/out_verify');
fs.rmSync(OUT, { recursive: true, force: true });
fs.mkdirSync(OUT, { recursive: true });

const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.json': 'application/json',
  '.wasm': 'application/wasm', '.css': 'text/css', '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml', '.ttf': 'font/ttf', '.otf': 'font/otf', '.woff2': 'font/woff2', '.woff': 'font/woff', '.bin': 'application/octet-stream', '.symbols': 'application/octet-stream' };
const server = http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0]);
  if (p === '/') p = '/index.html';
  let fp = path.join(ROOT, p);
  if (!fp.startsWith(ROOT) || !fs.existsSync(fp) || fs.statSync(fp).isDirectory()) fp = path.join(ROOT, 'index.html');
  res.writeHead(200, { 'Content-Type': MIME[path.extname(fp).toLowerCase()] || 'application/octet-stream', 'Cross-Origin-Opener-Policy': 'same-origin', 'Cross-Origin-Embedder-Policy': 'require-corp' });
  fs.createReadStream(fp).pipe(res);
});
await new Promise((r) => server.listen(7340, r));
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const browser = await chromium.launch({ channel: 'chrome', headless: true });

async function run(label, width, height, steps, step) {
  const dir = path.join(OUT, label);
  fs.mkdirSync(dir, { recursive: true });
  const page = await browser.newPage({ viewport: { width, height }, deviceScaleFactor: 1 });
  const errs = [];
  page.on('pageerror', (e) => errs.push(String(e).slice(0, 160)));
  await page.goto('http://localhost:7340/', { waitUntil: 'load' }).catch(() => {});
  await sleep(8000); // boot + intro curtain + font/image decode
  await page.mouse.move(width / 2, height / 2);
  await page.mouse.click(width / 2, height / 2).catch(() => {});
  await sleep(1500);
  for (let i = 0; i < steps; i++) {
    await page.screenshot({ path: path.join(dir, `${String(i).padStart(2, '0')}.png`) });
    await page.mouse.wheel(0, step);
    await sleep(1100);
  }
  await page.screenshot({ path: path.join(dir, `${String(steps).padStart(2, '0')}.png`) });
  console.log(`${label}: ${steps + 1} shots`, errs.length ? `ERRORS: ${[...new Set(errs)].slice(0, 3).join(' | ')}` : 'no page errors');
  await page.close();
}

await run('desktop', 1440, 900, 16, 760);
await run('mobile', 390, 844, 18, 620);

await browser.close();
server.close();
console.log('done →', path.relative(REPO, OUT));
