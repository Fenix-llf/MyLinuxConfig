# example 配置仓模板

这个目录是一个可直接复制出去的 Linux 用户配置仓模板。

推荐做法不是直接在这里长期维护，而是把它复制到这个公开部署仓之外，再作为你自己的私有 Git 仓库使用。这样：

- `simple-deploy-linux-user-config/` 可以保持公开
- 复制出去后的配置仓可以保持私有

## 推荐流程

在 `simple-deploy-linux-user-config/` 目录下执行：

```bash
cp -r ./example ~/MyLinuxConfig
./deploy.sh ~/MyLinuxConfig --dry-run
```

如果你确认结构合适，再到复制出去的目录里初始化你自己的私有仓：

```bash
cd ~/MyLinuxConfig
git init
```

或者直接关联到你自己的 private remote。

## 目录结构

```text
.
├── config/
│   └── settings.conf
├── manifests/
│   ├── 0001-base.install
│   ├── 0010-zsh.conf
│   └── 0020-neovim-config.sh
├── overlay/
│   ├── .config/
│   │   └── zsh/
│   │       ├── aliases.zsh
│   │       ├── env.zsh
│   │       └── prompt.zsh
│   └── .zshrc
```

## Manifest 规则

`manifests/` 目录下支持三种文件：

- `*.install`：包安装清单
- `*.conf`：动作清单
- `*.sh`：自定义 shell 脚本

这些文件会按文件名前缀里的数字顺序执行。只要文件名以数字开头就会参与排序，不要求必须是四位数字，例如：

- `1-base.install`
- `0010-zsh.conf`
- `20-extra.conf`

不带数字前缀的 manifest 会被跳过。

`.conf` 文件目前支持这些动作：

- `link|SOURCE|TARGET`
- `remove|TARGET`
- `remove_dir|TARGET`
- `mode|PATH|MODE`

`.install` 文件里只允许写纯包名或逻辑包名，不能指定包管理器前缀。部署器会读取 `/etc/os-release` 自动判断当前系统属于 `apt`、`pacman` 还是 `dnf`，并在少量常见包名差异上做内置映射，例如：

- `fd`：在 apt/dnf 上会转成 `fd-find`
- `build-essential`：在 pacman 上会转成 `base-devel`

`.sh` manifest 会按数字顺序执行，默认以当前被管理用户身份运行。如果脚本内部需要提权，请在脚本里自行调用 `sudo`。

`config/settings.conf` 里除了 `BACKUP_ROOT` 这类基础配置外，也可以定义只在当前部署过程中临时生效的环境变量。这些变量会传给 `.sh` manifest，但不会自动写入你的 shell 配置。

例如，模板里的 `0020-neovim-config.sh` 就演示了如何配合下面这些临时变量来 clone 或更新你的 Neovim 配置仓：

```bash
NVIM_REPO_URL=git@github.com:your-user/your-nvim.git
NVIM_REPO_DIR=~/.config/nvim
```

## 备份

在覆盖或删除任何目标前，部署器会先把现有目标移动到：

```text
~/.local/share/mylinuxconfig/backups/<timestamp>/...
```

备份目录会保留原始绝对路径结构。

## 模板使用提醒

- 如果你要使用 `0020-neovim-config.sh` 里的 Neovim 示例，再自行把相关临时变量写进 `config/settings.conf`
- 如果你不想在模板里保留示例配置，复制出去后直接替换 `overlay/` 和 `manifests/` 即可
- 如果你只想测试模板是否能运行，可以直接在当前公开仓里执行 `./deploy.sh ./example --dry-run`
