# Isabelle2Rust



## Quick start

```bash
isabelle build -v -e -d . Rust_Test_Quick
```

| 选项             | 含义                                                         |
| ---------------- | ------------------------------------------------------------ |
| `isabelle build` | 构建指定的 Isabelle session                                  |
| `-v`             | verbose（详细）模式，打印更多构建过程中的信息                |
| `-e`             | execute，即执行理论文件中的 ML 代码（如 `ML ‹...›` 块）      |
| `-d .`           | 使用当前目录作为 session 目录，查找 `ROOT`, `ROOTS`, `.thy`, `.ML` 文件 |
| `Get_Test`       | 指定构建的 session 名称，在 `ROOT` 文件中定义                |
