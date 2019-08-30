const usage = 'usage: node get.js [main|dev|yyyy.mm.dd]',
    api = 'https://api.anaconda.org/package/shaktidb/shakti/files',
    license = 'https://shakti.com/license',
    headers = {Accept: 'application/json'};
const {get} = require('https'), {platform} = require('os'),
    {log, error} = console, {argv, exit} = process;
const bail = m => error(m)||exit(1);
const platform_is = p => x => x.attrs && x.attrs.platform === p;
const is_date = /^\d{4}\.\d{2}\.\d{2}$/.test;
const  version_is = v => ['dev', 'main'].includes(v) ?
    x => x.labels && x.labels.includes(v) : is_date(v) ?
    x => x.version <= v : bail(usage);
const later = (x, y) => x.upload_time > y.upload_time ? x : y;
const parse_url = data => 'https:' + JSON.parse(data)
    .filter(platform_is(({darwin:'osx',linux:'linux'})[platform()]))
    .filter(version_is(argv[2] || 'dev')).reduce(later).download_url;
const parse_eula = x => x
    .split('<body>', 2)[1]
    .replace(/<[/]?(\w+).*?>|[\t\n]+/g, (x,y)=>y==='p'?'\n':y?'':' ')
    .trim();
const getall = (u,o={}) => new Promise(t => get(u,o,x => {let data = '';
    x.on('data', x => data += x).on('end', _=>t(data))})
     .on('error', _=>bail("'net")));

Promise.all([
    getall(api, {headers}).then(parse_url).catch(_=>bail("'dist")),
    getall(license).then(parse_eula).catch(_=>bail("'eula"))])
    .then(x=>log(`${x[0]}\n${x[1].replace(/\n/g, '\\n')}`))

//:~
