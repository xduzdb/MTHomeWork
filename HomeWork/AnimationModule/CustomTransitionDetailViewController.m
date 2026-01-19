//
//  CustomTransitionDetailViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "CustomTransitionDetailViewController.h"
#import "CustomTransitionAnimator.h"
#import "CustomTransitionViewController.h"

@interface CustomTransitionDetailViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation CustomTransitionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupUI];
    [self setupGesture];
}

- (void)setupUI {
    // 内容视图
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.backgroundColor = self.cardColor ?: [UIColor systemBlueColor];
    [self.view addSubview:self.contentView];
    
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.cardTitle ?: @"详情";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
    
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.closeButton.layer.cornerRadius = 20;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.closeButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.closeButton.widthAnchor constraintEqualToConstant:80],
        [self.closeButton.heightAnchor constraintEqualToConstant:40]
    ]];
}

- (void)setupGesture {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.initialPanPoint = [gesture locationInView:self.view];
            // 保存原始 frame（重置 transform 后获取真实 frame）
            CGAffineTransform currentTransform = self.view.transform;
            self.view.transform = CGAffineTransformIdentity;
            self.originalFrame = self.view.frame;
            self.view.transform = currentTransform;
            
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 计算水平和垂直方向的拖动距离
            CGFloat horizontalDistance = fabs(translation.x);
            CGFloat verticalDistance = fabs(translation.y);
            // 使用较大的距离值（支持左右和上下拖动）
            CGFloat maxDistance = MAX(horizontalDistance, verticalDistance);
            
            // 计算缩放比例：基于拖动距离，但不能放大超过原始大小
            // 拖动距离越大，缩放越小，最小缩放到卡片大小
            CGFloat originalWidth = self.originalFrame.size.width;
            CGFloat originalHeight = self.originalFrame.size.height;
            CGFloat targetWidth = self.sourceFrame.size.width;
            CGFloat targetHeight = self.sourceFrame.size.height;
            CGFloat minScaleX = targetWidth / originalWidth;
            CGFloat minScaleY = targetHeight / originalHeight;
            CGFloat minScale = MIN(minScaleX, minScaleY);
            
            // 计算进度：基于拖动距离，最大拖动距离为视图对角线的一半
            CGFloat maxDragDistance = sqrt(originalWidth * originalWidth + originalHeight * originalHeight) * 0.5;
            CGFloat progress = MIN(maxDistance / maxDragDistance, 1.0);
            
            // 计算缩放：从 1.0 缩小到 minScale，但不能放大（scale >= 1.0）
            CGFloat scale = 1.0 - progress * (1.0 - minScale);
            scale = MAX(scale, minScale); // 不能小于最小缩放
            scale = MIN(scale, 1.0); // 不能大于 1.0（不能放大）
            
            // 计算 alpha：随着缩放减小
            CGFloat alpha = 0.3 + (1.0 - 0.3) * (scale - minScale) / (1.0 - minScale);
            
            [self.interactiveTransition updateInteractiveTransition:progress];
            
            // 跟手缩放和移动效果
            CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(translation.x * 0.3, translation.y * 0.3);
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            self.view.transform = CGAffineTransformConcat(translationTransform, scaleTransform);
            self.view.alpha = alpha;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 计算当前的缩放比例
            CGFloat currentScale = sqrt(self.view.transform.a * self.view.transform.a + self.view.transform.c * self.view.transform.c);
            CGFloat originalWidth = self.originalFrame.size.width;
            CGFloat originalHeight = self.originalFrame.size.height;
            CGFloat targetWidth = self.sourceFrame.size.width;
            CGFloat targetHeight = self.sourceFrame.size.height;
            CGFloat minScaleX = targetWidth / originalWidth;
            CGFloat minScaleY = targetHeight / originalHeight;
            CGFloat minScale = MIN(minScaleX, minScaleY);
            
            // 计算拖动距离
            CGFloat horizontalDistance = fabs(translation.x);
            CGFloat verticalDistance = fabs(translation.y);
            CGFloat maxDistance = MAX(horizontalDistance, verticalDistance);
            CGFloat maxDragDistance = sqrt(originalWidth * originalWidth + originalHeight * originalHeight) * 0.5;
            CGFloat progress = MIN(maxDistance / maxDragDistance, 1.0);
            
            // 判断速度
            CGFloat velocityMagnitude = sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
            
            // 判断是否应该完成转场：
            // 1. 缩放已经足够小（接近卡片大小）
            // 2. 或者拖动距离足够大（> 50%）
            // 3. 或者速度足够快
            BOOL scaleSmallEnough = currentScale <= minScale * 1.2; // 允许 20% 的误差
            BOOL dragFarEnough = progress > 0.5;
            BOOL velocityFastEnough = velocityMagnitude > 800;
            
            BOOL shouldFinish = scaleSmallEnough || dragFarEnough || velocityFastEnough;
            
            if (shouldFinish) {
                [self.interactiveTransition finishInteractiveTransition];
                // 转场完成后清理状态
                __weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.transitioningDelegate = nil;
                });
            } else {
                [self.interactiveTransition cancelInteractiveTransition];
                // 恢复原样
                [UIView animateWithDuration:0.4
                                      delay:0
                     usingSpringWithDamping:0.8
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    self.view.transform = CGAffineTransformIdentity;
                    self.view.alpha = 1.0;
                } completion:nil];
            }
            self.interactiveTransition = nil;
            break;
        }
        default:
            break;
    }
}

- (void)closeButtonTapped:(UIButton *)sender {
    // 确保在关闭前重置所有 transform 和状态
    self.view.transform = CGAffineTransformIdentity;
    self.view.alpha = 1.0;
    self.view.layer.cornerRadius = 0;
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        // 转场完成后清理状态
        weakSelf.transitioningDelegate = nil;
        weakSelf.interactiveTransition = nil;
    }];
}

@end

