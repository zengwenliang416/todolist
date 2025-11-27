## 任务完成前检查
1. **编译/运行验证**：至少执行 `swift build` 或 `swift run`，若涉及发布流程需跑 `./scripts/build_app.sh` 确认 .app/.dmg 可生成。
2. **数据一致性**：若改动 Core Data 模型，确保 `PersistenceController` 中的属性/默认值同步，必要时添加迁移说明。
3. **UI 预览/截图**：涉及视图改动建议使用 Xcode 预览或实际运行确认布局（尤其是 Sidebar + List 交互）。
4. **脚本/资源**：若修改脚本或资源（iconset、plist），重新运行构建脚本验证产物完整。
5. **文档更新**：功能、命令或要求改变时同步 `README.md`/`docs`。
6. **代码风格**：检查 SwiftLint（若引入）或遵循现有 SwiftUI 风格，保持命名、注释一致。