//
//  ViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "ViewController.h"
#import "ContactViewController.h"
#import "MTSearchViewController.h"
#import "TestTableViewController.h"
#import "AnimationViewController.h"
#import "MNISTViewController.h"
#import "AttachmentViewController.h"

static NSString *kContactTitle = @"跳转联系人列表";
static NSString *kSearchTitle = @"跳转搜索结果页列表";
static NSString *kTestTableTitle = @"UITableView复用";
static NSString *kAnimationTitle = @"UIView动画演示";
static NSString *kMNISTTitle = @"手写数字识别";
static NSString *kAttachmentTitle = @"UIDynamic吸附动画";

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.navigationItem.backButtonTitle = @"";
    self.title = @"功能演示";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 15;
    CGFloat itemWidth = (self.view.frame.size.width - padding * 3) / 2;
    layout.itemSize = CGSizeMake(itemWidth, 100);
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ButtonCell"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6; // 修改为剩余的按钮数量
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
    
    // 移除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = cell.contentView.bounds;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 16;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 2);
    button.layer.shadowOpacity = 0.1;
    button.layer.shadowRadius = 4;
    
    // 添加按下效果
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    NSString *title;
    UIColor *color;
    SEL action;
    
    switch (indexPath.item) {
        case 0:
            title = kContactTitle;
            color = [UIColor systemBlueColor];
            action = @selector(jumpToContactView);
            break;
        case 1:
            title = kSearchTitle;
            color = [UIColor systemIndigoColor];
            action = @selector(jumpToSearchView);
            break;
        case 2:
            title = kTestTableTitle;
            color = [UIColor systemPurpleColor];
            action = @selector(jumpToTestTableView);
            break;
        case 3:
            title = kAnimationTitle;
            color = [UIColor systemPinkColor];
            action = @selector(jumpToAnimationView);
            break;
        case 4:
            title = kMNISTTitle;
            color = [UIColor systemCyanColor];
            action = @selector(jumpToMNISTView);
            break;
        case 5:
            title = kAttachmentTitle;
            color = [UIColor systemOrangeColor];
            action = @selector(jumpToAttachmentView);
            break;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 可以在这里处理按钮点击事件
}

#pragma mark - Button Actions

- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
        button.alpha = 0.8;
    }];
}

- (void)buttonTouchUp:(UIButton *)button {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        button.transform = CGAffineTransformIdentity;
        button.alpha = 1.0;
    } completion:nil];
}

- (void)jumpToContactView {
    ContactViewController *vc = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)jumpToSearchView {
    MTSearchViewController *vc = [[MTSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)jumpToTestTableView {
    TestTableViewController *vc = [[TestTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)jumpToAnimationView {
    AnimationViewController *vc = [[AnimationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)jumpToMNISTView {
    MNISTViewController *vc = [[MNISTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)jumpToAttachmentView {
    AttachmentViewController *vc = [[AttachmentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
