//
//  searchModel.m
//  HomeWork
//
//  Created by 张家和 on 2025/7/2.
//

#import "SearchModel.h"

@interface SearchModel ()

@end

@implementation SearchModel

- (instancetype)initWithTitle:(NSString *)title
              backgroundColor:(UIColor *)backgroundColor
                      isStick:(BOOL)isStick
                 isSuperStick:(BOOL)isSuperStick
                       height:(CGFloat)height
                         type:(MTItemLayoutType)type
                         data:(nullable id)data
{
    self = [super init];
    if (self) {
        _title = title;
        _backgroundColor = backgroundColor;
        _isSticky = isStick;
        _isSuperSticky = isSuperStick;
        _height = height;
        _type = type;
        _data = data;
    }
    return self;
}


@end
