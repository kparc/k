# 𝒌
![npm](https://img.shields.io/npm/v/@kparc/k)
k installer

a lightweight npm script to install/update the latest development version of 𝒌 from the official anaconda.org channel.

### usage

```
$ npm i -g @kparc/k
$ k
```

### faq

**Q:** npm bails with _EACCESS_

**A:** your installation directory (e.g. `/usr/lib/node_modules`) is owned by the superuser by default. use `sudo npm` or add `--unsafe` flag to give the installer the necessary permissions

**Q:** why do i have to accept a proprietary license?

**A:** while k installer is distributed under terms of MIT, 𝒌 itself is a subject to [Shakti Software Evaluation Agreement](https://shakti.com/license)
