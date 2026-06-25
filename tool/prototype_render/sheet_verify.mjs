import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const REPO = path.resolve(fileURLToPath(import.meta.url), '../../..');
const server = http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fp.startsWith(REPO)||!fs.existsSync(fp)||fs.statSync(fp).isDirectory()){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':path.extname(fp)==='.png'?'image/png':'text/html'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7341,r));
const browser=await chromium.launch({channel:'chrome',headless:true});
for(const label of ['desktop','mobile']){
  const dir=`tool/prototype_render/out_verify/${label}`;
  const files=fs.readdirSync(path.join(REPO,dir)).filter(f=>f.endsWith('.png')).sort();
  const h=label==='desktop'?150:300;
  const cells=files.map(f=>`<figure><img src="/${dir}/${f}"/><figcaption>${f}</figcaption></figure>`).join('');
  const html=`<!doctype html><meta charset=utf8><style>body{margin:0;background:#0b0b12;font-family:monospace;padding:14px}h1{color:#00F5C4;font-size:16px}.g{display:flex;flex-wrap:wrap;gap:10px}figure{margin:0;background:#15151f;border:1px solid #262640;border-radius:8px;padding:6px}img{height:${h}px;display:block;border-radius:4px}figcaption{color:#cfcfe6;font-size:11px;text-align:center;margin-top:4px}</style><h1>${label} — ${files.length}</h1><div class=g>${cells}</div>`;
  fs.writeFileSync(path.join(REPO,dir,'_s.html'),html);
  const page=await browser.newPage({viewport:{width:1600,height:900}});
  await page.goto(`http://localhost:7341/${dir}/_s.html`,{waitUntil:'networkidle'});
  await page.waitForTimeout(400);
  await page.screenshot({path:path.join(REPO,'tool/prototype_render/out_verify',`_sheet-${label}.png`),fullPage:true});
  await page.close();
  console.log('sheet',label);
}
await browser.close();server.close();
