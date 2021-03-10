const {get} = require('https');
const {log, error} = console, {argv, exit, platform:os} = process;

const usage = 'usage: node get.js [yyyy.mm.dd]', api = 'https://nyi',
    license = 'https://shakti.com/license.php',
    headers = {Accept: 'application/json'},
    OS = {darwin:'macos',linux:'linux'};

const bail = m => error(m)||exit(1);
const is_date = /^\d{4}\.\d{2}\.\d{2}$/;

const parse_eula = x => x.split('<body>', 2)[1]
    .replace(/<[/]?(\w+).*?>|[\t\n]+/g, (x,y)=>y==='p'?'\n':y?'':'')
    .trim();

const getall = (u,o={}) => new Promise(t => get(u,o,x => {let data = '';
    x.on('data', x => data += x).on('end', _=>t(data))})
     .on('error', _=>bail("!net")));

const geturl = () => {const p = OS[os];
    return p?`https://shakti.sh/${p}/k?eula=shakti.com/license`:bail('!'+os)};

//! historical builds are nyi
if(argv[2])bail(!is_date.test(argv[2])?usage:'!nyi')

Promise.all([
    geturl(),
    getall(license).then(parse_eula).catch(_=>bail("!eula"))])
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
