// Build a labeled contact sheet per project from captured PNGs, using Chrome to
// render an HTML grid and screenshot it. Lets us curate many shots in few reads.
import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = path.resolve(fileURLToPath(import.meta.url), '../../..');
const OUT = path.join(REPO_ROOT, 'tool/prototype_render/out');
const server = http.createServer((req, res) => {
  const fp = path.join(REPO_ROOT, decodeURIComponent(req.url.split('?')[0]));
  if (!fp.startsWith(REPO_ROOT) || !fs.existsSync(fp) || fs.statSync(fp).isDirectory()) { res.writeHead(404); return res.end(); }
  const ext = path.extname(fp).toLowerCase();
  res.writeHead(200, { 'Content-Type': ext === '.png' ? 'image/png' : 'text/html' });
  fs.createReadStream(fp).pipe(res);
});
await new Promise((r) => server.listen(7333, r));
const browser = await chromium.launch({ channel: 'chrome', headless: true });

for (const proj of ['sigap', 'elssa', 'profund']) {
  const dir = path.join(OUT, proj);
  if (!fs.existsSync(dir)) continue;
  const files = fs.readdirSync(dir).filter((f) => f.endsWith('.png')).sort();
  const cells = files.map((f) => {
    const rel = `/tool/prototype_render/out/${proj}/${f}`;
    return `<figure><img src="${rel}"/><figcaption>${f}</figcaption></figure>`;
  }).join('');
  const html = `<!doctype html><meta charset=utf8><style>
    body{margin:0;background:#0b0b12;font-family:ui-monospace,monospace;padding:18px}
    h1{color:#00F5C4;font-size:18px;margin:0 0 14px}
    .grid{display:flex;flex-wrap:wrap;gap:16px;align-items:flex-start}
    figure{margin:0;background:#15151f;border:1px solid #262640;border-radius:10px;padding:8px;width:max-content}
    img{height:360px;width:auto;display:block;border-radius:6px;background:#fff}
    figcaption{color:#cfcfe6;font-size:12px;margin-top:6px;text-align:center}
  </style><h1>${proj.toUpperCase()} — ${files.length} captures</h1><div class=grid>${cells}</div>`;
  const sheetHtml = path.join(dir, '_sheet.html');
  fs.writeFileSync(sheetHtml, html);
  const page = await browser.newPage({ viewport: { width: 1500, height: 900 }, deviceScaleFactor: 1 });
  await page.goto(`http://localhost:7333/tool/prototype_render/out/${proj}/_sheet.html`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(500);
  await page.screenshot({ path: path.join(OUT, `_sheet-${proj}.png`), fullPage: true });
  await page.close();
  console.log('sheet:', `out/_sheet-${proj}.png`, `(${files.length} imgs)`);
}
await browser.close();
server.close();
