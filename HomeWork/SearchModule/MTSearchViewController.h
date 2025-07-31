//
//  MTSearchViewController.h
//  HomeWork
//
//  Created by 张家和 on 2025/7/2.
//

#import <UIKit/UIKit.h>
#import "MTSearchMixLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTSearchViewController : UIViewController<MTSearchMixLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

- (SearchModel *)itemModelForLayoutWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
