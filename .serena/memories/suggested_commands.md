## 常用命令
- 构建/运行（调试）：`swift run MacToDo`（在 `MacToDo/` 内）
- Release 构建 + 打包 .app/.dmg：`./scripts/build_app.sh`
- SwiftPM 构建：`swift build`（或 `swift build -c release --product MacToDo`）
- 测试（如后续添加 Tests 目录）：`swift test`
- 图标预处理：`python3 scripts/generate_logo.py`（脚本会自动由 build_app.sh 调用）
- 生成 icns：`iconutil -c icns Resources/MacToDo.iconset -o Resources/AppIcon.icns`（build 脚本已包含，单独调试可手动运行）