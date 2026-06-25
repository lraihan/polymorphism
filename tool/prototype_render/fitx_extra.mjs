import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..');
const OUT=path.join(REPO,'tool/prototype_render/out/fitx');
const server=http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':'text/html'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7356,r));
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--disable-background-timer-throttling','--disable-renderer-backgrounding','--disable-backgrounding-occluded-windows']});
const page=await browser.newPage({viewport:{width:1440,height:980},deviceScaleFactor:3});
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const click=async(t)=>{try{await page.locator(`text="${t}"`).first().click({timeout:1000});await sleep(900);return true;}catch{return false;}};
const dismiss=async()=>{for(let i=0;i<6;i++){if(!(await click('Lanjut')||await click('Selesai')||await click('Mengerti')||await click('Oke')))break;}};
async function shot(name){const ok=await page.evaluate(()=>{let best=null,a=0;document.querySelectorAll('div').forEach(el=>{const r=el.getBoundingClientRect();const rad=parseFloat(getComputedStyle(el).borderRadius)||0;if(r.width>340&&r.width<460&&r.height>760&&rad>=38&&r.width*r.height>a){a=r.width*r.height;best=el;}});if(best){best.setAttribute('data-cap','p');return true;}return false;});const el=ok?await page.$('[data-cap="p"]'):null;if(el){await el.screenshot({path:path.join(OUT,name),scale:'device'});console.log('  saved',name);}else console.log('  miss',name);}
await page.goto('http://localhost:7356/'+'assets/works/FITX/FITX Gym.html'.split('/').map(encodeURIComponent).join('/'),{waitUntil:'networkidle'}).catch(()=>{});
await sleep(6000);
await page.mouse.click(720,420); await sleep(1500);
await click('Masuk'); await sleep(800);
await click('Verifikasi & Masuk'); await sleep(1200);
await dismiss();
// check-in scan
await click('BELUM CHECK-IN'); await dismiss(); await sleep(500); await shot('08-checkin.png');
// back home, profile -> trainer mode
await click('Beranda'); await dismiss();
await click('Profil'); await dismiss();
await click('Beralih ke Mode Pelatih'); await dismiss(); await sleep(600); await shot('09-trainer.png');
await browser.close();server.close(); console.log('done');
