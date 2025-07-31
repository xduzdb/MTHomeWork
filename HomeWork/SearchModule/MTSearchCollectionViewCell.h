//
//  MTSearchCollectionViewCell.h
//  HomeWork
//
//  Created by 张家和 on 2025/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchModel;

static NSInteger kInstanceCount = 0;
@interface MTSearchCollectionViewCell : UICollectionViewCell


- (void)configCellWith:(SearchModel *)model;

@end

NS_ASSUME_NONNULL_END
