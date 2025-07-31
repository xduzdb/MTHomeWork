//
//  searchModel.h
//  HomeWork
//
//  Created by 张家和 on 2025/7/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MTItemLayoutType) {
    MTItemLayoutTypeSingle,
    MTItemLayoutTypeDouble,
};

@interface SearchModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) MTItemLayoutType type;
@property (nonatomic, strong, nullable) id data;
// 先判断是不是isSuperStick，再判断是不是isStick，都不是则为普通
@property (nonatomic, assign) BOOL isSticky;
@property (nonatomic, assign) BOOL isSuperSticky;

- (instancetype)initWithTitle:(NSString *)title
              backgroundColor:(UIColor *)backgroundColor
                      isStick:(BOOL)isStick
                 isSuperStick:(BOOL)isSuperStick
                       height:(CGFloat)height
                         type:(MTItemLayoutType)type
                         data:(nullable id)data;



@end

NS_ASSUME_NONNULL_END
