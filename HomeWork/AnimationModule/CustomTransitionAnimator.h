//
//  CustomTransitionAnimator.h
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) CGRect sourceFrame;

@end

NS_ASSUME_NONNULL_END

