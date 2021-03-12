# k installer
[![npm](https://img.shields.io/npm/v/@kparc/k)](https://www.npmjs.com/package/@kparc/k)

a lightweight npm package to install/update the runtime of [k language](https://shakti.com) on supported architectures and platforms:

* macos/x86_64
* linux/x86_64
* (tba)

### usage

```
$ npm i @kparc/k -g
$ echo 2+2|k
```

### faq

#### how to upgrade?

the update command is the same as install. for convenience, consider adding the following to your rc file:
```
alias kup="npm i @kparc/k --global --quiet --no-audit --yes"
```

#### how to downgrade?

rolling back to previous versions is not yet supported. to uninstall, use:

```
$ npm uninstall @kparc/k -g
removed 1 package in 0.333s
```

#### it doesn't work for me.

the installer targets Node.js LTS, which is recommended for most users and ships with `npm 6.*`. if your environment is configured to use latest features, you may experience minor difficulties, e.g. excessively verbose `npm` output during installation. please raise an [issue](https://github.com/kparc/k/issues/new) and include parts of `npm i @kparc/k -g --verbose` that seem relevant.

#### the installer fails with `EACCESS`.

on correctly configured systems, the global `npm` installation directory (e.g. `/usr/lib/node_modules`) is owned by the superuser. use the following command to give `npm` the necessary one-time permissions:

```
$ sudo npm install @kparc/k --global --unsafe
```

relaxing ownership of the npm directory is not recommended.

#### i don't have administrative rights on my system.

omit `-g` flag, the package will be placed in your home directory. you can then add `~/node_modules/@kparc/k/bin` to your `PATH`.

#### why do i have to accept a license on first install?

while k installer is distributed under MIT license, k itself is subject to [Shakti Software Evaluation Agreement](https://shakti.com/license.php). the agreement is not re-displayed unless there are changes to the previously accepted version.

by default, the checksum of previously accepted EULA text is placed at the following *global* location:

```
$ cat /tmp/shakti.eula.crc
1226073694 11784
```

