import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const REPO = path.resolve(fileURLToPath(import.meta.url), '../../..');
const server = http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':'text/html'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7353,r));
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--disable-background-timer-throttling','--disable-renderer-backgrounding','--disable-backgrounding-occluded-windows']});
const page=await browser.newPage({viewport:{width:1440,height:1000},deviceScaleFactor:2});
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
fs.mkdirSync(path.join(REPO,'tool/prototype_render/out/fitx'),{recursive:true});
await page.goto('http://localhost:7353/'+'assets/works/FITX/FITX Gym.html'.split('/').map(encodeURIComponent).join('/'),{waitUntil:'networkidle'}).catch(()=>{});
await sleep(6000); // let splash auto-advance
const phoneCenter={x:720,y:420}, phoneBtm={x:720,y:790};
for(let step=0; step<9; step++){
  await page.screenshot({path:path.join(REPO,`tool/prototype_render/out/fitx/step-${step}.png`)});
  const info=await page.evaluate(()=>{
    const tap=[]; document.querySelectorAll('*').forEach(el=>{const cs=getComputedStyle(el);const r=el.getBoundingClientRect();const t=(el.innerText||'').trim().replace(/\s+/g,' ').slice(0,30);if(r.width>40&&r.height>16&&r.y>0&&(cs.cursor==='pointer'||el.tagName==='BUTTON')&&t&&el.children.length<3)tap.push(t);});
    return {tap:[...new Set(tap)].slice(0,16),inputs:document.querySelectorAll('input').length};
  });
  console.log(`step ${step}: inputs=${info.inputs} tap=${JSON.stringify(info.tap)}`);
  for(const inp of await page.$$('input')){try{await inp.fill('81234567890',{timeout:600});}catch{}}
  let clicked=false;
  for(const label of ['Verifikasi & Masuk','Masuk','Lanjutkan','Mulai Sekarang','Mulai','Verifikasi','Lewati','Lanjut','Selesai','Get Started']){
    try{await page.locator(`text="${label}"`).first().click({timeout:800});console.log('  click:',label);clicked=true;break;}catch{}
  }
  if(!clicked){try{await page.mouse.click(phoneBtm.x,phoneBtm.y);await sleep(300);await page.mouse.click(phoneCenter.x,phoneCenter.y);console.log('  tapped phone');}catch{}}
  await sleep(2200);
}
await browser.close();server.close();
