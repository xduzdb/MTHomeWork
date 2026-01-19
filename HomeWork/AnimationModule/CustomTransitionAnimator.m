//
//  CustomTransitionAnimator.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "CustomTransitionAnimator.h"

@implementation CustomTransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7; // 增加动画时长，更柔和
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresenting) {
        [self animatePresenting:transitionContext];
    } else {
        [self animateDismissing:transitionContext];
    }
}

- (void)animatePresenting:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // 设置初始状态
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    if (CGRectIsEmpty(self.sourceFrame)) {
        // 如果没有 sourceFrame，从中心点开始
        self.sourceFrame = CGRectMake(finalFrame.size.width / 2 - 50, finalFrame.size.height / 2 - 50, 100, 100);
    }
    
    toVC.view.frame = self.sourceFrame;
    toVC.view.layer.cornerRadius = 16;
    toVC.view.clipsToBounds = YES;
    
    [containerView addSubview:toVC.view];
    
    // 动画 - 更柔和的 spring 动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        toVC.view.frame = finalFrame;
        toVC.view.layer.cornerRadius = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (void)animateDismissing:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // 保存当前视图的状态
    CGRect currentFrame = fromVC.view.frame;
    
    // 如果当前有 transform，需要先重置（交互式转场可能已经设置了 transform）
    CGAffineTransform initialTransform = fromVC.view.transform;
    CGFloat initialAlpha = fromVC.view.alpha;
    
    // 重置 transform 以便正确计算 frame
    fromVC.view.transform = CGAffineTransformIdentity;
    fromVC.view.frame = currentFrame;
    fromVC.view.alpha = initialAlpha;
    
    // 计算目标位置和大小（基于 sourceFrame）
    CGRect targetFrame = self.sourceFrame;
    
    // 动画 - 缩小到卡片位置
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        // 缩小到卡片位置和大小
        fromVC.view.frame = targetFrame;
        fromVC.view.layer.cornerRadius = 16;
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        // 恢复所有状态，确保不影响后续显示
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1.0;
        fromVC.view.layer.cornerRadius = 0;
        fromVC.view.frame = self.sourceFrame;
        [transitionContext completeTransition:finished];
    }];
}

@end

