# 推箱快手Windows版

[![CI](https://github.com/ShenMian/BoxMan_Win/actions/workflows/ci.yml/badge.svg)](https://github.com/ShenMian/BoxMan_Win/actions/workflows/ci.yml)
[![CD](https://github.com/ShenMian/BoxMan_Win/actions/workflows/cd.yml/badge.svg)](https://github.com/ShenMian/BoxMan_Win/actions/workflows/cd.yml)

## 版权说明

1. 本软件中的部分代码，采用或参考了网上的开源代码，在此表示感谢。
2. 本软件中使用到的图片素材来源于网络，版权归原作者所有。
3. 本软件中附带的关卡文件，版权归关卡原作者所有。

## 编译方式

本工程支持两种编译方式：Free Pascal / Lazarus（推荐，64 位）与原版 Delphi 7（32 位）。

### 方式一：Free Pascal / Lazarus（64 位，推荐）

1. 安装 Lazarus（自带 FPC 与 LCL）。Windows 下可用 scoop：

   ```bat
   scoop install lazarus
   ```

   也可从 https://www.lazarus-ide.org/ 下载安装。

2. 命令行编译（游戏主程序和关卡编辑器是两个工程）：

   ```bat
   lazbuild BoxMan.lpi
   lazbuild BoxManEditor.lpi
   ```

   若 lazbuild 找不到 Lazarus 目录，可显式指定（路径换成你自己的）：

   ```bat
   lazbuild --lazarusdir="D:\apps\Scoop\apps\lazarus\current" BoxMan.lpi
   ```

   也可用 Lazarus IDE 打开 `BoxMan.lpi` / `BoxManEditor.lpi`，直接按 F9 编译运行。

3. 编译输出：`BoxMan.exe`（游戏主程序）与 `BoxManEditor.exe`（关卡编辑器），均为 64 位 GUI 程序。

4. 运行时依赖：`sqlite3_x64.dll`（64 位 SQLite 运行库，**游戏主程序需要**，
   必须与 `BoxMan.exe` 放在同一目录）。工程内已附带官方 3.53.4 win-x64 版本。
   关卡编辑器不依赖 SQLite。

### 方式二：Delphi 7（32 位，原版）

1. 用 Delphi 7 打开 `BoxMan.dpr`（或 `BoxManEditor.dpr`）编译。
2. 源码为 **UTF-8 with BOM**，Delphi 7 可正确识别中文，请勿去掉 BOM。
3. 运行时依赖 `sqlite3.dll`（32 位，工程内附带）。

> **注意**：32 位与 64 位使用不同的 SQLite 运行库。`SQLite3.pas` 会按目标架构自动选择
> （64 位用 `sqlite3_x64.dll`，其余用 `sqlite3.dll`），两者不要互相覆盖。

### 工程文件说明

| 文件 | 用途 |
| --- | --- |
| `BoxMan.dpr` / `BoxMan.lpi` | 游戏主程序入口 |
| `BoxManEditor.dpr` / `BoxManEditor.lpi` | 关卡编辑器入口 |
| `AppEvnts.pas`、`IdHTTP.pas`、`PsAPI.pas`、`OleCtrls.pas`、`VclFileCtrl.pas` | LCL 缺少的 Delphi 单元兼容层 |
| `SHDocVw.pas` | `TWebBrowser` 封装（基于 `SHDocVw_1_1_TLB.pas`） |
| `SHDocVw_1_1_TLB.pas` | 由 IE 类型库（ieframe.dll）用 `importtl` 生成的 IE 控件绑定 |

构建输出目录 `lib/` 已在 `.gitignore` 中忽略。

## 自动构建与发布

仓库使用 GitHub Actions：

- **CI**（`.github/workflows/ci.yml`）：向 `main` 推送或提交 PR 时，在 Windows 上安装
  Lazarus/FPC 并编译 `BoxMan.lpi` 与 `BoxManEditor.lpi`，构建产物可在该次运行的
  Artifacts 中下载。
- **CD**（`.github/workflows/cd.yml`）：推送形如 `V2.10` / `v2.10` 的标签（或在 Actions
  页面手动触发并填写标签）时，编译并打包 `BoxMan-win64.zip`，随后自动创建对应的
  GitHub Release 并附上该压缩包。

发布包内容：`BoxMan.exe`、`BoxManEditor.exe`、`sqlite3_x64.dll`、`BoxManHelp.txt`，
以及 `Image/`、`Skins/`、`Levels/` 资源目录。

### 浏览器控件（查看提交列表）

该窗口的 `TWebBrowser` 通过 LazActiveX 包（Lazarus 自带）承载 IE 的
WebBrowser ActiveX 控件，因此运行时需要系统已安装 Internet Explorer 组件。
已设置 `Silent` 模式以屏蔽 IE 弹出的脚本错误与安全警告对话框。

## 版本说明

各版本的更新内容见 [CHANGELOG.md](CHANGELOG.md)。
