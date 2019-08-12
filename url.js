// usage: node url.js [main|dev|yyyy.mm.dd]
const api = 'https://api.anaconda.org/package/shaktidb/shakti/files',
 headers = {Accept: 'application/json'},
 {get} = require('https'), {platform} = require('os'),
 {log} = console, {parse} = JSON, {argv} = process,
 platform_is = p => x => x.attrs && x.attrs.platform === p,
 version_is = v => ['dev', 'main'].includes(v) ?
  x => x.labels && x.labels.includes(v) : x => x.version === v,
 later = (x, y) => x.upload_time > y.upload_time ? x : y,
 print_url = data => log('https:' + parse(data)
  .filter(platform_is(platform() === 'darwin' ? 'osx' : 'linux'))
  .filter(version_is(argv[2] || 'dev')).reduce(later).download_url);

get(api, {headers}, x => {let data = '';
 x.on('data', x => data += x).on('end', ()=>print_url(data));});

//:~