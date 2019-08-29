# 𝒌
![npm](https://img.shields.io/npm/v/@kparc/k)

k installer

a lightweight npm script to install/update the latest development version of 𝒌 from the official anaconda.org channel

### usage

```
$ npm i -g @kparc/k
$ k
```

### faq

**Q:** what do i do if npm bails with EACCESS?

**A:** your installation directory (e.g. `/usr/lib/node_modules`) is owned by the superuser by default
use `sudo npm` and add `--unsafe` flag to give the installer the necessary permissions

**Q:** why do i have to accept a proprietary license?

**A:** while k installer is distributed under MIT license, 𝒌 itself is subject to [Shakti Software Evaluation Agreement](https://shakti.com/license)
