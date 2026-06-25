// Per-prototype screen capture. Boots each bundled Vue-SPA prototype in headless
// system-Chrome, navigates its screens, and writes high-DPR screenshots into
// out/<proj>/. Phones are captured as element clips (with bezel); web consoles as
// full-viewport frames. Curate the winners afterward.
import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = path.resolve(fileURLToPath(import.meta.url), '../../..');
const OUT = path.join(REPO_ROOT, 'tool/prototype_render/out');
const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.png': 'image/png',
  '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml', '.json': 'application/json',
  '.woff2': 'font/woff2', '.woff': 'font/woff' };

const server = http.createServer((req, res) => {
  try {
    const fp = path.join(REPO_ROOT, decodeURIComponent(req.url.split('?')[0]));
    if (!fp.startsWith(REPO_ROOT) || !fs.existsSync(fp) || fs.statSync(fp).isDirectory()) { res.writeHead(404); return res.end(); }
    res.writeHead(200, { 'Content-Type': MIME[path.extname(fp).toLowerCase()] || 'application/octet-stream' });
    fs.createReadStream(fp).pipe(res);
  } catch (e) { res.writeHead(500); res.end(String(e)); }
});
await new Promise((r) => server.listen(7332, r));
const urlFor = (rel) => 'http://localhost:7332/' + rel.split('/').map(encodeURIComponent).join('/');

const browser = await chromium.launch({ channel: 'chrome', headless: true });

// ---- helpers ---------------------------------------------------------------
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
function ensureDir(d) { fs.mkdirSync(d, { recursive: true }); }

// Find phone-frame elements (rounded, portrait, large) and tag with data-cap.
async function tagPhones(page) {
  return page.evaluate(() => {
    const cands = [];
    document.querySelectorAll('div').forEach((el) => {
      const r = el.getBoundingClientRect();
      const cs = getComputedStyle(el);
      const radius = parseFloat(cs.borderRadius) || 0;
      const ar = r.width / r.height;
      if (r.width > 280 && r.width < 600 && r.height > 560 && radius >= 32 && radius <= 110 && ar > 0.4 && ar < 0.56) {
        cands.push({ el, area: r.width * r.height, x: r.x, ar });
      }
    });
    // pick the best phone-body per cluster of x (bezel layer, not the outer glow):
    // prefer aspect ratio nearest 0.475 within each horizontal cluster.
    cands.sort((a, b) => a.x - b.x);
    const clusters = [];
    cands.forEach((c) => {
      const cl = clusters.find((k) => Math.abs(k.x - c.x) < 120);
      if (cl) cl.items.push(c); else clusters.push({ x: c.x, items: [c] });
    });
    const chosen = clusters.map((cl) => cl.items.sort((a, b) => Math.abs(a.ar - 0.475) - Math.abs(b.ar - 0.475))[0]);
    chosen.forEach((c, i) => c.el.setAttribute('data-cap', 'phone-' + i));
    return chosen.map((c, i) => 'phone-' + i);
  });
}

async function shotEl(page, sel, outPath, dpr = 3) {
  const el = await page.$(`[data-cap="${sel}"]`);
  if (!el) { console.log('  MISS element', sel); return; }
  await el.screenshot({ path: outPath, scale: 'device' }); // element clip at deviceScaleFactor
  console.log('  saved', path.relative(OUT, outPath));
}

async function shotViewport(page, outPath) {
  await page.screenshot({ path: outPath });
  console.log('  saved', path.relative(OUT, outPath));
}

// Click any element containing exact-ish text (handles non-button clickables).
async function clickText(page, text) {
  const loc = page.locator(`text="${text}"`).first();
  try { await loc.click({ timeout: 2500 }); await sleep(900); return true; }
  catch { try { await page.getByText(text, { exact: false }).first().click({ timeout: 2500 }); await sleep(900); return true; } catch { console.log('  click MISS:', text); return false; } }
}

// ===========================================================================
// 1) SIGAP — two phones (warga + petugas), advance the response state machine
// ===========================================================================
async function captureSigap() {
  const dir = path.join(OUT, 'sigap'); ensureDir(dir);
  const page = await browser.newPage({ viewport: { width: 1200, height: 1000 }, deviceScaleFactor: 3 });
  await page.goto(urlFor('assets/works/SIGAP - Panic Button/SIGAP Mobile (standalone).html'), { waitUntil: 'networkidle' }).catch(() => {});
  await sleep(3000);
  const states = [
    { label: null, name: 'idle' },
    { label: 'Dikerahkan', name: 'dikerahkan' },
    { label: 'Menuju lokasi', name: 'menuju' },
    { label: 'Tiba di lokasi', name: 'tiba' },
    { label: 'Selesai', name: 'selesai' },
  ];
  for (const st of states) {
    if (st.label) await clickText(page, st.label);
    await sleep(700);
    const phones = await tagPhones(page);
    console.log(`SIGAP [${st.name}] phones:`, phones);
    if (phones[0]) await shotEl(page, phones[0], path.join(dir, `warga-${st.name}.png`));
    if (phones[1]) await shotEl(page, phones[1], path.join(dir, `petugas-${st.name}.png`));
  }
  await page.close();
}

// ===========================================================================
// 2) ELSSA — single phone, switch role tabs
// ===========================================================================
async function captureElssa() {
  const dir = path.join(OUT, 'elssa'); ensureDir(dir);
  const page = await browser.newPage({ viewport: { width: 1100, height: 1180 }, deviceScaleFactor: 3 });
  await page.goto(urlFor('assets/works/ELSSA/ELSSA - Aplikasi Sekolah (standalone) (2).html'), { waitUntil: 'networkidle' }).catch(() => {});
  await sleep(3000);
  const roles = ['Momen pagi', 'Orang Tua', 'Siswa', 'Guru', 'Wali Kelas', 'BK', 'Kepala Sekolah'];
  // capture default first
  let phones = await tagPhones(page);
  console.log('ELSSA [default] phones:', phones);
  if (phones[0]) await shotEl(page, phones[0], path.join(dir, `00-default.png`));
  for (const role of roles) {
    const ok = await clickText(page, role);
    if (!ok) continue;
    await sleep(700);
    phones = await tagPhones(page);
    const slug = role.replace(/[^a-z0-9]+/gi, '-').toLowerCase();
    if (phones[0]) await shotEl(page, phones[0], path.join(dir, `${slug}.png`));
  }
  await page.close();
}

// ===========================================================================
// 3) PROFUND — web console: login screen, then demo-login per role, capture nav
// ===========================================================================
async function captureProfund() {
  const dir = path.join(OUT, 'profund'); ensureDir(dir);
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 2 });
  await page.goto(urlFor('assets/works/Profund Manager/Profund Manager (2).html'), { waitUntil: 'networkidle' }).catch(() => {});
  await sleep(3000);
  await shotViewport(page, path.join(dir, '00-login.png'));
  // demo login as Direktur
  await clickText(page, 'Direktur');
  await sleep(1600);
  await shotViewport(page, path.join(dir, '01-direktur-dashboard.png'));
  // dump nav labels inside the console so we can discover screens
  const nav = await page.evaluate(() => {
    const out = [];
    document.querySelectorAll('a, button, [class*="nav"] *, [class*="menu"] *, [class*="sidebar"] *, li').forEach((el) => {
      const t = (el.innerText || '').trim().replace(/\s+/g, ' ');
      const r = el.getBoundingClientRect();
      if (t && t.length < 28 && r.width > 0 && r.height > 0 && r.x < 320 && r.y > 80) out.push(t);
    });
    return [...new Set(out)].slice(0, 40);
  });
  console.log('PROFUND console nav candidates:', JSON.stringify(nav));
  // real sidebar nav (discovered from a prior dump)
  const tryNav = ['Proyek', 'Exception', 'Approval', 'Arus Kas', 'Laporan'];
  let i = 2;
  for (const item of tryNav) {
    const ok = await clickText(page, item);
    if (ok) { await sleep(1000); await shotViewport(page, path.join(dir, `${String(i).padStart(2, '0')}-${item.replace(/[^a-z0-9]+/gi, '-').toLowerCase()}.png`)); i++; }
  }
  await page.close();
}

const only = process.argv[2];
if (!only || only === 'sigap') await captureSigap();
if (!only || only === 'elssa') await captureElssa();
if (!only || only === 'profund') await captureProfund();

await browser.close();
server.close();
console.log('\\nDONE. Review out/sigap, out/elssa, out/profund');
