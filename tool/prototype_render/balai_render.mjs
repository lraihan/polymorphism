import { chromium } from 'playwright-core';
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const REPO = path.resolve(fileURLToPath(import.meta.url), '../../..');
const OUT = path.join(REPO, 'tool/prototype_render/out/balai'); fs.mkdirSync(OUT, { recursive: true });
const server = http.createServer((req,res)=>{const fp=path.join(REPO,decodeURIComponent(req.url.split('?')[0]));if(!fs.existsSync(fp)){res.writeHead(404);return res.end();}res.writeHead(200,{'Content-Type':'text/html'});fs.createReadStream(fp).pipe(res);});
await new Promise(r=>server.listen(7350,r));
const browser=await chromium.launch({channel:'chrome',headless:true});
const page=await browser.newPage({viewport:{width:1700,height:900},deviceScaleFactor:3});
await page.goto('http://localhost:7350/tool/prototype_render/balai_mockup.html',{waitUntil:'networkidle'});
await page.evaluate(()=>document.fonts.ready);
await page.waitForTimeout(1200);
const phones=await page.$$('.phone');
const names=['01-drop','02-live','03-detail','04-won'];
for(let i=0;i<phones.length;i++){await phones[i].screenshot({path:path.join(OUT,`${names[i]||i}.png`),scale:'device'});console.log('saved',names[i]);}
await browser.close();server.close();
