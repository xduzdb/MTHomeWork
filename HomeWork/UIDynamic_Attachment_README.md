# UIDynamic 吸附行为演示

这个项目包含了多个UIDynamic吸附行为的演示，展示了不同的吸附行为类型和用法。

> **项目概述**: 本项目是iOS UIDynamic框架中吸附行为(UIAttachmentBehavior)的完整演示，包含从简单到复杂的多种实现方式，适合学习和理解UIDynamic物理引擎的使用。

## 文件说明

### 1. AttachmentBehaviorViewController
- **功能**: 基础的吸附行为演示（仿照Swift示例实现）
- **特点**: 
  - 绿色背景板可以拖拽（占据屏幕上半部分）
  - 蓝色球体通过吸附行为连接到背景板
  - 包含红色控制点和连接线显示
  - 展示了复杂的吸附链式连接（背景板→控制点1→控制点2→球体）
  - 实时更新贝塞尔曲线连接线

### 2. AttachmentBehaviorDemoViewController  
- **功能**: 完整的吸附行为演示（最全面的演示）
- **特点**:
  - 红色锚点（固定点，位于屏幕上方）
  - 蓝色被吸附物体（可拖拽的球体）
  - 橙色和绿色控制点（用于贝塞尔曲线控制）
  - 紫色虚线连接显示吸附关系（实时更新）
  - 支持拖拽交互（球体和控制点都可拖拽）
  - 完整的物理效果（重力、碰撞、弹性）

### 3. SimpleAttachmentViewController
- **功能**: 简单的吸附行为演示（适合初学者）
- **特点**:
  - 最基础的吸附行为实现（点到点连接）
  - 红色锚点连接到蓝色球体（简单的直线连接）
  - 支持拖拽体验吸附效果
  - 代码简洁，易于理解
  - 适合UIDynamic入门学习

### 4. MultiAttachmentViewController
- **功能**: 多物体吸附演示（链式连接）
- **特点**:
  - 5个不同颜色的球体（蓝、绿、橙、紫、棕）
  - 链式吸附连接（类似链条效果）
  - 第一个球体连接到锚点
  - 其他球体依次连接到前一个球体
  - 支持拖拽任意球体
  - 真实的物理链式反应

## UIDynamic 吸附行为属性详解

### UIAttachmentBehavior 常用属性

1. **items**: 吸附行为的所有动力项（要连接的UIView对象）
2. **attachedBehaviorType**: 连接类型
   - `items`: 连接到视图view（至少两个动力项，物体间连接）
   - `anchor`: 连接到锚点（只有一个动力项，物体到固定点连接）
3. **anchorPoint**: 动力项吸附的锚点（CGPoint类型，固定位置）
4. **length**: 视图点连接锚点的距离，两个吸附点之间的距离（理想连接长度）
5. **damping**: 阻尼系数（0-1之间），控制弹性减弱的阻力大小
   - 值越小，弹性越强，振动越持久
   - 值越大，弹性越弱，振动越快停止
6. **frequency**: 频率（Hz），控制弹性振动的频率
   - 值越大，振动越快
   - 值越小，振动越慢

## 使用方法

### 基本使用步骤
1. 将任意一个ViewController添加到你的项目中
2. 在需要展示的地方实例化并推入导航栈
3. 体验拖拽交互和吸附效果

### 推荐学习顺序
1. **SimpleAttachmentViewController** - 先理解基础概念
2. **AttachmentBehaviorViewController** - 学习复杂连接
3. **AttachmentBehaviorDemoViewController** - 掌握完整功能
4. **MultiAttachmentViewController** - 实践多物体连接

## 示例代码

### 基础吸附行为创建
```objective-c
// 创建吸附行为 - 连接到锚点
UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] 
    initWithItem:attachedView 
    offsetFromCenter:UIOffsetMake(0, 0) 
    attachedToAnchor:anchorPoint];

// 设置属性
attachment.length = 150;      // 连接长度（理想距离）
attachment.damping = 0.3;     // 阻尼（弹性强度）
attachment.frequency = 1.2;   // 频率（振动速度）

// 添加到动画器
[animator addBehavior:attachment];
```

### 物体间吸附连接
```objective-c
// 创建两个物体之间的吸附
UIAttachmentBehavior *itemAttachment = [[UIAttachmentBehavior alloc] 
    initWithItem:view1 
    offsetFromCenter:UIOffsetMake(0, 0) 
    attachedToItem:view2 
    offsetFromCenter:UIOffsetMake(0, 0)];

itemAttachment.length = 100;     // 物体间距离
itemAttachment.damping = 0.5;    // 阻尼
itemAttachment.frequency = 1.0;  // 频率

[animator addBehavior:itemAttachment];
```

## 注意事项

### 拖拽交互处理
1. **开始拖拽时移除重力行为** - 让用户可以自由拖拽物体
2. **拖拽结束后重新添加重力行为** - 恢复物理效果
3. **使用`updateItemUsingCurrentState:`更新动画器状态** - 通知物理引擎物体位置已改变

### 参数调优
4. **合理设置damping和frequency参数** - 获得理想的弹性效果
   - damping: 0.1-0.9之间，值越小弹性越强
   - frequency: 0.5-5.0之间，值越大振动越快

### 性能优化
5. **避免过多的物理行为** - 影响性能
6. **及时清理不需要的行为** - 防止内存泄漏
7. **使用弱引用避免循环引用** - 在回调中使用`__weak`

## 扩展功能

### 可以基于这些基础演示进一步扩展：
- **添加更多的物理行为** - 如推力(UIPushBehavior)、旋转等
- **实现更复杂的连接关系** - 网状连接、树形连接等
- **添加声音效果** - 碰撞音效、弹性音效
- **实现粒子系统效果** - 结合Core Animation粒子效果
- **添加手势识别** - 多点触控、捏合手势等
- **实现游戏逻辑** - 物理游戏、益智游戏等
- **优化视觉效果** - 阴影、光效、材质等
- **添加动画过渡** - 状态切换动画、加载动画等

### 实际应用场景
- **游戏开发** - 物理引擎、角色控制
- **UI交互** - 弹性菜单、拖拽排序
- **数据可视化** - 动态图表、网络图
- **教育应用** - 物理教学、交互演示 