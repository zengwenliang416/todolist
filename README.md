# todolist

[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-FA7343.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-black.svg)](https://developer.apple.com/macos/)
[![Build](https://img.shields.io/badge/build-SwiftPM-blue.svg)](https://www.swift.org/package-manager/)

> Native macOS productivity suite centered around **MacToDo**, a SwiftUI + Core Data task manager featuring a hand-drawn/glassy theme, MVVM architecture, and automated packaging.

![MacToDo Preview](docs/logo.png)

## 仓库概览

| 模块 | 描述 |
| --- | --- |
| `MacToDo/` | 主要 Swift Package：应用源码、资源、脚本（构建/图标）、测试。 |
| `docs/` | 需求/设计与优化报告（`docs/todolist/*`, `docs/optimization/*`），包含用户手册与交付记录。 |
| `CHANGELOG.md` | 版本演进记录。 |

> 如需查看详细的 UI、架构与使用说明，请参阅 `MacToDo/README.md` 或 `docs/todolist/USER_MANUAL.md`。

## 主要特性

- SwiftUI + Core Data 本地持久化，数据完全离线。
- MVVM + Repository 解耦：`TaskListViewModel`、`TaskRepository` 负责状态管理与 CRUD。
- 全新的 sketch + glass 视觉主题，支持分类过滤、搜索、智能排序和通知提醒。
- 自动化脚本 `scripts/build_app.sh` 构建 `.app` 与 `.dmg`，并可选择生成自定义图标。
- 测试迁移至 Swift Testing，覆盖持久化、排序与 ViewModel 逻辑。

## 快速开始

```bash
$ git clone https://github.com/zengwenliang416/todolist.git
$ cd todolist/MacToDo
$ swift run            # 开发运行
$ swift test           # 单元测试
```

> 若 `swift test` 因权限无法写入 `~/.cache/clang/ModuleCache`，请在具有写权限的环境运行。

## 构建与发布

```bash
$ cd MacToDo
$ ./scripts/build_app.sh
```

脚本会执行：
1. 生成/更新玻璃手绘图标（依赖 Python 3 + Pillow，可选）。
2. 将 iconset 转换为 `AppIcon.icns`。
3. `swift build -c release` 编译可执行文件。
4. 组装 `.app`，进行 ad-hoc `codesign` 并输出 `MacToDo.dmg`。

产出位于 `MacToDo/` 根目录。

## 仓库结构

```
todolist/
├── MacToDo/
│   ├── Package.swift
│   ├── Resources/
│   ├── Sources/
│   │   ├── Config/
│   │   ├── Model/
│   │   ├── Services/
│   │   ├── ViewModels/
│   │   └── Views/
│   ├── Tests/
│   └── scripts/
├── docs/
│   ├── logo.png
│   ├── todolist/
│   └── optimization/
├── CHANGELOG.md
└── README.md (本文件)
```

## 文档 & 资源

- `MacToDo/README.md`：应用级指南、架构与功能说明。
- `docs/todolist/USER_MANUAL.md`：终端用户手册。
- `docs/optimization/*.md`：MVVM 与性能优化全过程归档。

## 贡献指南

1. Fork & 新建分支（`feature/*` / `fix/*`）。
2. 在 `MacToDo/` 目录运行 `swift test`，必要时执行 `./scripts/build_app.sh` 确保构建链路可用。
3. 更新相关文档（README、CHANGELOG、docs/*），提交 PR 时附带截图或验证说明。
4. 遵循已有的提交拆分策略（功能、测试、文档分别提交），保持 changelog 同步。

## License

尚未添加开源协议。如需公开发布，请先在仓库根目录补充 LICENSE 文件（建议 MIT/Apache-2.0）。
