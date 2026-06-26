// Capture FULL prototype-content snapshots (tabs/pills + phone(s)), tightly framed.
import { chromium } from 'playwright-core';
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import { fileURLToPath } from 'node:url';
const REPO=path.resolve(fileURLToPath(import.meta.url),'../../..');
const MIME={'.html':'text/html','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.css':'text/css','.js':'text/javascript','.woff2':'font/woff2','.woff':'font/woff','.svg':'image/svg+xml','.json':'application/json'};
const server=http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':MIME[path.extname(fp).toLowerCase()]||'application/octet-stream'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7374,r));
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--disable-background-timer-throttling','--disable-renderer-backgrounding']});

// union bbox of painted content, excluding near-full-viewport background layers
async function contentBox(page){
  return page.evaluate(()=>{
    const vw=innerWidth, vh=innerHeight; let x0=1e9,y0=1e9,x1=-1e9,y1=-1e9;
    document.querySelectorAll('body *').forEach(el=>{
      const r=el.getBoundingClientRect(); const cs=getComputedStyle(el);
      if(r.width<12||r.height<12||cs.visibility==='hidden'||parseFloat(cs.opacity)===0) return;
      if(r.width>vw*0.96 && r.height>vh*0.9) return; // skip full-page bg layers
      const paints = cs.backgroundColor!=='rgba(0, 0, 0, 0)' || cs.backgroundImage!=='none' || (el.innerText||'').trim() || el.tagName==='IMG' || el.tagName==='svg';
      if(!paints) return;
      x0=Math.min(x0,r.left); y0=Math.min(y0,r.top); x1=Math.max(x1,r.right); y1=Math.max(y1,r.bottom);
    });
    const pad=10;
    return {x:Math.max(0,Math.floor(x0-pad)),y:Math.max(0,Math.floor(y0-pad)),width:Math.ceil(Math.min(vw,x1-x0+pad*2)),height:Math.ceil(Math.min(vh,y1-y0+pad*2))};
  });
}

async function run(slug, rel, viewport, nav){
  const OUT=path.join(REPO,'tool/prototype_render/out',slug+'-full'); fs.rmSync(OUT,{recursive:true,force:true}); fs.mkdirSync(OUT,{recursive:true});
  const page=await browser.newPage({viewport,deviceScaleFactor:2});
  await page.goto('http://localhost:7374/'+rel.split('/').map(encodeURIComponent).join('/'),{waitUntil:'networkidle'}).catch(()=>{});
  await sleep(3500);
  const click=async(t)=>{try{await page.locator(`text="${t}"`).first().click({timeout:1500});await sleep(1100);return true;}catch{return false;}};
  const snap=async(name)=>{const b=await contentBox(page);try{await page.screenshot({path:path.join(OUT,name),clip:b});console.log(`  ${slug}/${name} ${b.width}x${b.height}`);}catch(e){console.log('  fail',name,String(e).slice(0,40));}};
  await nav({page,click,snap,sleep});
  await page.close();
}

// ELSSA: role tabs + one phone
await run('elssa','assets/works/ELSSA/ELSSA - Aplikasi Sekolah (standalone) (2).html',{width:1180,height:1180}, async ({click,snap})=>{
  await snap('01-morning.png');
  for(const [t,n] of [['Orang Tua','02-parent'],['Siswa','03-student'],['Guru','04-teacher'],['Wali Kelas','05-homeroom'],['Kepala Sekolah','06-principal']]){ if(await click(t)) await snap(n+'.png'); }
});

// FITX: single phone, navigate splash->login->otp->home then tabs
await run('fitx','assets/works/FITX/FITX Gym.html',{width:900,height:1000}, async ({page,click,snap,sleep})=>{
  await sleep(2500); await page.mouse.click(450,420); await sleep(1500);
  await click('Masuk'); await sleep(600); await click('Verifikasi & Masuk'); await sleep(1000);
  for(let i=0;i<5;i++){ if(!(await click('Lanjut')))break; }
  await snap('01-home.png');
  for(const [t,n] of [['Progres','02-progress'],['Booking','03-booking'],['Profil','04-profile']]){ if(await click(t)){ for(let i=0;i<4;i++){if(!(await click('Lanjut')))break;} await snap(n+'.png'); } }
});

await browser.close();server.close();
console.log('done');
