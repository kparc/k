const usage = 'usage: node get.js <dist|eula> [main|dev|yyyy.mm.dd]',
    api = 'https://api.anaconda.org/package/shaktidb/shakti/files',
    license = 'https://shakti.com/license',
    headers = {Accept: 'application/json'};
const {get} = require('https'), {platform} = require('os'),
    {log} = console, {argv, exit} = process;
const bail = m => {log(m); exit(1)}
const platform_is = p => x => x.attrs && x.attrs.platform === p;
const is_date = /^\d{4}\.\d{2}\.\d{2}$/.test;
const  version_is = v => ['dev', 'main'].includes(v) ?
    x => x.labels && x.labels.includes(v) : is_date(v) ?
    x => x.version <= v : bail(usage);
const later = (x, y) => x.upload_time > y.upload_time ? x : y;
const parse_url = data => 'https:' + JSON.parse(data)
    .filter(platform_is(({darwin:'osx',linux:'linux'})[platform()]))
    .filter(version_is(argv[3] || 'dev')).reduce(later).download_url;
const parse_eula = x => x
    .split('<body>', 2)[1]
    .replace(/<\/p.*?>/g, '\n')
    .replace(/<.*?>/g, '')
    .replace(/\t/g, ' ').trim();
const p = (f, e, x) => {let data = '';
    x.on('data', x => data += x).on('end', ()=>
    {try{log(f(data))}catch(e){bail(`'${e}`);}});}
const targets = {dist:{u:api,h:headers,cb:parse_url},eula:{u:license,h:{},cb:parse_eula}};
const tgt=argv[2],t=targets[tgt]||bail(usage);

get(t.u,t.h,p.bind(null,t.cb, "'"+tgt)).on('error',bail.bind(null, "'net"));

//:~
