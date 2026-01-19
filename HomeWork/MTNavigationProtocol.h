//
//  MTNavigationProtocol.h
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTNavigationProtocol <NSObject>

/// 创建用于导航的 ViewController 实例
/// @return 返回 ViewController 实例
+ (instancetype)navigationInstance;

/// 获取导航按钮的标题
/// @return 返回按钮标题
+ (NSString *)navigationTitle;

/// 获取导航按钮的颜色
/// @return 返回按钮背景颜色
+ (UIColor *)navigationColor;

/// 获取所有支持导航的 ViewController 类数组
/// @return 返回所有 ViewController 类的数组
+ (NSArray<Class> *)allNavigationClasses;

@end

NS_ASSUME_NONNULL_END

