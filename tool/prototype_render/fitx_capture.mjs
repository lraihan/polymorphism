import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const REPO = path.resolve(fileURLToPath(import.meta.url), '../../..');
const OUT = path.join(REPO,'tool/prototype_render/out/fitx'); fs.mkdirSync(OUT,{recursive:true});
const server=http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':'text/html'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7354,r));
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--disable-background-timer-throttling','--disable-renderer-backgrounding','--disable-backgrounding-occluded-windows']});
const page=await browser.newPage({viewport:{width:1440,height:980},deviceScaleFactor:3});
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
await page.goto('http://localhost:7354/'+'assets/works/FITX/FITX Gym.html'.split('/').map(encodeURIComponent).join('/'),{waitUntil:'networkidle'}).catch(()=>{});
await sleep(6000);
const click=async(t)=>{try{await page.locator(`text="${t}"`).first().click({timeout:1000});await sleep(900);return true;}catch{return false;}};
const dismiss=async()=>{for(let i=0;i<6;i++){const ok=await click('Lanjut')||await click('Selesai')||await click('Mengerti')||await click('Oke');if(!ok)break;}};
async function shot(name){
  const sel=await page.evaluate(()=>{let best=null,area=0;document.querySelectorAll('div').forEach(el=>{const r=el.getBoundingClientRect();const rad=parseFloat(getComputedStyle(el).borderRadius)||0;if(r.width>340&&r.width<460&&r.height>760&&rad>=38&&r.width*r.height>area){area=r.width*r.height;best=el;}});if(best){best.setAttribute('data-cap','p');return true;}return false;});
  const el=sel?await page.$('[data-cap="p"]'):null;
  if(el){await el.screenshot({path:path.join(OUT,name),scale:'device'});console.log('  saved',name);} else console.log('  no phone for',name);
}
// flow: splash -> login -> otp -> dismiss coachmarks
await page.mouse.click(720,420); await sleep(1500);
await click('Masuk'); await sleep(800);
await click('Verifikasi & Masuk'); await sleep(1200);
await dismiss();
await shot('01-home.png');
for(const [tab,name] of [['Progres','02-progress.png'],['Booking','03-booking.png'],['Market','04-market.png'],['Profil','05-profile.png'],['Beranda','06-home2.png']]){
  await click(tab); await dismiss(); await sleep(500); await shot(name);
}
// try class detail + check-in scan from home
await click('Beranda'); await dismiss();
await click('Body Pump'); await dismiss(); await sleep(400); await shot('07-class.png');
await browser.close();server.close();
console.log('done');
