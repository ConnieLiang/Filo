# Filo 设计师工具指南
### 在 AI 驱动的工程流里，用对工具比用多工具重要

---

## 先理解三端的现实

Filo 有三个独立的代码库，各自用不同语言实现：

| 平台 | 仓库 | 技术栈 |
|------|------|--------|
| Desktop (Mac/Win) | `FiloAI/filo-desktop` | Electron + React + Radix UI |
| iOS | `FiloAI/filo-ios` | Swift 原生 |
| Android | `FiloAI/filo-android` | Kotlin 原生 |

**这意味着：没有任何一份设计稿能"直接还原"到三端。** 每个平台的工程师都在用自己的语言重新实现。你的价值不是出一份让三端都还原的图，而是**定义清楚规则和交互逻辑，让三端工程师各自遵守**。

---

## 你的核心输出：design/ 目录

在 GitHub 创建一个所有人都能访问的设计文档目录。建议放在 `FiloAI/filo-desktop` 仓库下（Desktop 是主力，其他端工程师也能看到）：

```
design/
├── tokens.json              # 颜色、字体、间距（三端共同参考）
├── principles.md            # 产品设计原则
├── features/                # 每个功能的交互规范
│   ├── email-list.md
│   ├── compose.md
│   └── ...
└── platform-notes/          # 各端差异说明
    ├── ios.md
    ├── android.md
    └── desktop.md
```

---

## 各平台具体怎么参与

### Desktop（filo-desktop）— 你可以直接出代码

Desktop 用的是 React + Radix UI，你可以用 **MagicPatterns** 或 **v0.dev** 直接生成组件代码，提 PR 进这个仓库。

**用 MagicPatterns 出组件的步骤：**
1. 打开 https://www.magicpatterns.com
2. 导入 `design/tokens.json`（颜色、间距规范）
3. 描述你要的组件，例如：
   > 「邮件列表项，左侧圆形头像，右侧发件人名称加粗、主题、时间，未读状态左侧蓝点，hover 背景变浅灰，使用 Tailwind 和 Radix」
4. 调整到满意，代码提 PR 到 `filo-desktop/src/components/` 目录

**Design QA 怎么做：**
- 拿到最新 Desktop build，跑一遍主流程
- 发现视觉或交互问题，开 GitHub Issue，标签 `design-qa`
- Issue 里附截图 + 期望效果描述

---

### iOS（filo-ios）— 你出规范，工程师实现

iOS 是 Swift 原生，你无法直接生成代码。你的工作是写清楚交互规范，iOS 工程师根据文档实现。

**你需要了解的仓库结构：**
- `FiloApp/Assets.xcassets` — 图标和图片资源，你可以提供设计好的图标文件（.png）放进来
- `FiloApp/bean/` / `FiloApp/model/` — 数据结构，了解有哪些数据字段，帮你写规范时更准确
- `CLAUDE.md` — 项目说明，值得读一遍了解整体架构

**你的交互规范要特别写清楚 iOS 的：**
- 手势：左滑删除/归档、长按操作菜单
- 系统组件：用原生 Sheet、Alert 还是自定义
- 导航模式：Push 还是 Modal
- 适配：深色模式、动态字体大小

**图标/图片资源提交方式：**
直接把 `.png` 文件（1x/2x/3x 三种尺寸）放进 `FiloApp/Assets.xcassets/` 对应目录，提 PR 即可。

---

### Android（filo-android）— 你出规范，也可以提颜色/图标资源

Android 是 Kotlin 原生，同样靠规范文档驱动，但有几个资源目录可以直接参与：

**你可以直接操作的目录：**
- `app/src/main/res/drawable/` — 图标 SVG/PNG 资源
- `app/src/main/res/color/` — 颜色定义（XML 格式），可以对照 tokens.json 提 PR 更新颜色
- `app/src/main/res/drawable-night/` — 深色模式专用图标

**颜色文件格式（Android XML）：**
```xml
<!-- res/color/primary.xml -->
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:color="#2563EB"/>
</selector>
```

**你的交互规范要特别写清楚 Android 的：**
- 返回逻辑：系统返回键/手势的行为
- Material Design 规范遵守程度（Filo 是否跟随系统风格）
- 通知样式：大图通知、操作按钮
- 权限申请时机和文案

---

## 找参考的工具

**Mobbin**（https://mobbin.com）— iOS/Android 移动端参考
- 搜「email」「compose」「empty state」「onboarding」
- 找真实 App 的 UI 截图，快速定位参考
- Pro $10/月（年付）

**Interface Index**（https://interfaceindex.com）— Desktop 端参考
- 专收 Desktop/SaaS 应用的 UI 组件截图
- 侧边栏、工具栏、列表、弹窗等桌面端组件的最佳实践
- 免费

---

## Cursor 的正确用法

你已有 Cursor 企业版，用它**看代码**，不是处理 Figma。

✅ 正确用法：
- 打开任意仓库，问「这个文件是干什么的」
- 查「现在 filo-ios 里邮件列表的 UI 实现在哪里」
- 理解三端的实现差异，帮你写更准确的规范

❌ 禁止用法：
- 上传 Figma 文件或截图让 Cursor 解析
- 让 Cursor 生成大段设计规范文档
- 任何「把 Figma 投喂给 AI」的操作

---

## 第一周任务

**Day 1-2：整理 design/tokens.json**
把 Filo 现有的颜色、字体、间距整理成以下格式，PR 提交到 `filo-desktop/design/tokens.json`：

```json
{
  "color": {
    "primary": "#你们实际用的色值",
    "background": "#...",
    "text-primary": "#...",
    "text-secondary": "#...",
    "border": "#..."
  },
  "fontSize": {
    "xs": "11px", "sm": "12px", "md": "14px", "lg": "16px", "xl": "18px"
  },
  "spacing": {
    "xs": "4px", "sm": "8px", "md": "12px", "lg": "16px", "xl": "24px"
  },
  "radius": {
    "sm": "6px", "md": "10px", "lg": "16px"
  }
}
```

**Day 3：MagicPatterns 上手**
用邮件列表组件练手一次，感受工具。不需要提交，先熟悉。

**Day 4-5：写第一份功能规范**
选一个近期要开发的功能，写 `design/features/功能名.md`，三端差异都要写到。提交后让每个端的工程师反馈「这个文档对你有用吗？」

---

## 记住一件事

**你的价值不是画图，是判断。**

「这个手势在 iOS 上感觉不对」「Android 返回逻辑有问题」「Desktop 这个弹窗打断了用户的操作流」——这些判断是 AI 和工程师都给不了的。

把这种判断转化成文档和 Issue，就是你最核心的贡献。

*遇到问题随时问。*
