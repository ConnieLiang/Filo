# iOS Widget — Dev Spec

## 1. 目标

在 iOS 桌面提供 Small / Medium / Large 三种 Widget：展示未读邮件、待办、快捷入口；支持点击跳转与 Todo 勾选完成。

## 2. 规范依据

1. HIG Widgets: [https://developer.apple.com/design/human-interface-guidelines/widgets/](https://developer.apple.com/design/human-interface-guidelines/widgets/)
2. WidgetKit: [https://developer.apple.com/documentation/widgetkit](https://developer.apple.com/documentation/widgetkit)
3. 设计资源（颜色/字体/图标统一来源）: [https://github.com/FiloAI/filo-design/tree/main/resources](https://github.com/FiloAI/filo-design/tree/main/resources)

## 3. 平台与范围

1. 平台：iOS（WidgetKit）
2. 尺寸：`systemSmall` / `systemMedium` / `systemLarge`
3. 交互：iOS 17+（Todo checkbox 通过 AppIntent）

## 4. 外观模式）

必须支持：

1. Full-color
2. Clear
3. Tinted

实现要求：

1. 使用 `@Environment(\.widgetRenderingMode)` 控制样式。
2. 可着色前景元素使用 `.widgetAccentable()`。
3. 图标/图片按需使用 `.widgetAccentedRenderingMode(...)`。
4. 使用 `containerBackground(for: .widget)`，确保 clear/tinted 可读。
5. 禁止写死导致 tinted 不可读的颜色。

## 5. PM 需求

### 5.1 Small

数据态：

1. 标题：`✨ FILO SUMMARY`
2. 未读：邮件图标 + 数字 + `Emails`
3. 待办：Todo 图标 + 数字 + `To-dos`

空态：

1. `All clear! No to-dos or unread emails.`

点击：

1. 整个 Widget -> 打开 Filo 首页（建议 `filo://inbox` 或产品定义主页路由）

### 5.2 Medium

默认：邮件列表（Inbox - Important），账号=所有账号。

邮件模式：

1. 标题：`✨ FILO SUMMARY` + `X Emails / X To-dos`
2. 左侧：邮件图标 + Todo 图标（纵向）
3. 右侧：未读邮件列表（发件人+摘要+时间），最多 3 条

Todo 模式：

1. 标题同上
2. 左侧同上
3. 右侧：Todo 列表（标题+截止日期），最多 4 条
4. 每条支持 checkbox 完成

空态：

1. `0 Emails / 0 To-dos`
2. `You're all caught up! No pending to-dos or emails.`

点击：

1. 邮件项 -> 邮件详情
2. Todo 项 -> Todo 详情
3. Todo checkbox -> 完成 Todo

### 5.3 Large

默认：邮件列表（Inbox - Important），账号=所有账号。

结构：

1. 标题：`✨ FILO SUMMARY`
2. 统计卡：未读卡 + Todo 卡
3. 快捷入口：`To-dos / AI Chat / Inbox / Compose`
4. 列表区：

- 邮件模式最多 4 条
- Todo 模式最多 6 条（含 checkbox）

空态：

1. 统计 `0 / 0`
2. 快捷入口保留
3. `Nothing on your plate. Enjoy your day!`

点击：

1. 统计卡 -> 对应列表页
2. 快捷入口 -> 对应功能页
3. 列表项 -> 详情页
4. Todo checkbox -> 完成 Todo

### 5.4 编辑小组件（仅 Medium / Large）

1. 账号：所有账号（默认）/ 指定邮箱
2. 视图：邮件列表（默认）/ Todo 列表
3. 邮件标签（仅邮件模式）：`Important / Updates / Promotions ...`

Small 不支持编辑配置。

### 5.5 数据规则

邮件：

1. 仅未读
2. 按时间倒序
3. 按账号+标签过滤

Todo：

1. 仅未完成
2. 排除 `Suggested Done`
3. 排序：`Past Due -> Today -> Upcoming`
4. 按账号过滤

### 5.6 深链接

1. `filo://inbox`
2. `filo://todos`
3. `filo://todo/{id}`
4. `filo://compose`
5. `filo://ai-chat`

### 5.7 空态文案（必须逐字一致）

1. Small: `All clear! No to-dos or unread emails.`
2. Medium: `You're all caught up! No pending to-dos or emails.`
3. Large: `Nothing on your plate. Enjoy your day!`

## 6. iOS 实现建议

1. `FiloSummaryWidget`
2. `FiloSummaryProvider`（`AppIntentTimelineProvider`）
3. `FiloSummaryEntry`（计数/列表/模式/账号/时间戳）
4. `SmallWidgetView` / `MediumWidgetView` / `LargeWidgetView`
5. `CompleteTodoIntent(todoId)`（iOS 17+）

配置模型（`AppIntentConfiguration`）：

1. `accountId: String?`（`nil`=所有账号）
2. `contentMode: emails | todos`
3. `mailLabel: Important | Updates | Promotions | ...`（仅 emails 生效）

刷新策略：

1. Timeline 周期刷新
2. 数据变更/回前台时调用 `WidgetCenter.shared.reloadTimelines(ofKind:)`

## 7. 验收清单

1. 三尺寸内容与交互符合需求。
2. Full-color / Clear / Tinted 三模式可读且视觉稳定。
3. Medium/Large 编辑配置可用（账号、模式、标签）。
4. 深链接全部正确。
5. Todo checkbox（iOS 17+）可执行并刷新。
6. 空态文案逐字匹配。

