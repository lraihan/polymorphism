import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..'); const ROOT=path.join(REPO,'build/web');
const OUT=path.join(REPO,'tool/prototype_render/out_verify/proto');
const MIME={'.html':'text/html','.js':'text/javascript','.json':'application/json','.wasm':'application/wasm','.css':'text/css','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.ttf':'font/ttf','.otf':'font/otf','.woff2':'font/woff2','.woff':'font/woff','.bin':'application/octet-stream','.symbols':'application/octet-stream'};
const server=http.createServer((req,res)=>{let p=decodeURIComponent(req.url.split('?')[0]);if(p==='/')p='/index.html';let fp=path.join(ROOT,p);if(!fp.startsWith(ROOT)||!fs.existsSync(fp)||fs.statSync(fp).isDirectory())fp=path.join(ROOT,'index.html');res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7364,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true});
const page=await browser.newPage({viewport:{width:1440,height:1000},deviceScaleFactor:1});
await page.goto('http://localhost:7364/',{waitUntil:'load'}).catch(()=>{});
await sleep(8000);
await page.mouse.move(720,500); await page.mouse.click(720,500); await sleep(500);
for(let i=0;i<3;i++){await page.mouse.wheel(0,760);await sleep(700);}
await sleep(800);
await page.screenshot({path:path.join(OUT,'hov-rest.png')});
// hover over the big ROAST cell (row1 left). Move then settle.
await page.mouse.move(420,430,{steps:6}); await sleep(1400);
await page.screenshot({path:path.join(OUT,'hov-roast.png')});
await browser.close();server.close();console.log('done');
