import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..'); const ROOT=path.join(REPO,'build/web');
const OUT=path.join(REPO,'tool/prototype_render/out_verify/proto');
const MIME={'.html':'text/html','.js':'text/javascript','.json':'application/json','.wasm':'application/wasm','.css':'text/css','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.ttf':'font/ttf','.otf':'font/otf','.woff2':'font/woff2','.woff':'font/woff','.bin':'application/octet-stream','.symbols':'application/octet-stream'};
const server=http.createServer((req,res)=>{let p=decodeURIComponent(req.url.split('?')[0]);if(p==='/')p='/index.html';let fp=path.join(ROOT,p);if(!fp.startsWith(ROOT)||!fs.existsSync(fp)||fs.statSync(fp).isDirectory())fp=path.join(ROOT,'index.html');res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7371,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true});
const page=await browser.newPage({viewport:{width:1440,height:1120},deviceScaleFactor:1});
await page.goto('http://localhost:7371/#/work/balai',{waitUntil:'load'}).catch(()=>{});
await sleep(7000);
await page.screenshot({path:path.join(OUT,'balai-gallery-real.png')});
await page.mouse.click(367,255); // Live Prototype toggle
await sleep(4500);
const info=await page.evaluate(()=>{const f=document.querySelector('iframe');return {n:document.querySelectorAll('iframe').length,src:f?f.getAttribute('src'):null};});
console.log('iframe:',JSON.stringify(info));
await page.screenshot({path:path.join(OUT,'balai-live-real.png')});
await browser.close();server.close();console.log('done');
