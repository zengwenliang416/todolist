## 代码风格与约定
- 使用 Swift 5.9 + SwiftUI：`struct Foo: View` + `var body: some View` 模式，组合式视图拆在 `Sources/Views`，常用 `NavigationView`、`List`、`ToolbarItem`
- 状态管理：`@State`、`@Binding`、`@Environment(\.managedObjectContext)`；靠 `PersistenceController` 单例注入 Core Data Context
- Core Data 模型通过代码定义 (`NSAttributeDescription`)，模型扩展添加 wrapped 属性以减少可选判断
- 视图/模型命名沿用大驼峰，属性小驼峰，常用 `wrappedX` 提供非可选值
- 注释以英文句首说明用途（如“Helper to get non-optional values for View”），仅对非自解释逻辑补充
- 资源/脚本命名：`MacToDo.iconset`、`build_app.sh`，脚本内大量 emoji 日志，保持即可