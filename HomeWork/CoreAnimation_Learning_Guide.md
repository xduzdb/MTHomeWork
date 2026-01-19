# Core Animation 学习指南

## 概述
Core Animation 是 iOS 中强大的动画和图形渲染框架。与 UIView 动画不同，Core Animation 提供了更底层的控制，可以实现更复杂和精细的动画效果。

## 学习路径

### 第一阶段：基础概念 (1-2周)

#### 1. CALayer vs UIView
- **CALayer**: Core Animation 的核心，负责绘制和动画
- **UIView**: 高级封装，每个 UIView 都有一个对应的 CALayer
- **关系**: UIView 是 CALayer 的代理，处理用户交互

```objc
// 访问 layer
CALayer *layer = view.layer;

// 直接操作 layer 属性
layer.cornerRadius = 10.0;
layer.borderWidth = 2.0;
layer.borderColor = [UIColor redColor].CGColor;
```

#### 2. 隐式动画 vs 显式动画
- **隐式动画**: 直接修改 layer 属性时自动触发的动画
- **显式动画**: 使用 CABasicAnimation、CAKeyframeAnimation 等创建的动画

```objc
// 隐式动画（在动画事务中）
[CATransaction begin];
[CATransaction setAnimationDuration:1.0];
layer.position = CGPointMake(200, 200);
[CATransaction commit];

// 显式动画
CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
animation.duration = 1.0;
[layer addAnimation:animation forKey:@"positionAnimation"];
```

#### 3. 常用动画属性
- `position`: 位置
- `bounds`: 边界
- `transform`: 变换（旋转、缩放、平移）
- `opacity`: 透明度
- `backgroundColor`: 背景色
- `cornerRadius`: 圆角
- `borderWidth/borderColor`: 边框

### 第二阶段：动画类型 (2-3周)

#### 1. CABasicAnimation (基础动画)
```objc
CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
animation.fromValue = [NSValue valueWithCGPoint:startPoint];
animation.toValue = [NSValue valueWithCGPoint:endPoint];
animation.duration = 2.0;
animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
animation.fillMode = kCAFillModeForwards;
animation.removedOnCompletion = NO;
[layer addAnimation:animation forKey:@"positionAnimation"];
```

#### 2. CAKeyframeAnimation (关键帧动画)
```objc
CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
animation.values = @[
    [NSValue valueWithCGPoint:CGPointMake(100, 100)],
    [NSValue valueWithCGPoint:CGPointMake(200, 50)],
    [NSValue valueWithCGPoint:CGPointMake(300, 200)],
    [NSValue valueWithCGPoint:CGPointMake(400, 100)]
];
animation.keyTimes = @[@0.0, @0.3, @0.7, @1.0];
animation.duration = 3.0;
[layer addAnimation:animation forKey:@"keyframeAnimation"];
```

#### 3. CASpringAnimation (弹簧动画)
```objc
CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
animation.fromValue = [NSValue valueWithCGPoint:startPoint];
animation.toValue = [NSValue valueWithCGPoint:endPoint];
animation.damping = 10.0;        // 阻尼
animation.stiffness = 100.0;     // 刚度
animation.mass = 1.0;           // 质量
animation.duration = animation.settlingDuration;
[layer addAnimation:animation forKey:@"springAnimation"];
```

#### 4. CAAnimationGroup (动画组)
```objc
CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];

CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
scaleAnimation.toValue = @1.5;

CAAnimationGroup *group = [CAAnimationGroup animation];
group.animations = @[positionAnimation, scaleAnimation];
group.duration = 2.0;
[layer addAnimation:group forKey:@"groupAnimation"];
```

### 第三阶段：高级特性 (3-4周)

#### 1. CADisplayLink (帧同步)
```objc
// 创建显示链接，与屏幕刷新率同步
self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimation)];
[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

- (void)updateAnimation {
    // 每帧更新动画
    self.currentTime += self.displayLink.duration;
    // 更新动画状态
}
```

#### 2. CAShapeLayer (形状图层)
```objc
CAShapeLayer *shapeLayer = [CAShapeLayer layer];
UIBezierPath *path = [UIBezierPath bezierPath];
[path moveToPoint:CGPointMake(0, 0)];
[path addLineToPoint:CGPointMake(100, 100)];
[path addCurveToPoint:CGPointMake(200, 0) 
         controlPoint1:CGPointMake(150, 50) 
         controlPoint2:CGPointMake(150, -50)];

shapeLayer.path = path.CGPath;
shapeLayer.strokeColor = [UIColor redColor].CGColor;
shapeLayer.fillColor = [UIColor clearColor].CGColor;
shapeLayer.lineWidth = 3.0;

// 描边动画
CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
strokeAnimation.fromValue = @0.0;
strokeAnimation.toValue = @1.0;
strokeAnimation.duration = 2.0;
[shapeLayer addAnimation:strokeAnimation forKey:@"strokeAnimation"];
```

#### 3. CAGradientLayer (渐变图层)
```objc
CAGradientLayer *gradientLayer = [CAGradientLayer layer];
gradientLayer.frame = self.view.bounds;
gradientLayer.colors = @[
    (id)[UIColor redColor].CGColor,
    (id)[UIColor yellowColor].CGColor,
    (id)[UIColor blueColor].CGColor
];
gradientLayer.locations = @[@0.0, @0.5, @1.0];
gradientLayer.startPoint = CGPointMake(0, 0);
gradientLayer.endPoint = CGPointMake(1, 1);
[self.view.layer addSublayer:gradientLayer];
```

#### 4. CAEmitterLayer (粒子系统)
```objc
CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
emitterLayer.emitterPosition = CGPointMake(self.view.center.x, 0);
emitterLayer.emitterShape = kCAEmitterLayerLine;
emitterLayer.emitterSize = CGSizeMake(100, 1);

CAEmitterCell *cell = [CAEmitterCell emitterCell];
cell.birthRate = 10;
cell.lifetime = 5.0;
cell.velocity = 100;
cell.velocityRange = 50;
cell.emissionRange = M_PI_2;
cell.scale = 0.1;
cell.scaleRange = 0.05;
cell.contents = (id)[UIImage imageNamed:@"particle"].CGImage;

emitterLayer.emitterCells = @[cell];
[self.view.layer addSublayer:emitterLayer];
```

### 第四阶段：物理引擎集成 (2-3周)

#### 1. 重力系统
```objc
- (void)setupPhysics {
    self.gravity = 0.8;
    self.velocity = CGPointMake(0, 0);
    self.airResistance = 0.98;
}

- (void)updatePhysics {
    // 应用重力
    self.velocity = CGPointMake(
        self.velocity.x * self.airResistance,
        self.velocity.y + self.gravity
    );
    
    // 更新位置
    CGPoint newPosition = CGPointMake(
        self.objectView.center.x + self.velocity.x,
        self.objectView.center.y + self.velocity.y
    );
    
    self.objectView.center = newPosition;
}
```

#### 2. 碰撞检测
```objc
- (BOOL)checkCollision:(CGPoint)point withObject:(UIView *)object {
    CGRect objectFrame = object.frame;
    return CGRectContainsPoint(objectFrame, point);
}

- (void)handleCollision {
    // 反弹效果
    self.velocity = CGPointMake(
        -self.velocity.x * 0.7,
        -self.velocity.y * 0.7
    );
}
```

### 第五阶段：性能优化 (1-2周)

#### 1. 图层优化
```objc
// 启用光栅化（适用于静态内容）
layer.shouldRasterize = YES;
layer.rasterizationScale = [UIScreen mainScreen].scale;

// 设置绘制边界
layer.masksToBounds = YES;

// 优化阴影
layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
```

#### 2. 动画性能
```objc
// 使用 transform 而不是改变 frame
layer.transform = CATransform3DMakeTranslation(x, y, 0);

// 避免在主线程进行复杂计算
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 复杂计算
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新 UI
    });
});
```

## 投篮游戏实现要点

### 1. 物理引擎
- 重力加速度
- 空气阻力
- 碰撞检测
- 反弹系数

### 2. 游戏逻辑
- 投篮力度计算
- 得分判定
- 游戏状态管理
- 动画反馈

### 3. 用户体验
- 流畅的动画
- 视觉反馈
- 音效（可选）
- 难度调节

## 实践项目建议

1. **基础练习**: 实现简单的位移动画
2. **中级练习**: 创建弹性球体动画
3. **高级练习**: 实现完整的投篮游戏
4. **扩展练习**: 添加音效、粒子效果、多人模式

## 学习资源

- [Apple Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)
- [Core Animation 实战](https://www.objc.io/issues/12-animations/)
- [WWDC 相关视频](https://developer.apple.com/videos/)

## 注意事项

1. **内存管理**: 及时清理动画和图层
2. **性能监控**: 使用 Instruments 监控动画性能
3. **兼容性**: 考虑不同设备的性能差异
4. **用户体验**: 动画应该增强而不是干扰用户体验

通过这个学习路径，你将能够从 UIView 动画平滑过渡到 Core Animation，并最终实现复杂的物理游戏效果。 