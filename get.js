"use strict"

// broken tls chain
//process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = 0;

const {get} = require('https');
const fs = require('fs');
const path = require('path');
const {log, error} = console, {argv, exit, platform:os} = process;

const usage = 'usage: node get.js [yyyy.mm.dd|dev]',
    eula = 'https://shakti.com/license',
    api  = 'https://shakti.com',
    headers = {Accept: 'application/json'},
    OS = {darwin:'m',linux:'l'};

const bail = m => {if(m)error(m);exit(1)}
const is_date = /^\d{4}\.\d{2}\.\d{2}$/;

const getall = (u,o={}) => new Promise(t => get(u,o,x => {let data = '';
    x.on('data', x => data += x).on('end', _=>t(data))})
     .on('error', _=>bail("!net")));

const parse_eula = x => x.split('<body>', 2)[1]
    .replace(/<[/]?(\w+).*?>|[\t\n]+/g, (x,y)=>y==='p'?'\n':y?'':'').trim();

const geturl = () => {const p = OS[os];
    return p?`https://shakti.com/download/${p}i2.0?eula=shakti.com/license`:bail('!'+os)};

const get_filelist = data => {let fl = [];//log(data);
    data.replace(/l f='([^']+)'/g,(_,m)=>fl.push(m))
    fl=fl.filter(f=>!/(download|enterprise)/.test(f))
    .filter(f=>!/\.\./.test(f)).filter(f=>/\//.test(f)&&f.length).sort().reverse()
    fl.push('about','license')
    return fl.join('\n').trim()
}

//! shakti.com listing except binaries
if(argv[2]==='dev'){Promise.all([
     getall(api,{headers}).then(get_filelist).catch(_=>bail("!meta"))])
    .then(x=>{log(x[0]);exit(0)}).catch(_=>bail("!fatal"))
}else
    Promise.all([geturl(),getall(eula).then(parse_eula).catch(_=>bail("!eula"))])
    .then(x=>log(`${x[0]}\n${x[1].replace(/\n/g, '\\n')}`)).catch(_=>bail("!fatal"))

//:~
