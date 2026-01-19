//
//  BaseViewController.h
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import <UIKit/UIKit.h>
#import "MTNavigationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController <MTNavigationProtocol>

/// 注册导航类（子类在 +initialize 中调用）
+ (void)registerNavigationClass;

@end

NS_ASSUME_NONNULL_END

