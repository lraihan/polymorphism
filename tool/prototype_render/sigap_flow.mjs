// Drive SIGAP's real panic->dispatch flow: press & hold DARURAT on the citizen
// phone, then advance the officer through response states, capturing both phones.
import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = path.resolve(fileURLToPath(import.meta.url), '../../..');
const OUT = path.join(REPO_ROOT, 'tool/prototype_render/out/sigap');
fs.mkdirSync(OUT, { recursive: true });
const server = http.createServer((req, res) => {
  const fp = path.join(REPO_ROOT, decodeURIComponent(req.url.split('?')[0]));
  if (!fp.startsWith(REPO_ROOT) || !fs.existsSync(fp) || fs.statSync(fp).isDirectory()) { res.writeHead(404); return res.end(); }
  res.writeHead(200, { 'Content-Type': 'text/html' });
  fs.createReadStream(fp).pipe(res);
});
await new Promise((r) => server.listen(7334, r));
const browser = await chromium.launch({ channel: 'chrome', headless: true });
const page = await browser.newPage({ viewport: { width: 1200, height: 1000 }, deviceScaleFactor: 3 });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

await page.goto('http://localhost:7334/' + 'assets/works/SIGAP - Panic Button/SIGAP Mobile (standalone).html'.split('/').map(encodeURIComponent).join('/'), { waitUntil: 'networkidle' }).catch(() => {});
await sleep(3000);

async function tagPhones() {
  return page.evaluate(() => {
    const cands = [];
    document.querySelectorAll('div').forEach((el) => {
      const r = el.getBoundingClientRect(); const radius = parseFloat(getComputedStyle(el).borderRadius) || 0;
      const ar = r.width / r.height;
      if (r.width > 280 && r.width < 600 && r.height > 560 && radius >= 32 && radius <= 110 && ar > 0.4 && ar < 0.56) cands.push({ el, x: r.x });
    });
    cands.sort((a, b) => a.x - b.x);
    const clusters = []; cands.forEach((c) => { const cl = clusters.find((k) => Math.abs(k.x - c.x) < 120); if (cl) cl.items.push(c); else clusters.push({ x: c.x, items: [c] }); });
    const chosen = clusters.map((cl) => cl.items[0]);
    chosen.forEach((c, i) => c.el.setAttribute('data-cap', 'flow-' + i));
    return chosen.map((c, i) => 'flow-' + i);
  });
}
async function shot(sel, name) { const el = await page.$(`[data-cap="${sel}"]`); if (el) { await el.screenshot({ path: path.join(OUT, name), scale: 'device' }); console.log('  saved', name); } else console.log('  miss', sel); }

// locate DARURAT button center
const darurat = await page.evaluate(() => {
  const els = [...document.querySelectorAll('*')].filter((e) => (e.innerText || '').trim().startsWith('DARURAT'));
  if (!els.length) return null;
  // pick the smallest (the actual button, not a wrapper)
  els.sort((a, b) => { const ra = a.getBoundingClientRect(), rb = b.getBoundingClientRect(); return ra.width * ra.height - rb.width * rb.height; });
  const r = els[0].getBoundingClientRect();
  return { x: Math.round(r.x + r.width / 2), y: Math.round(r.y + r.height / 2) };
});
console.log('DARURAT at', darurat);

if (darurat) {
  await page.mouse.move(darurat.x, darurat.y);
  await page.mouse.down();
  await sleep(2000);            // hold >= 1s threshold
  await page.mouse.up();
  await sleep(1500);
  let phones = await tagPhones();
  console.log('after hold, phones:', phones);
  await shot(phones[0], 'flow-1-warga-reported.png');
  await shot(phones[1], 'flow-1-petugas-alert.png');

  // advance officer: click likely accept/status controls on the right phone
  for (const label of ['Terima', 'Berangkat', 'Menuju lokasi', 'Tiba', 'Tiba di lokasi', 'Selesai', 'Selesaikan']) {
    try {
      await page.locator(`text="${label}"`).first().click({ timeout: 1500 });
      await sleep(1200);
      const ph = await tagPhones();
      const slug = label.replace(/[^a-z0-9]+/gi, '-').toLowerCase();
      await shot(ph[0], `flow-2-warga-${slug}.png`);
      await shot(ph[1], `flow-2-petugas-${slug}.png`);
      console.log('  advanced via', label);
    } catch { /* not present */ }
  }
}
await browser.close();
server.close();
console.log('DONE sigap flow');
