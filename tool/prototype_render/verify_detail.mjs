import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const REPO = path.resolve(fileURLToPath(import.meta.url), '../../..');
const ROOT = path.join(REPO, 'build/web');
const OUT = path.join(REPO, 'tool/prototype_render/out_verify/detail');
fs.rmSync(OUT, { recursive: true, force: true }); fs.mkdirSync(OUT, { recursive: true });
const MIME={'.html':'text/html','.js':'text/javascript','.mjs':'text/javascript','.json':'application/json','.wasm':'application/wasm','.css':'text/css','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.ttf':'font/ttf','.otf':'font/otf','.woff2':'font/woff2','.woff':'font/woff','.bin':'application/octet-stream','.symbols':'application/octet-stream'};
const server=http.createServer((req,res)=>{let p=decodeURIComponent(req.url.split('?')[0]);if(p==='/')p='/index.html';let fp=path.join(ROOT,p);if(!fp.startsWith(ROOT)||!fs.existsSync(fp)||fs.statSync(fp).isDirectory())fp=path.join(ROOT,'index.html');res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7342,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true});
for(const id of ['roast-pos','balai']){
  const page=await browser.newPage({viewport:{width:1440,height:900},deviceScaleFactor:1});
  const errs=[];page.on('pageerror',e=>errs.push(String(e).slice(0,140)));
  await page.goto(`http://localhost:7342/#/work/${id}`,{waitUntil:'load'}).catch(()=>{});
  await sleep(7000);
  for(let i=0;i<6;i++){await page.screenshot({path:path.join(OUT,`${id}-${i}.png`)});await page.mouse.wheel(0,720);await sleep(1000);}
  console.log(id, errs.length?`ERR ${[...new Set(errs)].slice(0,2)}`:'ok');
  await page.close();
}
await browser.close();server.close();
