# Pending Tasks & Recommendations

## Immediate Actions
- None. The current optimization scope is complete.

## Future Enhancements
1. **Category Management**
   - Currently, categories are hardcoded enums. Migrating them to a Core Data entity would allow users to create custom categories.
2. **CloudKit Sync**
   - Enable `NSPersistentCloudKitContainer` to sync tasks across devices (iOS/iPadOS).
3. **Empty States**
   - Add visual empty states for the task list when no tasks match the filter.
4. **Localization**
   - Extract hardcoded strings to `Localizable.strings` for multi-language support.
5. **UI Testing**
   - Add XCUITest or Swift Testing UI tests to verify user interactions automatically.
