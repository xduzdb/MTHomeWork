//
//  BaseViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "BaseViewController.h"
#import <objc/runtime.h>

@implementation BaseViewController

static NSMutableArray<Class> *_registeredNavigationClasses = nil;

+ (void)initialize {
    if (self == [BaseViewController class]) {
        _registeredNavigationClasses = [NSMutableArray array];
    }
}

+ (void)registerNavigationClass {
    // 确保数组已初始化（防止子类先于基类被加载的情况）
    if (!_registeredNavigationClasses) {
        _registeredNavigationClasses = [NSMutableArray array];
    }
    
    if (self != [BaseViewController class] && ![_registeredNavigationClasses containsObject:self]) {
        [_registeredNavigationClasses addObject:self];
    }
}

+ (BOOL)_isSubclassOfBaseViewController:(Class)cls {
    if (cls == nil || cls == [BaseViewController class]) {
        return NO;
    }
    
    // 遍历父类链，检查是否是 BaseViewController 的子类
    Class currentClass = cls;
    while (currentClass) {
        if (currentClass == [BaseViewController class]) {
            return YES;
        }
        currentClass = class_getSuperclass(currentClass);
    }
    return NO;
}

+ (void)_scanAndRegisterSubclasses {
    // 获取所有已注册的类
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    
    if (classes) {
        for (unsigned int i = 0; i < classCount; i++) {
            Class cls = classes[i];
            
            // 检查是否是 BaseViewController 的子类（排除 BaseViewController 本身）
            if ([self _isSubclassOfBaseViewController:cls]) {
                // 触发类的加载，确保 +initialize 被调用，从而触发自动注册
                [cls class];
            }
        }
        free(classes);
    }
}

+ (instancetype)navigationInstance {
    return self.new;
}

+ (NSString *)navigationTitle {
    return @"";
}

+ (UIColor *)navigationColor {
    return [UIColor systemGrayColor];
}

+ (NSArray<Class> *)allNavigationClasses {
    // 扫描所有子类并触发注册
    [self _scanAndRegisterSubclasses];
    return [_registeredNavigationClasses copy];
}

@end

