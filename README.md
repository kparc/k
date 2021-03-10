# k installer
[![npm](https://img.shields.io/npm/v/@kparc/k)](https://www.npmjs.com/package/@kparc/k)

a lightweight npm package to install/update the runtime of k language on supported platforms:

* macos/x86_64
* linux/x86_64
* (tba)

### usage

```
$ npm i @kparc/k -g
$ echo 2+2|k
```

### faq

**q:** how to update?

the update command is identical to install. for convenience, consider adding the following to your rc file:
```
alias kup="npm i @kparc/k -g"
```

**q:** how to downgrade?

rolling back to previous versions is not yet supported.

**q:** what do i do if npm bails with EACCESS?

**a:** in some cases, global npm installation directory (e.g. `/usr/lib/node_modules`) is owned by the superuser by default.
use `sudo npm` and add `--unsafe` flag to give the installer the necessary one-time permissions. relaxing ownership of the npm directory is not recommended.

**q:** why do i have to accept a license on first install?

**a:** while k installer is distributed under MIT license, k itself is subject to [Shakti Software Evaluation Agreement](https://shakti.com/license.php). the agreement is not re-displayed unless there are changes to it compared to the previously accepted version.
