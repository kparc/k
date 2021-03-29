"use strict"

// INSECURE temp fix, shakti tls chain is broken
process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = 0;

let SHAKTI_DIR = null;

const {get} = require('https');
const fs = require('fs');
const path = require('path');
const {log, error} = console, {argv, exit, platform:os} = process;

const usage = 'usage: node get.js [yyyy.mm.dd|dev]',
    eula = 'https://shakti.com/license',
    api  = 'https://shakti.com/\!', // defunct
    headers = {Accept: 'application/json'},
    OS = {darwin:'m',linux:'l'};

const bail = m => error(m)||exit(1);
const is_date = /^\d{4}\.\d{2}\.\d{2}$/;

const getall = (u,o={}) => new Promise(t => get(u,o,x => {let data = '';
    x.on('data', x => data += x).on('end', _=>t(data))})
     .on('error', _=>bail("!net")));

const parse_eula = x => x.split('<body>', 2)[1]
    .replace(/<[/]?(\w+).*?>|[\t\n]+/g, (x,y)=>y==='p'?'\n':y?'':'').trim();

const geturl = () => {const p = OS[os];
    return p?`https://shakti.com/download/${p}i2.0?eula=shakti.com/license`:bail('!'+os)};

const to_iso = (s) => new Date(s).toISOString().slice(0,-5)

const ltime = (p) => {let mt=0;try{mt=fs.statSync(path.join(SHAKTI_DIR,p)).mtime}catch(e){};return to_iso(mt)};
const rtime = (t) => to_iso(t.replace(/\./g,'-'));

const parse_meta = data => JSON.parse(data)
    .map(f=>[f.name.slice(1),f.metadata.date.replace(/\./g,'-')])       //! name + isodate
    .filter(f=>/^[abdfi]/.test(f[0]))                                   //! skip binaries
    .filter(f=>!/\s/.test(f[0])).filter(f=>!/\.\./.test(f[0]))          //! sanitize
    .filter(f=>f[0].length)                                             //! no empty lines
    .filter(f=>ltime(f[0])!==rtime(f[1]))                               //! skip non-modified
    .map(f=>[f[0],f[1].replace(/[-T]/g,'').replace(/:/,'').replace(/:/,'.')]) //!format for touch(1)
    .join('\n').trim();

const check_dir = p => {try{const s=fs.statSync(p);return s.isDirectory();}catch(e){return false}};

//! list shakti.sh except binaries
if(argv[2]==='dev'){
    if(!argv[3]||!check_dir(argv[3]))bail('!dev')
    SHAKTI_DIR = argv[3];
    Promise.all([
     getall(api,{headers}).then(parse_meta).catch(_=>bail("!meta"))])
    .then(x=>{log(x[0]);exit(0)}).catch(_=>bail("!fatal"))}

//! historical builds !nyi
else if(argv[2])bail(!is_date.test(argv[2])?usage:'!nyi')

Promise.all([
     geturl(),
     getall(eula).then(parse_eula).catch(_=>bail("!eula"))
    ])
    .then(x=>log(`${x[0]}\n${x[1].replace(/\n/g, '\\n')}`))
    .catch(_=>bail("!fatal"))

/*attic
//getall(api, {headers}).then(parse_url).catch(_=>bail("'dist")),
const platform_is = p => x => x.attrs && x.attrs.platform === p;
const  version_is = v => ['dev', 'main'].includes(v) ?
    x => x.labels && x.labels.includes(v) : is_date(v) ?
    x => x.version <= v : bail(usage);
const later = (x, y) => x.upload_time > y.upload_time ? x : y;
const parse_url = data => 'https:' + JSON.parse(data)
    .filter(platform_is(({darwin:'osx',linux:'linux'})[os]))
    .filter(version_is(argv[2] || 'dev')).reduce(later).download_url;
*/

//:~
