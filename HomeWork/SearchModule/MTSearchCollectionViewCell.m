//
//  MTSearchCollectionViewCell.m
//  HomeWork
//
//  Created by 张家和 on 2025/7/3.
//

#import "MTSearchCollectionViewCell.h"
#import "SearchModel/SearchModel.h"
static CGFloat const kMinimumLineSpacing = 8.f;
static CGFloat const kMinimumInteritemSpacing = 16.f;

@interface MTSearchCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MTSearchCollectionViewCell

// 由于collectionView的复用机制，init方法并不会被调用
// 因为collectionView的dequeue默认走initWithFrame方法（UIView的子类，需要指定出事frame）
// 使用场景：一般用于非UI对象的初始化，或者在某些情况下用于初始化UI对象的默认状态。
// init方法仅用于自测
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        NSLog(@"jh-initWithFrame-%ld", (long)kInstanceCount);
        kInstanceCount++;
    }
    return self;
}

- (void)setupUI {
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.label];

    // 使用 Auto Layout 约束来确保 UILabel 的布局
    [NSLayoutConstraint activateConstraints:@[
        [self.label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.label.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.label.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.label.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

- (void)configCellWith:(SearchModel *)model {
    self.label.text = model.title;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    [self.label sizeToFit];
    self.contentView.backgroundColor = model.backgroundColor;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    self.contentView.layer.borderWidth = 2;
}

@end
