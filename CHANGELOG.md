# Changelog

## 2023-11-27
### Added
- 增补 README：涵盖项目概述、架构、安装、测试、脚本与路线图等完整说明，帮助贡献者快速理解并验证 MacToDo。
- 引入 TaskRepository、TaskListViewModel 与 TaskFilteredList，并重构主要 SwiftUI 视图以完成 MVVM 架构升级。

### Tests
- 迁移 PersistenceTests、SortingTests 至 Swift Testing 框架，并补充 ViewModelTests 覆盖排序、筛选与增删逻辑。

### Docs
- 新增 docs/optimization/* 报告，沉淀架构重构、性能优化与交付结果。
