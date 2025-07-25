//
//  AnimationViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

// 动画控制按钮
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 演示动画的视图
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIView *greenLineView;
@property (nonatomic, strong) UIImageView *animationImageView;

// 按钮数组
@property (nonatomic, strong) NSArray<UIButton *> *animationButtons;

// 动画状态
@property (nonatomic, assign) BOOL isAnimating;

// UIDynamic 相关属性
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) NSMutableArray<UIView *> *dynamicViews;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self setupDynamics];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"UIView动画演示";
    self.navigationItem.backButtonTitle = @"";
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
    
    // 创建动画演示区域
    self.animationView = [[UIView alloc] init];
    self.animationView.backgroundColor = [UIColor systemBlueColor];
    self.animationView.layer.cornerRadius = 25;
    self.animationView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.animationView];
    
    // 创建绿色横线
    self.greenLineView = [[UIView alloc] init];
    self.greenLineView.backgroundColor = [UIColor systemGreenColor];
    self.greenLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.animationView addSubview:self.greenLineView];
    
    // 创建图片视图用于更复杂的动画
    self.animationImageView = [[UIImageView alloc] init];
    self.animationImageView.backgroundColor = [UIColor systemRedColor];
    self.animationImageView.layer.cornerRadius = 15;
    self.animationImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.animationImageView];
    
    // 创建按钮
    [self createAnimationButtons];
}

- (void)createAnimationButtons {
    // UIView 动画组
    NSArray *uiViewAnimations = @[
        @"位置移动动画",
        @"缩放动画", 
        @"旋转动画",
        @"透明度动画",
        @"弹簧动画",
        @"关键帧动画",
        @"组合动画",
        @"连续动画",
        @"尺寸变化动画"
    ];
    
    // CoreAnimation 动画组
    NSArray *coreAnimations = @[
        @"摇摆动画",
        @"脉冲动画",
        @"翻转动画",
        @"弹跳动画",
        @"渐变背景动画",
        @"路径动画",
        @"3D旋转动画",
        @"阴影动画",
        @"边框动画",
        @"渐变层动画",
        @"形状路径动画",
        @"粒子效果动画",
        @"动画组合",
        @"缓动函数动画",
        @"图片序列动画"
    ];
    
    // UIDynamic 动画组
    NSArray *dynamicAnimations = @[
        @"重力动画",
        @"碰撞动画",
        @"弹簧连接动画",
        @"推力动画",
        @"附着动画",
        @"物理摆动画",
        @"磁力场动画",
        @"涡流场动画",
        @"噪声场动画",
        @"弹性碰撞动画",
        @"流体阻力动画",
        @"多物体链条动画",
        @"物理弹球动画",
        @"重力井动画",
        @"物理布料动画"
    ];
    
    // 工具按钮
    NSArray *utilityButtons = @[@"重置位置"];
    
    NSMutableArray *buttons = [NSMutableArray array];
    NSInteger buttonIndex = 0;
    
    // 创建分组标题
    [self createSectionLabel:@"UIView 动画" atIndex:0];
    
    // 创建UIView动画按钮
    for (NSString *title in uiViewAnimations) {
        UIButton *button = [self createButtonWithTitle:title tag:buttonIndex];
        [buttons addObject:button];
        buttonIndex++;
    }
    
    // 创建CoreAnimation分组标题
    [self createSectionLabel:@"CoreAnimation 动画" atIndex:uiViewAnimations.count + 1];
    
    // 创建CoreAnimation动画按钮
    for (NSString *title in coreAnimations) {
        UIButton *button = [self createButtonWithTitle:title tag:buttonIndex];
        [buttons addObject:button];
        buttonIndex++;
    }
    
    // 创建UIDynamic分组标题
    [self createSectionLabel:@"UIDynamic 物理动画" atIndex:uiViewAnimations.count + coreAnimations.count + 2];
    
    // 创建UIDynamic动画按钮
    for (NSString *title in dynamicAnimations) {
        UIButton *button = [self createButtonWithTitle:title tag:buttonIndex];
        [buttons addObject:button];
        buttonIndex++;
    }
    
    // 创建工具分组标题
    [self createSectionLabel:@"工具" atIndex:uiViewAnimations.count + coreAnimations.count + dynamicAnimations.count + 3];
    
    // 创建工具按钮
    for (NSString *title in utilityButtons) {
        UIButton *button = [self createButtonWithTitle:title tag:buttonIndex];
        button.backgroundColor = [UIColor systemGrayColor]; // 工具按钮使用不同颜色
        [buttons addObject:button];
        buttonIndex++;
    }
    
    self.animationButtons = [buttons copy];
}

// 创建分组标题
- (void)createSectionLabel:(NSString *)title atIndex:(NSInteger)index {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.text = title;
    sectionLabel.font = [UIFont boldSystemFontOfSize:16];
    sectionLabel.textColor = [UIColor labelColor];
    sectionLabel.backgroundColor = [UIColor systemBackgroundColor];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    sectionLabel.tag = 10000 + index; // 使用特殊tag区分标题和按钮
    [self.contentView addSubview:sectionLabel];
}

// 创建按钮的辅助方法
- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius = 8;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = tag;
    [button addTarget:self action:@selector(animationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    return button;
}

- (void)setupLayout {
    // 滚动视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // 内容视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];
    
    // 动画视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.animationView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.animationView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.animationView.widthAnchor constraintEqualToConstant:50],
        [self.animationView.heightAnchor constraintEqualToConstant:50]
    ]];
    
    // 绿色横线约束
    [NSLayoutConstraint activateConstraints:@[
        [self.greenLineView.centerYAnchor constraintEqualToAnchor:self.animationView.centerYAnchor],
        [self.greenLineView.leadingAnchor constraintEqualToAnchor:self.animationView.leadingAnchor constant:8],
        [self.greenLineView.trailingAnchor constraintEqualToAnchor:self.animationView.trailingAnchor constant:-8],
        [self.greenLineView.heightAnchor constraintEqualToConstant:3]
    ]];
    
    // 图片视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.animationImageView.topAnchor constraintEqualToAnchor:self.animationView.bottomAnchor constant:20],
        [self.animationImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.animationImageView.widthAnchor constraintEqualToConstant:30],
        [self.animationImageView.heightAnchor constraintEqualToConstant:30]
    ]];
    
    // 设置分组按钮布局
    [self setupGroupedButtonLayout];
}

- (void)setupDynamics {
    // 初始化UIDynamic相关组件
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
    self.dynamicViews = [NSMutableArray array];
}

- (void)setupGroupedButtonLayout {
    CGFloat buttonWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - 60) / 3;
    CGFloat buttonHeight = 40;
    CGFloat spacing = 10;
    CGFloat sectionSpacing = 20;
    CGFloat currentY = 30;
    
    // 分组信息
    NSArray *groupSizes = @[@9, @15, @15, @1]; // UIView:9, CoreAnimation:15, UIDynamic:15, 工具:1
    NSArray *groupTitles = @[@"UIView 动画", @"CoreAnimation 动画", @"UIDynamic 物理动画", @"工具"];
    
    NSInteger buttonIndex = 0;
    
    for (NSInteger group = 0; group < groupSizes.count; group++) {
        NSInteger groupSize = [groupSizes[group] integerValue];
        
        // 设置分组标题
        UILabel *sectionLabel = [self.contentView viewWithTag:10000 + (group == 0 ? 0 : (group == 1 ? 10 : (group == 2 ? 26 : 42)))];
        if (sectionLabel) {
            [NSLayoutConstraint activateConstraints:@[
                [sectionLabel.topAnchor constraintEqualToAnchor:self.animationImageView.bottomAnchor constant:currentY],
                [sectionLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
                [sectionLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
                [sectionLabel.heightAnchor constraintEqualToConstant:30]
            ]];
            currentY += 40;
        }
        
        // 设置该组的按钮
        for (NSInteger i = 0; i < groupSize; i++) {
            if (buttonIndex < self.animationButtons.count) {
                UIButton *button = self.animationButtons[buttonIndex];
                NSInteger row = i / 3;
                NSInteger col = i % 3;
                
                [NSLayoutConstraint activateConstraints:@[
                    [button.topAnchor constraintEqualToAnchor:self.animationImageView.bottomAnchor constant:currentY + row * (buttonHeight + spacing)],
                    [button.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20 + col * (buttonWidth + spacing)],
                    [button.widthAnchor constraintEqualToConstant:buttonWidth],
                    [button.heightAnchor constraintEqualToConstant:buttonHeight]
                ]];
                buttonIndex++;
            }
        }
        
        // 计算下一组的起始Y位置
        NSInteger rows = (groupSize + 2) / 3; // 向上取整
        currentY += rows * (buttonHeight + spacing) + sectionSpacing;
    }
    
    // 设置内容视图高度
    if (self.animationButtons.count > 0) {
        UIButton *lastButton = [self.animationButtons lastObject];
        [self.contentView.bottomAnchor constraintGreaterThanOrEqualToAnchor:lastButton.bottomAnchor constant:50].active = YES;
    }
}

- (void)animationButtonTapped:(UIButton *)sender {
    if (self.isAnimating) return;
    
    switch (sender.tag) {
        case 0:
            [self positionAnimation];
            break;
        case 1:
            [self scaleAnimation];
            break;
        case 2:
            [self rotationAnimation];
            break;
        case 3:
            [self fadeAnimation];
            break;
        case 4:
            [self springAnimation];
            break;
        case 5:
            [self keyframeAnimation];
            break;
        case 6:
            [self combinedAnimation];
            break;
        case 7:
            [self sequentialAnimation];
            break;
        case 8:
            [self shakeAnimation];
            break;
        case 9:
            [self pulseAnimation];
            break;
        case 10:
            [self flipAnimation];
            break;
        case 11:
            [self bounceAnimation];
            break;
        case 12:
            [self backgroundColorAnimation];
            break;
        case 13:
            [self pathAnimation];
            break;
        case 14:
            [self transform3DAnimation];
            break;
        case 15:
            [self shadowAnimation];
            break;
        case 16:
            [self borderAnimation];
            break;
        case 17:
            [self gradientLayerAnimation];
            break;
        case 18:
            [self shapePathAnimation];
            break;
        case 19:
            [self particleAnimation];
            break;
        case 20:
            [self animationGroupAnimation];
            break;
        case 21:
            [self timingFunctionAnimation];
            break;
        case 22:
            [self sizeChangeAnimation];
            break;
        case 23:
            [self imageSequenceAnimation];
            break;
        case 24:
            [self gravityAnimation];
            break;
        case 25:
            [self collisionAnimation];
            break;
        case 26:
            [self springAttachmentAnimation];
            break;
        case 27:
            [self pushAnimation];
            break;
        case 28:
            [self attachmentAnimation];
            break;
        case 29:
            [self pendulumAnimation];
            break;
        case 30:
            [self magneticFieldAnimation];
            break;
        case 31:
            [self vortexFieldAnimation];
            break;
        case 32:
            [self noiseFieldAnimation];
            break;
        case 33:
            [self elasticCollisionAnimation];
            break;
        case 34:
            [self fluidResistanceAnimation];
            break;
        case 35:
            [self chainAnimation];
            break;
        case 36:
            [self pinballAnimation];
            break;
        case 37:
            [self gravityWellAnimation];
            break;
        case 38:
            [self clothSimulationAnimation];
            break;
        case 39:
            [self resetPosition];
            break;
        default:
            break;
    }
}

#pragma mark - 动画方法

// 位置移动动画
- (void)positionAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:1.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(100, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.animationView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 缩放动画
- (void)scaleAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
        self.animationView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animationView.layer removeAllAnimations];
        self.animationView.transform = CGAffineTransformIdentity;
        self.isAnimating = NO;
    });
}

// 旋转动画
- (void)rotationAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:1.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self.animationView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    } completion:^(BOOL finished) {
        self.animationView.transform = CGAffineTransformIdentity;
        self.isAnimating = NO;
    }];
}

// 透明度动画
- (void)fadeAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.animationView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.animationView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 弹簧动画
- (void)springAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:2.0 
                          delay:0 
         usingSpringWithDamping:0.3 
          initialSpringVelocity:0.5 
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(0, 100);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.animationView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 关键帧动画
- (void)keyframeAnimation {
    self.isAnimating = YES;
    
    [UIView animateKeyframesWithDuration:3.0 
                                   delay:0 
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear 
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(80, 0);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(80, 80);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(-80, 80);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            self.animationView.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

// 组合动画
- (void)combinedAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:2.0 animations:^{
        self.animationView.transform = CGAffineTransformConcat(
            CGAffineTransformMakeScale(1.5, 1.5),
            CGAffineTransformMakeRotation(M_PI)
        );
        self.animationView.backgroundColor = [UIColor systemPurpleColor];
        self.animationView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.animationView.transform = CGAffineTransformIdentity;
            self.animationView.backgroundColor = [UIColor systemBlueColor];
            self.animationView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 连续动画
- (void)sequentialAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(50, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(50, 50);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.animationView.transform = CGAffineTransformMakeTranslation(0, 50);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.animationView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    self.isAnimating = NO;
                }];
            }];
        }];
    }];
}

// 摇摆动画
- (void)shakeAnimation {
    self.isAnimating = YES;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@0, @-10, @10, @-10, @10, @-5, @5, @0];
    animation.duration = 0.8;
    animation.repeatCount = 3;
    
    [self.animationView.layer addAnimation:animation forKey:@"shake"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 脉冲动画
- (void)pulseAnimation {
    self.isAnimating = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1.0;
    animation.toValue = @1.3;
    animation.duration = 0.6;
    animation.autoreverses = YES;
    animation.repeatCount = 4;
    
    [self.animationView.layer addAnimation:animation forKey:@"pulse"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 翻转动画
- (void)flipAnimation {
    self.isAnimating = YES;
    
    [UIView transitionWithView:self.animationView 
                      duration:1.0 
                       options:UIViewAnimationOptionTransitionFlipFromLeft 
                    animations:^{
        self.animationView.backgroundColor = [UIColor systemOrangeColor];
    } completion:^(BOOL finished) {
        [UIView transitionWithView:self.animationView 
                          duration:1.0 
                           options:UIViewAnimationOptionTransitionFlipFromRight 
                        animations:^{
            self.animationView.backgroundColor = [UIColor systemBlueColor];
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 弹跳动画
- (void)bounceAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(0, -30);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 
                              delay:0 
             usingSpringWithDamping:0.4 
              initialSpringVelocity:0.8 
                            options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
            self.animationView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 渐变背景动画
- (void)backgroundColorAnimation {
    self.isAnimating = YES;
    
    NSArray *colors = @[
        [UIColor systemRedColor],
        [UIColor systemOrangeColor], 
        [UIColor systemYellowColor],
        [UIColor systemGreenColor],
        [UIColor systemBlueColor],
        [UIColor systemPurpleColor]
    ];
    
    __block NSInteger colorIndex = 0;
    __block void (^animateNextColor)(void);
    
    animateNextColor = ^{
        if (colorIndex < colors.count) {
            [UIView animateWithDuration:0.5 animations:^{
                self.animationView.backgroundColor = colors[colorIndex];
            } completion:^(BOOL finished) {
                colorIndex++;
                if (colorIndex < colors.count) {
                    animateNextColor();
                } else {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.animationView.backgroundColor = [UIColor systemBlueColor];
                    } completion:^(BOOL finished) {
                        self.isAnimating = NO;
                    }];
                }
            }];
        }
    };
    
    animateNextColor();
}

// 路径动画
- (void)pathAnimation {
    self.isAnimating = YES;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.animationImageView.center];
    [path addQuadCurveToPoint:CGPointMake(self.animationImageView.center.x + 100, self.animationImageView.center.y) 
                 controlPoint:CGPointMake(self.animationImageView.center.x + 50, self.animationImageView.center.y - 50)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = 2.0;
    animation.autoreverses = YES;
    
    [self.animationImageView.layer addAnimation:animation forKey:@"path"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 3D旋转动画
- (void)transform3DAnimation {
    self.isAnimating = YES;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0; // 透视效果
    transform = CATransform3DRotate(transform, M_PI, 1, 1, 0);
    
    [UIView animateWithDuration:2.0 animations:^{
        self.animationView.layer.transform = transform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.animationView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 阴影动画
- (void)shadowAnimation {
    self.isAnimating = YES;
    
    self.animationView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.animationView.layer.shadowOpacity = 0;
    self.animationView.layer.shadowOffset = CGSizeMake(0, 0);
    self.animationView.layer.shadowRadius = 0;
    
    CABasicAnimation *shadowOpacity = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacity.fromValue = @0;
    shadowOpacity.toValue = @0.8;
    shadowOpacity.duration = 1.0;
    shadowOpacity.autoreverses = YES;
    shadowOpacity.repeatCount = 2;
    
    CABasicAnimation *shadowRadius = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    shadowRadius.fromValue = @0;
    shadowRadius.toValue = @20;
    shadowRadius.duration = 1.0;
    shadowRadius.autoreverses = YES;
    shadowRadius.repeatCount = 2;
    
    CABasicAnimation *shadowOffset = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
    shadowOffset.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    shadowOffset.toValue = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
    shadowOffset.duration = 1.0;
    shadowOffset.autoreverses = YES;
    shadowOffset.repeatCount = 2;
    
    [self.animationView.layer addAnimation:shadowOpacity forKey:@"shadowOpacity"];
    [self.animationView.layer addAnimation:shadowRadius forKey:@"shadowRadius"];
    [self.animationView.layer addAnimation:shadowOffset forKey:@"shadowOffset"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animationView.layer.shadowOpacity = 0;
        self.animationView.layer.shadowRadius = 0;
        self.animationView.layer.shadowOffset = CGSizeMake(0, 0);
        self.isAnimating = NO;
    });
}

// 边框动画
- (void)borderAnimation {
    self.isAnimating = YES;
    
    self.animationView.layer.borderWidth = 0;
    self.animationView.layer.borderColor = [UIColor systemRedColor].CGColor;
    
    CABasicAnimation *borderWidth = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    borderWidth.fromValue = @0;
    borderWidth.toValue = @5;
    borderWidth.duration = 1.0;
    borderWidth.autoreverses = YES;
    borderWidth.repeatCount = 2;
    
    CAKeyframeAnimation *borderColor = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
    borderColor.values = @[
        (id)[UIColor systemRedColor].CGColor,
        (id)[UIColor systemOrangeColor].CGColor,
        (id)[UIColor systemYellowColor].CGColor,
        (id)[UIColor systemGreenColor].CGColor,
        (id)[UIColor systemBlueColor].CGColor,
        (id)[UIColor systemPurpleColor].CGColor
    ];
    borderColor.duration = 4.0;
    
    [self.animationView.layer addAnimation:borderWidth forKey:@"borderWidth"];
    [self.animationView.layer addAnimation:borderColor forKey:@"borderColor"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animationView.layer.borderWidth = 0;
        self.isAnimating = NO;
    });
}

// 渐变层动画
- (void)gradientLayerAnimation {
    self.isAnimating = YES;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.animationView.bounds;
    gradientLayer.colors = @[
        (id)[UIColor systemRedColor].CGColor,
        (id)[UIColor systemBlueColor].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.cornerRadius = 25;
    
    [self.animationView.layer addSublayer:gradientLayer];
    
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnimation.fromValue = @[
        (id)[UIColor systemRedColor].CGColor,
        (id)[UIColor systemBlueColor].CGColor
    ];
    colorAnimation.toValue = @[
        (id)[UIColor systemPurpleColor].CGColor,
        (id)[UIColor systemOrangeColor].CGColor
    ];
    colorAnimation.duration = 2.0;
    colorAnimation.autoreverses = YES;
    
    CABasicAnimation *pointAnimation = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    pointAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    pointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    pointAnimation.duration = 2.0;
    pointAnimation.autoreverses = YES;
    
    [gradientLayer addAnimation:colorAnimation forKey:@"colors"];
    [gradientLayer addAnimation:pointAnimation forKey:@"endPoint"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [gradientLayer removeFromSuperlayer];
        self.isAnimating = NO;
    });
}

// 形状路径动画
- (void)shapePathAnimation {
    self.isAnimating = YES;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.animationView.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor systemYellowColor].CGColor;
    shapeLayer.lineWidth = 3;
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 30, 30)];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRect:CGRectMake(5, 5, 40, 40)];
    
    shapeLayer.path = startPath.CGPath;
    [self.animationView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)startPath.CGPath;
    pathAnimation.toValue = (__bridge id)endPath.CGPath;
    pathAnimation.duration = 2.0;
    pathAnimation.autoreverses = YES;
    pathAnimation.repeatCount = 2;
    
    [shapeLayer addAnimation:pathAnimation forKey:@"path"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shapeLayer removeFromSuperlayer];
        self.isAnimating = NO;
    });
}

// 粒子效果动画
- (void)particleAnimation {
    self.isAnimating = YES;
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = self.animationView.center;
    emitterLayer.emitterShape = kCAEmitterLayerCircle;
    emitterLayer.emitterSize = CGSizeMake(10, 10);
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 50;
    cell.lifetime = 2.0;
    cell.velocity = 100;
    cell.velocityRange = 50;
    cell.emissionRange = 2 * M_PI;
    cell.contents = (id)[UIImage imageWithData:[self createParticleImageData]].CGImage;
    cell.scale = 0.1;
    cell.scaleRange = 0.05;
    cell.alphaSpeed = -0.5;
    
    emitterLayer.emitterCells = @[cell];
    [self.view.layer addSublayer:emitterLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [emitterLayer removeFromSuperlayer];
        self.isAnimating = NO;
    });
}

// 创建粒子图像数据
- (NSData *)createParticleImageData {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor systemYellowColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 10, 10));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

// 动画组合
- (void)animationGroupAnimation {
    self.isAnimating = YES;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3.0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = @1.5;
    scaleAnimation.autoreverses = YES;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2 * M_PI);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0;
    opacityAnimation.toValue = @0.3;
    opacityAnimation.autoreverses = YES;
    
    animationGroup.animations = @[scaleAnimation, rotationAnimation, opacityAnimation];
    
    [self.animationView.layer addAnimation:animationGroup forKey:@"group"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 缓动函数动画
- (void)timingFunctionAnimation {
    self.isAnimating = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = @0;
    animation.toValue = @100;
    animation.duration = 2.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.autoreverses = YES;
    
    [self.animationView.layer addAnimation:animation forKey:@"timing"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 尺寸变化动画
- (void)sizeChangeAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.animationView.frame;
        frame.size.width = 100;
        frame.size.height = 100;
        self.animationView.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            CGRect frame = self.animationView.frame;
            frame.size.width = 50;
            frame.size.height = 50;
            self.animationView.frame = frame;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 图片序列动画
- (void)imageSequenceAnimation {
    self.isAnimating = YES;
    
    NSMutableArray *images = [NSMutableArray array];
    
    // 创建一系列不同颜色的图片作为动画帧
    NSArray *colors = @[
        [UIColor systemRedColor],
        [UIColor systemOrangeColor],
        [UIColor systemYellowColor],
        [UIColor systemGreenColor],
        [UIColor systemBlueColor],
        [UIColor systemPurpleColor]
    ];
    
    for (UIColor *color in colors) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, 30, 30));
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
    }
    
    self.animationImageView.animationImages = images;
    self.animationImageView.animationDuration = 1.5;
    self.animationImageView.animationRepeatCount = 3;
    [self.animationImageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animationImageView stopAnimating];
        self.animationImageView.animationImages = nil;
        self.animationImageView.backgroundColor = [UIColor systemRedColor];
        self.isAnimating = NO;
    });
}

#pragma mark - UIDynamic 动画方法

// 重力动画
- (void)gravityAnimation {
    self.isAnimating = YES;
    
    // 清除之前的行为
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建一个测试视图
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 40, 40)];
    testView.backgroundColor = [UIColor systemRedColor];
    testView.layer.cornerRadius = 20;
    [self.contentView addSubview:testView];
    [self.dynamicViews addObject:testView];
    
    // 创建重力行为
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[testView]];
    self.gravityBehavior.magnitude = 1.0;
    
    // 创建碰撞行为（与边界碰撞）
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[testView]];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    // 添加弹性
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[testView]];
    itemBehavior.elasticity = 0.7;
    itemBehavior.friction = 0.5;
    
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:itemBehavior];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 碰撞动画
- (void)collisionAnimation {
    self.isAnimating = YES;
    
    // 清除之前的行为
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建多个测试视图
    NSArray *colors = @[[UIColor systemRedColor], [UIColor systemBlueColor], [UIColor systemGreenColor]];
    for (int i = 0; i < 3; i++) {
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(50 + i * 60, 150, 30, 30)];
        testView.backgroundColor = colors[i];
        testView.layer.cornerRadius = 15;
        [self.contentView addSubview:testView];
        [self.dynamicViews addObject:testView];
    }
    
    // 创建重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.dynamicViews];
    gravity.magnitude = 0.8;
    
    // 创建碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 添加物体间碰撞
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    // 添加弹性和摩擦力
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.dynamicViews];
    itemBehavior.elasticity = 0.8;
    itemBehavior.friction = 0.2;
    itemBehavior.resistance = 0.1;
    
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:collision];
    [self.dynamicAnimator addBehavior:itemBehavior];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 弹簧连接动画
- (void)springAttachmentAnimation {
    self.isAnimating = YES;
    
    // 清除之前的行为
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建两个连接的视图
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(80, 200, 30, 30)];
    view1.backgroundColor = [UIColor systemRedColor];
    view1.layer.cornerRadius = 15;
    [self.contentView addSubview:view1];
    [self.dynamicViews addObject:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(150, 200, 30, 30)];
    view2.backgroundColor = [UIColor systemBlueColor];
    view2.layer.cornerRadius = 15;
    [self.contentView addSubview:view2];
    [self.dynamicViews addObject:view2];
    
    // 创建弹簧连接
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view1 attachedToItem:view2];
    attachment.length = 100;
    attachment.frequency = 2.0;
    attachment.damping = 0.3;
    
    // 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[view1, view2]];
    gravity.magnitude = 0.5;
    
    // 添加碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[view1, view2]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [self.dynamicAnimator addBehavior:attachment];
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 推力动画
- (void)pushAnimation {
    self.isAnimating = YES;
    
    // 清除之前的行为
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建测试视图
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(50, 300, 40, 40)];
    testView.backgroundColor = [UIColor systemPurpleColor];
    testView.layer.cornerRadius = 20;
    [self.contentView addSubview:testView];
    [self.dynamicViews addObject:testView];
    
    // 创建推力行为
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[testView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(1.0, -0.5);
    pushBehavior.magnitude = 2.0;
    
    // 添加碰撞边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[testView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 添加物理属性
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[testView]];
    itemBehavior.elasticity = 0.6;
    itemBehavior.friction = 0.3;
    itemBehavior.resistance = 0.2;
    
    [self.dynamicAnimator addBehavior:pushBehavior];
    [self.dynamicAnimator addBehavior:collision];
    [self.dynamicAnimator addBehavior:itemBehavior];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 附着动画
- (void)attachmentAnimation {
    self.isAnimating = YES;
    
    // 清除之前的行为
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建测试视图
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 30, 30)];
    testView.backgroundColor = [UIColor systemOrangeColor];
    testView.layer.cornerRadius = 15;
    [self.contentView addSubview:testView];
    [self.dynamicViews addObject:testView];
    
    // 创建固定点附着
    CGPoint anchorPoint = CGPointMake(150, 100);
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:testView attachedToAnchor:anchorPoint];
    attachment.length = 80;
    attachment.frequency = 1.5;
    attachment.damping = 0.4;
    
    // 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[testView]];
    gravity.magnitude = 0.8;
    
    // 创建一个视觉指示器显示锚点
    UIView *anchorView = [[UIView alloc] initWithFrame:CGRectMake(anchorPoint.x - 5, anchorPoint.y - 5, 10, 10)];
    anchorView.backgroundColor = [UIColor systemRedColor];
    anchorView.layer.cornerRadius = 5;
    [self.contentView addSubview:anchorView];
    [self.dynamicViews addObject:anchorView];
    
    [self.dynamicAnimator addBehavior:attachment];
    [self.dynamicAnimator addBehavior:gravity];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 物理摆动画
- (void)pendulumAnimation {
    self.isAnimating = YES;
    
    // 清除之前的行为
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建摆球
    UIView *pendulumBob = [[UIView alloc] initWithFrame:CGRectMake(120, 250, 25, 25)];
    pendulumBob.backgroundColor = [UIColor systemTealColor];
    pendulumBob.layer.cornerRadius = 12.5;
    [self.contentView addSubview:pendulumBob];
    [self.dynamicViews addObject:pendulumBob];
    
    // 摆的固定点
    CGPoint pivotPoint = CGPointMake(125, 150);
    
    // 创建摆的连接
    UIAttachmentBehavior *pendulumAttachment = [[UIAttachmentBehavior alloc] initWithItem:pendulumBob attachedToAnchor:pivotPoint];
    pendulumAttachment.length = 100;
    pendulumAttachment.frequency = 0.5;  // 低频率让摆动更自然
    pendulumAttachment.damping = 0.1;    // 低阻尼保持摆动
    
    // 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[pendulumBob]];
    gravity.magnitude = 1.0;
    
    // 给摆一个初始推力
    UIPushBehavior *initialPush = [[UIPushBehavior alloc] initWithItems:@[pendulumBob] mode:UIPushBehaviorModeInstantaneous];
    initialPush.pushDirection = CGVectorMake(1.5, 0);
    initialPush.magnitude = 0.8;
    
    // 创建支点指示器
    UIView *pivotView = [[UIView alloc] initWithFrame:CGRectMake(pivotPoint.x - 3, pivotPoint.y - 3, 6, 6)];
    pivotView.backgroundColor = [UIColor systemRedColor];
    pivotView.layer.cornerRadius = 3;
    [self.contentView addSubview:pivotView];
    [self.dynamicViews addObject:pivotView];
    
    [self.dynamicAnimator addBehavior:pendulumAttachment];
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:initialPush];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 磁力场动画
- (void)magneticFieldAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建多个小球
    NSArray *colors = @[[UIColor systemRedColor], [UIColor systemBlueColor], [UIColor systemGreenColor], [UIColor systemOrangeColor]];
    for (int i = 0; i < 4; i++) {
        UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(50 + i * 40, 150, 20, 20)];
        ball.backgroundColor = colors[i];
        ball.layer.cornerRadius = 10;
        [self.contentView addSubview:ball];
        [self.dynamicViews addObject:ball];
    }
    
    // 创建磁场中心点
    CGPoint magnetCenter = CGPointMake(150, 300);
    UIView *magnetView = [[UIView alloc] initWithFrame:CGRectMake(magnetCenter.x - 10, magnetCenter.y - 10, 20, 20)];
    magnetView.backgroundColor = [UIColor systemPurpleColor];
    magnetView.layer.cornerRadius = 10;
    [self.contentView addSubview:magnetView];
    [self.dynamicViews addObject:magnetView];
    
    // 创建磁力场（使用重力行为模拟）
    for (UIView *ball in self.dynamicViews) {
        if (ball != magnetView) {
            UIFieldBehavior *magneticField = [UIFieldBehavior radialGravityFieldWithPosition:magnetCenter];
            magneticField.strength = 0.5;
            magneticField.falloff = 2.0;
            magneticField.minimumRadius = 30;
            [magneticField addItem:ball];
            [self.dynamicAnimator addBehavior:magneticField];
        }
    }
    
    // 添加边界碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 涡流场动画
- (void)vortexFieldAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建粒子
    for (int i = 0; i < 6; i++) {
        UIView *particle = [[UIView alloc] initWithFrame:CGRectMake(80 + i * 25, 200, 15, 15)];
        particle.backgroundColor = [UIColor colorWithHue:i/6.0 saturation:1.0 brightness:1.0 alpha:1.0];
        particle.layer.cornerRadius = 7.5;
        [self.contentView addSubview:particle];
        [self.dynamicViews addObject:particle];
    }
    
    // 创建涡流中心
    CGPoint vortexCenter = CGPointMake(150, 300);
    UIView *vortexView = [[UIView alloc] initWithFrame:CGRectMake(vortexCenter.x - 5, vortexCenter.y - 5, 10, 10)];
    vortexView.backgroundColor = [UIColor blackColor];
    vortexView.layer.cornerRadius = 5;
    [self.contentView addSubview:vortexView];
    [self.dynamicViews addObject:vortexView];
    
    // 创建涡流场
    UIFieldBehavior *vortexField = [UIFieldBehavior vortexField];
    vortexField.position = vortexCenter;
    vortexField.strength = 0.8;
    vortexField.falloff = 0.5;
    
    for (UIView *particle in self.dynamicViews) {
        if (particle != vortexView) {
            [vortexField addItem:particle];
        }
    }
    
    [self.dynamicAnimator addBehavior:vortexField];
    
    // 添加边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 噪声场动画
- (void)noiseFieldAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建多个粒子
    for (int i = 0; i < 8; i++) {
        UIView *particle = [[UIView alloc] initWithFrame:CGRectMake(50 + (i % 4) * 40, 180 + (i / 4) * 40, 12, 12)];
        particle.backgroundColor = [UIColor systemTealColor];
        particle.layer.cornerRadius = 6;
        [self.contentView addSubview:particle];
        [self.dynamicViews addObject:particle];
    }
    
    // 创建噪声场
    UIFieldBehavior *noiseField = [UIFieldBehavior noiseFieldWithSmoothness:0.3 animationSpeed:1.0];
    noiseField.strength = 0.3;
    
    for (UIView *particle in self.dynamicViews) {
        [noiseField addItem:particle];
    }
    
    [self.dynamicAnimator addBehavior:noiseField];
    
    // 添加边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 弹性碰撞动画
- (void)elasticCollisionAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建不同大小的球
    NSArray *sizes = @[@30, @25, @20, @35];
    NSArray *colors = @[[UIColor systemRedColor], [UIColor systemBlueColor], [UIColor systemYellowColor], [UIColor systemGreenColor]];
    
    for (int i = 0; i < 4; i++) {
        CGFloat size = [sizes[i] floatValue];
        UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(50 + i * 60, 180, size, size)];
        ball.backgroundColor = colors[i];
        ball.layer.cornerRadius = size / 2;
        [self.contentView addSubview:ball];
        [self.dynamicViews addObject:ball];
    }
    
    // 创建高弹性碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    // 设置超高弹性
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.dynamicViews];
    itemBehavior.elasticity = 0.95; // 几乎完全弹性
    itemBehavior.friction = 0.05;   // 很低摩擦
    itemBehavior.resistance = 0.02; // 很低阻力
    
    // 给球一些初始速度 - 使用推力代替直接设置速度
    UIPushBehavior *push1 = [[UIPushBehavior alloc] initWithItems:@[self.dynamicViews[0]] mode:UIPushBehaviorModeInstantaneous];
    push1.pushDirection = CGVectorMake(100, -50);
    push1.magnitude = 0.5;
    [self.dynamicAnimator addBehavior:push1];
    
    UIPushBehavior *push2 = [[UIPushBehavior alloc] initWithItems:@[self.dynamicViews[1]] mode:UIPushBehaviorModeInstantaneous];
    push2.pushDirection = CGVectorMake(-80, -60);
    push2.magnitude = 0.5;
    [self.dynamicAnimator addBehavior:push2];
    
    UIPushBehavior *push3 = [[UIPushBehavior alloc] initWithItems:@[self.dynamicViews[2]] mode:UIPushBehaviorModeInstantaneous];
    push3.pushDirection = CGVectorMake(60, -40);
    push3.magnitude = 0.5;
    [self.dynamicAnimator addBehavior:push3];
    
    UIPushBehavior *push4 = [[UIPushBehavior alloc] initWithItems:@[self.dynamicViews[3]] mode:UIPushBehaviorModeInstantaneous];
    push4.pushDirection = CGVectorMake(-90, -70);
    push4.magnitude = 0.5;
    [self.dynamicAnimator addBehavior:push4];
    
    [self.dynamicAnimator addBehavior:collision];
    [self.dynamicAnimator addBehavior:itemBehavior];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 流体阻力动画
- (void)fluidResistanceAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建下落的物体
    UIView *lightObject = [[UIView alloc] initWithFrame:CGRectMake(80, 150, 20, 20)];
    lightObject.backgroundColor = [UIColor systemBlueColor];
    lightObject.layer.cornerRadius = 10;
    [self.contentView addSubview:lightObject];
    [self.dynamicViews addObject:lightObject];
    
    UIView *heavyObject = [[UIView alloc] initWithFrame:CGRectMake(140, 150, 30, 30)];
    heavyObject.backgroundColor = [UIColor systemRedColor];
    heavyObject.layer.cornerRadius = 15;
    [self.contentView addSubview:heavyObject];
    [self.dynamicViews addObject:heavyObject];
    
    // 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.dynamicViews];
    gravity.magnitude = 1.0;
    
    // 创建不同的阻力
    UIDynamicItemBehavior *lightBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[lightObject]];
    lightBehavior.resistance = 2.0; // 高阻力（羽毛效果）
    lightBehavior.density = 0.5;    // 低密度
    
    UIDynamicItemBehavior *heavyBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[heavyObject]];
    heavyBehavior.resistance = 0.2; // 低阻力
    heavyBehavior.density = 2.0;    // 高密度
    
    // 添加边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:lightBehavior];
    [self.dynamicAnimator addBehavior:heavyBehavior];
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 多物体链条动画
- (void)chainAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建链条节点
    NSMutableArray *chainLinks = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        UIView *link = [[UIView alloc] initWithFrame:CGRectMake(100, 150 + i * 25, 20, 20)];
        link.backgroundColor = [UIColor colorWithHue:i/6.0 saturation:0.8 brightness:0.9 alpha:1.0];
        link.layer.cornerRadius = 10;
        [self.contentView addSubview:link];
        [self.dynamicViews addObject:link];
        [chainLinks addObject:link];
    }
    
    // 固定第一个节点
    CGPoint anchorPoint = CGPointMake(100, 140);
    UIView *anchorView = [[UIView alloc] initWithFrame:CGRectMake(anchorPoint.x - 3, anchorPoint.y - 3, 6, 6)];
    anchorView.backgroundColor = [UIColor blackColor];
    anchorView.layer.cornerRadius = 3;
    [self.contentView addSubview:anchorView];
    [self.dynamicViews addObject:anchorView];
    
    // 创建链条连接
    UIAttachmentBehavior *firstAttachment = [[UIAttachmentBehavior alloc] initWithItem:chainLinks[0] attachedToAnchor:anchorPoint];
    firstAttachment.length = 25;
    firstAttachment.frequency = 3.0;
    firstAttachment.damping = 0.3;
    [self.dynamicAnimator addBehavior:firstAttachment];
    
    // 连接相邻的链条节点
    for (int i = 0; i < chainLinks.count - 1; i++) {
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:chainLinks[i] attachedToItem:chainLinks[i + 1]];
        attachment.length = 25;
        attachment.frequency = 3.0;
        attachment.damping = 0.3;
        [self.dynamicAnimator addBehavior:attachment];
    }
    
    // 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:chainLinks];
    gravity.magnitude = 0.8;
    
    // 添加边界碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:chainLinks];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 物理弹球动画
- (void)pinballAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建弹球
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(50, 180, 25, 25)];
    ball.backgroundColor = [UIColor systemRedColor];
    ball.layer.cornerRadius = 12.5;
    [self.contentView addSubview:ball];
    [self.dynamicViews addObject:ball];
    
    // 创建挡板
    for (int i = 0; i < 3; i++) {
        UIView *paddle = [[UIView alloc] initWithFrame:CGRectMake(80 + i * 50, 250 + i * 30, 40, 8)];
        paddle.backgroundColor = [UIColor systemBlueColor];
        paddle.layer.cornerRadius = 4;
        [self.contentView addSubview:paddle];
        [self.dynamicViews addObject:paddle];
    }
    
    // 给弹球初始推力
    UIPushBehavior *initialPush = [[UIPushBehavior alloc] initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    initialPush.pushDirection = CGVectorMake(1.5, 0.5);
    initialPush.magnitude = 1.5;
    
    // 设置弹球属性
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ball]];
    ballBehavior.elasticity = 0.9;
    ballBehavior.friction = 0.1;
    ballBehavior.resistance = 0.05;
    
    // 设置挡板属性（静态）
    NSArray *paddles = [self.dynamicViews subarrayWithRange:NSMakeRange(1, 3)];
    UIDynamicItemBehavior *paddleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:paddles];
    paddleBehavior.density = 1000; // 很重，几乎不动
    paddleBehavior.elasticity = 0.8;
    
    // 创建碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.dynamicViews];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    [self.dynamicAnimator addBehavior:initialPush];
    [self.dynamicAnimator addBehavior:ballBehavior];
    [self.dynamicAnimator addBehavior:paddleBehavior];
    [self.dynamicAnimator addBehavior:collision];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 重力井动画
- (void)gravityWellAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建多个行星
    for (int i = 0; i < 5; i++) {
        UIView *planet = [[UIView alloc] initWithFrame:CGRectMake(60 + i * 35, 160, 15, 15)];
        planet.backgroundColor = [UIColor colorWithHue:i/5.0 saturation:1.0 brightness:1.0 alpha:1.0];
        planet.layer.cornerRadius = 7.5;
        [self.contentView addSubview:planet];
        [self.dynamicViews addObject:planet];
    }
    
    // 创建重力井中心
    CGPoint wellCenter = CGPointMake(150, 300);
    UIView *wellView = [[UIView alloc] initWithFrame:CGRectMake(wellCenter.x - 15, wellCenter.y - 15, 30, 30)];
    wellView.backgroundColor = [UIColor blackColor];
    wellView.layer.cornerRadius = 15;
    [self.contentView addSubview:wellView];
    [self.dynamicViews addObject:wellView];
    
    // 给行星初始轨道速度 - 使用推力
    for (int i = 0; i < 5; i++) {
        CGFloat speed = 80 + i * 20;
        UIPushBehavior *orbitalPush = [[UIPushBehavior alloc] initWithItems:@[self.dynamicViews[i]] mode:UIPushBehaviorModeInstantaneous];
        orbitalPush.pushDirection = CGVectorMake(1.0, 0);
        orbitalPush.magnitude = speed / 100.0;
        [self.dynamicAnimator addBehavior:orbitalPush];
    }
    
    // 创建重力井
    UIFieldBehavior *gravityWell = [UIFieldBehavior radialGravityFieldWithPosition:wellCenter];
    gravityWell.strength = 2.0;
    gravityWell.falloff = 1.0;
    gravityWell.minimumRadius = 40;
    
    for (int i = 0; i < 5; i++) {
        [gravityWell addItem:self.dynamicViews[i]];
    }
    
    // 设置重力井为静态
    UIDynamicItemBehavior *wellBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[wellView]];
    wellBehavior.density = 1000;
    
    [self.dynamicAnimator addBehavior:gravityWell];
    [self.dynamicAnimator addBehavior:wellBehavior];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 物理布料动画
- (void)clothSimulationAnimation {
    self.isAnimating = YES;
    
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    // 创建布料网格 (3x4)
    NSMutableArray *clothNodes = [NSMutableArray array];
    for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 4; col++) {
            UIView *node = [[UIView alloc] initWithFrame:CGRectMake(80 + col * 25, 150 + row * 25, 8, 8)];
            node.backgroundColor = [UIColor systemTealColor];
            node.layer.cornerRadius = 4;
            [self.contentView addSubview:node];
            [self.dynamicViews addObject:node];
            [clothNodes addObject:node];
        }
    }
    
    // 固定顶部两个角
    CGPoint leftAnchor = CGPointMake(80, 140);
    CGPoint rightAnchor = CGPointMake(80 + 3 * 25, 140);
    
    UIAttachmentBehavior *leftAttachment = [[UIAttachmentBehavior alloc] initWithItem:clothNodes[0] attachedToAnchor:leftAnchor];
    leftAttachment.length = 15;
    leftAttachment.frequency = 5.0;
    leftAttachment.damping = 0.5;
    
    UIAttachmentBehavior *rightAttachment = [[UIAttachmentBehavior alloc] initWithItem:clothNodes[3] attachedToAnchor:rightAnchor];
    rightAttachment.length = 15;
    rightAttachment.frequency = 5.0;
    rightAttachment.damping = 0.5;
    
    [self.dynamicAnimator addBehavior:leftAttachment];
    [self.dynamicAnimator addBehavior:rightAttachment];
    
    // 创建布料连接（水平和垂直）
    for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 4; col++) {
            int index = row * 4 + col;
            
            // 水平连接
            if (col < 3) {
                UIAttachmentBehavior *horizontal = [[UIAttachmentBehavior alloc] initWithItem:clothNodes[index] attachedToItem:clothNodes[index + 1]];
                horizontal.length = 25;
                horizontal.frequency = 8.0;
                horizontal.damping = 0.3;
                [self.dynamicAnimator addBehavior:horizontal];
            }
            
            // 垂直连接
            if (row < 2) {
                UIAttachmentBehavior *vertical = [[UIAttachmentBehavior alloc] initWithItem:clothNodes[index] attachedToItem:clothNodes[index + 4]];
                vertical.length = 25;
                vertical.frequency = 8.0;
                vertical.damping = 0.3;
                [self.dynamicAnimator addBehavior:vertical];
            }
        }
    }
    
    // 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:clothNodes];
    gravity.magnitude = 0.6;
    
    // 添加空气阻力
    UIDynamicItemBehavior *airResistance = [[UIDynamicItemBehavior alloc] initWithItems:clothNodes];
    airResistance.resistance = 0.8;
    airResistance.density = 0.3;
    
    [self.dynamicAnimator addBehavior:gravity];
    [self.dynamicAnimator addBehavior:airResistance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAnimating = NO;
    });
}

// 清理动态视图的辅助方法
- (void)cleanupDynamicViews {
    for (UIView *view in self.dynamicViews) {
        [view removeFromSuperview];
    }
    [self.dynamicViews removeAllObjects];
}

// 重置位置
- (void)resetPosition {
    // 移除所有动画
    [self.animationView.layer removeAllAnimations];
    [self.animationImageView.layer removeAllAnimations];
    [self.greenLineView.layer removeAllAnimations];
    [self.view.layer removeAllAnimations];
    
    // 停止图片序列动画
    [self.animationImageView stopAnimating];
    self.animationImageView.animationImages = nil;
    
    // 重置animationView
    self.animationView.transform = CGAffineTransformIdentity;
    self.animationView.layer.transform = CATransform3DIdentity;
    self.animationView.alpha = 1.0;
    self.animationView.backgroundColor = [UIColor systemBlueColor];
    self.animationView.layer.borderWidth = 0;
    self.animationView.layer.shadowOpacity = 0;
    self.animationView.layer.shadowRadius = 0;
    self.animationView.layer.shadowOffset = CGSizeMake(0, 0);
    
    // 重置animationView的frame
    CGRect frame = self.animationView.frame;
    frame.size.width = 50;
    frame.size.height = 50;
    self.animationView.frame = frame;
    
    // 重置greenLineView
    self.greenLineView.transform = CGAffineTransformIdentity;
    self.greenLineView.alpha = 1.0;
    self.greenLineView.backgroundColor = [UIColor systemGreenColor];
    
    // 重置animationImageView
    self.animationImageView.transform = CGAffineTransformIdentity;
    self.animationImageView.alpha = 1.0;
    self.animationImageView.backgroundColor = [UIColor systemRedColor];
    
    // 移除所有子图层（渐变层、形状层等）
    NSArray *sublayers = [self.animationView.layer.sublayers copy];
    for (CALayer *layer in sublayers) {
        if (layer != self.greenLineView.layer) {
            [layer removeFromSuperlayer];
        }
    }
    
    // 移除所有粒子发射器
    NSArray *viewSublayers = [self.view.layer.sublayers copy];
    for (CALayer *layer in viewSublayers) {
        if ([layer isKindOfClass:[CAEmitterLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    // 清理UIDynamic相关内容
    [self.dynamicAnimator removeAllBehaviors];
    [self cleanupDynamicViews];
    
    self.isAnimating = NO;
}

@end 
