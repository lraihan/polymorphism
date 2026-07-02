import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..');
const OUT=path.join(REPO,'tool/prototype_render/out/sigap-full'); fs.rmSync(OUT,{recursive:true,force:true}); fs.mkdirSync(OUT,{recursive:true});
const MIME={'.html':'text/html','.png':'image/png','.css':'text/css','.js':'text/javascript','.woff2':'font/woff2','.svg':'image/svg+xml'};
const server=http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7375,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--disable-background-timer-throttling']});
const page=await browser.newPage({viewport:{width:1280,height:1040},deviceScaleFactor:2});
await page.goto('http://localhost:7375/'+'web/prototypes/sigap.html'.split('/').map(encodeURIComponent).join('/'),{waitUntil:'networkidle'}).catch(()=>{});
await sleep(3000);
async function box(){return page.evaluate(()=>{const vw=innerWidth,vh=innerHeight;let x0=1e9,y0=1e9,x1=-1e9,y1=-1e9;document.querySelectorAll('body *').forEach(el=>{const r=el.getBoundingClientRect();const cs=getComputedStyle(el);if(r.width<12||r.height<12||cs.visibility==='hidden'||parseFloat(cs.opacity)===0)return;if(r.width>vw*0.97&&r.height>vh*0.92)return;const paints=cs.backgroundColor!=='rgba(0, 0, 0, 0)'||cs.backgroundImage!=='none'||(el.innerText||'').trim()||el.tagName==='IMG'||el.tagName==='svg';if(!paints)return;x0=Math.min(x0,r.left);y0=Math.min(y0,r.top);x1=Math.max(x1,r.right);y1=Math.max(y1,r.bottom);});const p=12;return {x:Math.max(0,Math.floor(x0-p)),y:Math.max(0,Math.floor(y0-p)),width:Math.ceil(Math.min(vw,x1-x0+p*2)),height:Math.ceil(Math.min(vh,y1-y0+p*2))};});}
const snap=async(n)=>{const b=await box();try{await page.screenshot({path:path.join(OUT,n),clip:b});console.log(`  ${n} ${b.width}x${b.height}`);}catch(e){console.log('  fail',n);}};
const click=async(t)=>{try{await page.locator(`text="${t}"`).first().click({timeout:1500});await sleep(1100);return true;}catch{return false;}};
await snap('01-idle.png');
// press & hold DARURAT — triggers Diterima, then auto-advances to Dikerahkan
const d=await page.evaluate(()=>{const els=[...document.querySelectorAll('*')].filter(e=>(e.innerText||'').trim().startsWith('DARURAT'));if(!els.length)return null;els.sort((a,b)=>{const ra=a.getBoundingClientRect(),rb=b.getBoundingClientRect();return ra.width*ra.height-rb.width*rb.height;});const r=els[0].getBoundingClientRect();return{x:Math.round(r.x+r.width/2),y:Math.round(r.y+r.height/2)};});
if(d){await page.mouse.move(d.x,d.y);await page.mouse.down();await sleep(2000);await page.mouse.up();await sleep(1500);}
await snap('02-alert.png');
await sleep(1500); await snap('03-dispatch.png');
// action buttons are now uppercase CTAs, not the timeline pill labels
await click('TERIMA');
await click('TIBA DI LOKASI'); await sleep(400);
await click('SELESAI'); await snap('04-resolved.png');
await browser.close();server.close();console.log('done');
