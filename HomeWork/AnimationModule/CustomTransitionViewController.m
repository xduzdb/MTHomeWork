//
//  CustomTransitionViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "CustomTransitionViewController.h"
#import "CustomTransitionDetailViewController.h"
#import "CustomTransitionAnimator.h"

static NSString * const kCellIdentifier = @"CardCell";

@interface CustomTransitionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *cardData;
@property (nonatomic, strong) UICollectionViewCell *selectedCell;

@end

@implementation CustomTransitionViewController

+ (void)initialize {
    if (self == [CustomTransitionViewController class]) {
        [self registerNavigationClass];
    }
}

+ (NSString *)navigationTitle {
    return @"双列布局自定义转场动画";
}

+ (UIColor *)navigationColor {
    return [UIColor systemTealColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义转场";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    NSArray<UIColor *> *colors = @[
        [UIColor systemRedColor],
        [UIColor systemBlueColor],
        [UIColor systemGreenColor],
        [UIColor systemOrangeColor],
        [UIColor systemPurpleColor],
        [UIColor systemPinkColor],
        [UIColor systemIndigoColor],
        [UIColor systemTealColor],
        [UIColor systemYellowColor],
        [UIColor systemCyanColor]
    ];
    
    NSArray<NSString *> *titles = @[
        @"红色卡片", @"蓝色卡片", @"绿色卡片", @"橙色卡片",
        @"紫色卡片", @"粉色卡片", @"靛蓝卡片", @"青色卡片",
        @"黄色卡片", @"青色卡片"
    ];
    
    NSMutableArray *data = [NSMutableArray array];
    for (NSInteger i = 0; i < colors.count; i++) {
        [data addObject:@{@"color": colors[i], @"title": titles[i]}];
    }
    self.cardData = [data copy];
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 15;
    CGFloat itemWidth = (self.view.frame.size.width - padding * 3) / 2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.2);
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cardData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // 移除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSDictionary *data = self.cardData[indexPath.item];
    UIColor *color = data[@"color"];
    NSString *title = data[@"title"];
    
    // 卡片视图
    UIView *cardView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    cardView.backgroundColor = color;
    cardView.layer.cornerRadius = 16;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 4);
    cardView.layer.shadowOpacity = 0.2;
    cardView.layer.shadowRadius = 8;
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = cardView.bounds;
    [cardView addSubview:titleLabel];
    
    [cell.contentView addSubview:cardView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.selectedCell = cell;
    
    NSDictionary *data = self.cardData[indexPath.item];
    CustomTransitionDetailViewController *detailVC = [[CustomTransitionDetailViewController alloc] init];
    detailVC.cardColor = data[@"color"];
    detailVC.cardTitle = data[@"title"];
    
    // 获取 cell 在 window 中的 frame
    CGRect cellFrame = [cell convertRect:cell.bounds toView:nil];
    detailVC.sourceFrame = cellFrame;
    
    // 设置转场代理
    detailVC.transitioningDelegate = self;
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailVC animated:YES completion:^{
        // 确保转场完成后可以立即再次打开
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    CustomTransitionAnimator *animator = [[CustomTransitionAnimator alloc] init];
    animator.isPresenting = YES;
    if ([presented isKindOfClass:[CustomTransitionDetailViewController class]]) {
        CustomTransitionDetailViewController *detailVC = (CustomTransitionDetailViewController *)presented;
        animator.sourceFrame = detailVC.sourceFrame;
    }
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    CustomTransitionAnimator *animator = [[CustomTransitionAnimator alloc] init];
    animator.isPresenting = NO;
    if ([dismissed isKindOfClass:[CustomTransitionDetailViewController class]]) {
        CustomTransitionDetailViewController *detailVC = (CustomTransitionDetailViewController *)dismissed;
        animator.sourceFrame = detailVC.sourceFrame;
    }
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if ([animator isKindOfClass:[CustomTransitionAnimator class]]) {
        CustomTransitionDetailViewController *detailVC = (CustomTransitionDetailViewController *)self.presentedViewController;
        return detailVC.interactiveTransition;
    }
    return nil;
}
@end

