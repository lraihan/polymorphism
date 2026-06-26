import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..'); const ROOT=path.join(REPO,'build/web');
const MIME={'.html':'text/html','.js':'text/javascript','.mjs':'text/javascript','.json':'application/json','.wasm':'application/wasm','.css':'text/css','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.ttf':'font/ttf','.otf':'font/otf','.woff2':'font/woff2','.woff':'font/woff','.bin':'application/octet-stream','.symbols':'application/octet-stream'};
const server=http.createServer((req,res)=>{let p=decodeURIComponent(req.url.split('?')[0]);if(p==='/')p='/index.html';let fp=path.join(ROOT,p);if(!fp.startsWith(ROOT)||!fs.existsSync(fp)||fs.statSync(fp).isDirectory())fp=path.join(ROOT,'index.html');res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7360,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true});
const page=await browser.newPage({viewport:{width:1440,height:1500},deviceScaleFactor:1.5});
await page.goto('http://localhost:7360/',{waitUntil:'load'}).catch(()=>{});
await sleep(8000);
await page.mouse.move(720,750); await page.mouse.click(720,750); await sleep(800);
// scroll to the works grid (~ below hero+about)
for(let i=0;i<6;i++){await page.mouse.wheel(0,720);await sleep(700);}
await sleep(1200);
await page.screenshot({path:path.join(REPO,'tool/prototype_render/out_verify/grid-hi.png')});
await browser.close();server.close();console.log('grid-hi.png');
