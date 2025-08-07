# Isabelle2Rust



## Quick start

```bash
make code THEORY=Rust_Test_Quick
# isabelle build -v -e -d . Rust_Test_Quick
```

| 选项             | 含义                                                         |
| ---------------- | ------------------------------------------------------------ |
| `isabelle build` | 构建指定的 Isabelle session                                  |
| `-v`             | verbose（详细）模式，打印更多构建过程中的信息                |
| `-e`             | execute，即执行理论文件中的 ML 代码（如 `ML ‹...›` 块）      |
| `-d .`           | 使用当前目录作为 session 目录，查找 `ROOT`, `ROOTS`, `.thy`, `.ML` 文件 |
| `Get_Test`       | 指定构建的 session 名称，在 `ROOT` 文件中定义                |

## Code Submission with `git cz` (replace `git commit`)
### Require
- [node](https://nodejs.org/en/) >= 10

### Installation
First open project, please run
```shell
$ sudo apt install npm
$ cd /YOUR-PATH/this-repo
$ npm install
```
Then, you can use `git cz`（where PATH contain node_modules/.bin）or `npm run cz` to commit your code

If you want to use `git cz` globally（where PATH not contain node_modules/.bin）, you can run
```shell
$ npm install -g commitizen
```
Then, you can use `git cz` to commit your code in terminal globally.

### Usage
- When ready to commit changes, instead of `git commit`, use `git cz` or `npm run cz`.
- git cz will prompt you to select the type of commit (e.g., feat, fix, docs, style, refactor, test).
- Enter a scope, and enter a short, descriptive title for the commit. For example, Add user login function.
- Optionally provide a detailed description of the changes.
