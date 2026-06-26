import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..');
const OUT=path.join(REPO,'tool/prototype_render/out/balai-real'); fs.rmSync(OUT,{recursive:true,force:true}); fs.mkdirSync(OUT,{recursive:true});
const MIME={'.html':'text/html','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.css':'text/css','.js':'text/javascript','.woff2':'font/woff2','.woff':'font/woff','.svg':'image/svg+xml'};
const server=http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)||fs.statSync(fp).isDirectory()){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7366,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--disable-background-timer-throttling']});
const page=await browser.newPage({viewport:{width:1440,height:1000},deviceScaleFactor:3});
await page.goto('http://localhost:7366/'+'assets/works/Balai/Curated Drops Auction All Flows.html'.split('/').map(encodeURIComponent).join('/'),{waitUntil:'networkidle'}).catch(()=>{});
await sleep(3000);
const click=async(t)=>{try{await page.locator(`text="${t}"`).first().click({timeout:1500});await sleep(1100);return true;}catch{return false;}};
async function shot(name){
  const ok=await page.evaluate(()=>{let best=null,a=0;document.querySelectorAll('div').forEach(el=>{const r=el.getBoundingClientRect();const rad=parseFloat(getComputedStyle(el).borderRadius)||0;if(r.height>720&&r.width>280&&r.width<540&&rad>=18&&r.width*r.height>a){a=r.width*r.height;best=el;}});if(best){best.setAttribute('data-cap','p');return true;}return false;});
  const el=ok?await page.$('[data-cap="p"]'):null;
  if(el){await el.screenshot({path:path.join(OUT,name),scale:'device'});console.log('  saved',name);}else console.log('  MISS',name);
}
await shot('01-buyer-home.png');
await click('demo: open drop'); await shot('02-drop.png');
// try to open a lot / live bid
await click('Heritage & Form'); await shot('03-lot.png');
await click('Seller'); await sleep(600); await shot('04-seller.png');
await click('Curator'); await sleep(600); await shot('05-curator.png');
await click('Buyer'); await sleep(600);
await browser.close();server.close();console.log('done');
