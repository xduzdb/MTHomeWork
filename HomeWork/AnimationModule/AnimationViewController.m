//
//  AnimationViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

// 动画演示区域
@property (nonatomic, strong) UIView *animationContainerView;
@property (nonatomic, strong) UIView *demoView;

// 动画控制按钮
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray<UIButton *> *animationButtons;

// 动画状态
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self createAnimationButtons];
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
    
    // 创建动画演示区域（限制区域）
    self.animationContainerView = [[UIView alloc] init];
    self.animationContainerView.backgroundColor = [UIColor systemGray6Color];
    self.animationContainerView.layer.borderWidth = 2.0;
    self.animationContainerView.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.animationContainerView.layer.cornerRadius = 10;
    self.animationContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.animationContainerView];
    
    // 创建演示视图
    self.demoView = [[UIView alloc] init];
    self.demoView.backgroundColor = [UIColor systemRedColor];
    self.demoView.layer.cornerRadius = 20;
    self.demoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.animationContainerView addSubview:self.demoView];
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
    
    // 动画容器约束（限制区域）
    [NSLayoutConstraint activateConstraints:@[
        [self.animationContainerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.animationContainerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.animationContainerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.animationContainerView.heightAnchor constraintEqualToConstant:200]
    ]];
    
    // 演示视图约束
    [NSLayoutConstraint activateConstraints:@[
        [self.demoView.centerXAnchor constraintEqualToAnchor:self.animationContainerView.centerXAnchor],
        [self.demoView.centerYAnchor constraintEqualToAnchor:self.animationContainerView.centerYAnchor],
        [self.demoView.widthAnchor constraintEqualToConstant:40],
        [self.demoView.heightAnchor constraintEqualToConstant:40]
    ]];
}

- (void)createAnimationButtons {
    // 动画类型数组
    NSArray *animationTypes = @[
        @"基本动画 - 移动",
        @"基本动画 - 缩放",
        @"基本动画 - 旋转",
        @"基本动画 - 透明度",
        @"弹簧动画",
        @"重复动画",
        @"自动反向动画",
        @"关键帧动画",
        @"转场动画",
        @"组合动画",
        @"重置位置"
    ];
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    // 创建分组标题
    [self createSectionLabel:@"UIView 动画演示" atIndex:0];
    
    // 创建按钮
    for (NSInteger i = 0; i < animationTypes.count; i++) {
        UIButton *button = [self createButtonWithTitle:animationTypes[i] tag:i];
        [buttons addObject:button];
    }
    
    self.animationButtons = [buttons copy];
    
    // 设置按钮布局
    [self setupButtonLayout];
}

- (void)createSectionLabel:(NSString *)title atIndex:(NSInteger)index {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.text = title;
    sectionLabel.font = [UIFont boldSystemFontOfSize:18];
    sectionLabel.textColor = [UIColor labelColor];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    sectionLabel.tag = 10000 + index;
    [self.contentView addSubview:sectionLabel];
}

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

- (void)setupButtonLayout {
    CGFloat buttonWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - 60) / 2;
    CGFloat buttonHeight = 44;
    CGFloat spacing = 10;
    CGFloat currentY = 240; // 动画容器下方
    
    // 设置分组标题
    UILabel *sectionLabel = [self.contentView viewWithTag:10000];
    if (sectionLabel) {
        [NSLayoutConstraint activateConstraints:@[
            [sectionLabel.topAnchor constraintEqualToAnchor:self.animationContainerView.bottomAnchor constant:20],
            [sectionLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
            [sectionLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
            [sectionLabel.heightAnchor constraintEqualToConstant:30]
        ]];
        currentY += 40;
    }
    
    // 设置按钮布局（2列）
    for (NSInteger i = 0; i < self.animationButtons.count; i++) {
        UIButton *button = self.animationButtons[i];
        NSInteger row = i / 2;
        NSInteger col = i % 2;
        
        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:self.animationContainerView.bottomAnchor constant:currentY + row * (buttonHeight + spacing)],
            [button.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20 + col * (buttonWidth + spacing)],
            [button.widthAnchor constraintEqualToConstant:buttonWidth],
            [button.heightAnchor constraintEqualToConstant:buttonHeight]
        ]];
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
            [self basicMoveAnimation];
            break;
        case 1:
            [self basicScaleAnimation];
            break;
        case 2:
            [self basicRotationAnimation];
            break;
        case 3:
            [self basicAlphaAnimation];
            break;
        case 4:
            [self springAnimation];
            break;
        case 5:
            [self repeatAnimation];
            break;
        case 6:
            [self autoreverseAnimation];
            break;
        case 7:
            [self keyframeAnimation];
            break;
        case 8:
            [self transitionAnimation];
            break;
        case 9:
            [self combinedAnimation];
            break;
        case 10:
            [self resetPosition];
            break;
        default:
            break;
    }
}

#pragma mark - 动画方法

// 1. 基本动画 - 移动
- (void)basicMoveAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:1.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
        // 在限制区域内移动
        self.demoView.transform = CGAffineTransformMakeTranslation(60, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.demoView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 基本动画 - 缩放
- (void)basicScaleAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.8 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
        self.demoView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            self.demoView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 基本动画 - 旋转
- (void)basicRotationAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:1.5 
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear 
                     animations:^{
        self.demoView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    } completion:^(BOOL finished) {
        self.demoView.transform = CGAffineTransformIdentity;
        self.isAnimating = NO;
    }];
}

// 基本动画 - 透明度
- (void)basicAlphaAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.demoView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            self.demoView.alpha = 1.0;
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
        // 在限制区域内弹跳
        self.demoView.transform = CGAffineTransformMakeTranslation(0, 60);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.demoView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 重复动画
- (void)repeatAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.demoView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:nil];
    
    // 3秒后停止重复动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.demoView.layer removeAllAnimations];
        self.demoView.transform = CGAffineTransformIdentity;
        self.isAnimating = NO;
    });
}

// 自动反向动画
- (void)autoreverseAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:0.8 
                          delay:0 
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.demoView.transform = CGAffineTransformMakeTranslation(50, 0);
        self.demoView.backgroundColor = [UIColor systemBlueColor];
    } completion:nil];
    
    // 4秒后停止动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.demoView.layer removeAllAnimations];
        self.demoView.transform = CGAffineTransformIdentity;
        self.demoView.backgroundColor = [UIColor systemRedColor];
        self.isAnimating = NO;
    });
}

// 关键帧动画
- (void)keyframeAnimation {
    self.isAnimating = YES;
    
    [UIView animateKeyframesWithDuration:3.0 
                                   delay:0 
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear 
                              animations:^{
        // 第一帧：向右移动
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
            self.demoView.transform = CGAffineTransformMakeTranslation(60, 0);
        }];
        
        // 第二帧：向下移动
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
            self.demoView.transform = CGAffineTransformMakeTranslation(60, 60);
        }];
        
        // 第三帧：向左移动
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            self.demoView.transform = CGAffineTransformMakeTranslation(-60, 60);
        }];
        
        // 第四帧：回到原点
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            self.demoView.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

// 转场动画
- (void)transitionAnimation {
    self.isAnimating = YES;
    
    [UIView transitionWithView:self.demoView 
                      duration:1.0 
                       options:UIViewAnimationOptionTransitionFlipFromLeft 
                    animations:^{
        self.demoView.backgroundColor = [UIColor systemGreenColor];
    } completion:^(BOOL finished) {
        [UIView transitionWithView:self.demoView 
                          duration:1.0 
                           options:UIViewAnimationOptionTransitionFlipFromRight 
                        animations:^{
            self.demoView.backgroundColor = [UIColor systemRedColor];
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 组合动画
- (void)combinedAnimation {
    self.isAnimating = YES;
    
    [UIView animateWithDuration:2.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
        // 同时进行缩放、旋转和移动
        self.demoView.transform = CGAffineTransformConcat(
            CGAffineTransformMakeScale(1.5, 1.5),
            CGAffineTransformMakeRotation(M_PI)
        );
        self.demoView.transform = CGAffineTransformConcat(
            self.demoView.transform,
            CGAffineTransformMakeTranslation(30, 30)
        );
        self.demoView.backgroundColor = [UIColor systemPurpleColor];
        self.demoView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.demoView.transform = CGAffineTransformIdentity;
            self.demoView.backgroundColor = [UIColor systemRedColor];
            self.demoView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

// 重置位置
- (void)resetPosition {
    // 移除所有动画
    [self.demoView.layer removeAllAnimations];
    
    // 重置视图状态
    self.demoView.transform = CGAffineTransformIdentity;
    self.demoView.alpha = 1.0;
    self.demoView.backgroundColor = [UIColor systemRedColor];
    
    self.isAnimating = NO;
}

@end 
