import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..'); const ROOT=path.join(REPO,'build/web');
const OUT=path.join(REPO,'tool/prototype_render/out_verify/proto');
const MIME={'.html':'text/html','.js':'text/javascript','.json':'application/json','.wasm':'application/wasm','.css':'text/css','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.ttf':'font/ttf','.otf':'font/otf','.woff2':'font/woff2','.woff':'font/woff','.bin':'application/octet-stream','.symbols':'application/octet-stream'};
const server=http.createServer((req,res)=>{let p=decodeURIComponent(req.url.split('?')[0]);if(p==='/')p='/index.html';let fp=path.join(ROOT,p);if(!fp.startsWith(ROOT)||!fs.existsSync(fp)||fs.statSync(fp).isDirectory())fp=path.join(ROOT,'index.html');res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7372,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true});
// case study gallery
const p1=await browser.newPage({viewport:{width:1440,height:1120},deviceScaleFactor:1});
await p1.goto('http://localhost:7372/#/work/balai',{waitUntil:'load'}).catch(()=>{});
await sleep(7000);
await p1.screenshot({path:path.join(OUT,'balai-gallery-full.png')});
await p1.close();
// grid balai cell
const p2=await browser.newPage({viewport:{width:1440,height:1000},deviceScaleFactor:1.5});
await p2.goto('http://localhost:7372/',{waitUntil:'load'}).catch(()=>{});
await sleep(8000);
await p2.mouse.move(720,500); await p2.mouse.click(720,500); await sleep(500);
for(let i=0;i<6;i++){await p2.mouse.wheel(0,720);await sleep(700);}
await sleep(1000);
await p2.screenshot({path:path.join(OUT,'balai-grid.png')});
await p2.close();
await browser.close();server.close();console.log('done');
