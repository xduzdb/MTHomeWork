//
//  CustomTransitionDetailViewController.h
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTransitionDetailViewController : UIViewController

@property (nonatomic, strong) UIColor *cardColor;
@property (nonatomic, strong) NSString *cardTitle;
@property (nonatomic, assign) CGRect sourceFrame;
@property (nonatomic, strong, nullable) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGPoint initialPanPoint;
@property (nonatomic, assign) CGRect originalFrame;

@end

NS_ASSUME_NONNULL_END

