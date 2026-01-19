//
//  ViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "ViewController.h"
#import "MTNavigationProtocol.h"
#import "BaseViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<Class> *navigationClasses;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 从 BaseViewController 获取所有已注册的导航类
    self.navigationClasses = [BaseViewController allNavigationClasses];
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
    return self.navigationClasses.count;
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
    
    // 从协议方法获取信息
    Class viewControllerClass = self.navigationClasses[indexPath.item];
    NSString *title = @"";
    UIColor *color = [UIColor systemGrayColor];
    
    if ([viewControllerClass respondsToSelector:@selector(navigationTitle)]) {
        title = [viewControllerClass navigationTitle];
    }
    if ([viewControllerClass respondsToSelector:@selector(navigationColor)]) {
        color = [viewControllerClass navigationColor];
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    button.tag = indexPath.item; // 使用 tag 存储索引
    [button addTarget:self action:@selector(navigateToViewController:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)navigateToViewController:(UIButton *)button {
    NSInteger index = button.tag;
    if (index < 0 || index >= self.navigationClasses.count) {
        return;
    }
    
    Class viewControllerClass = self.navigationClasses[index];
    
    // 使用 respondsToSelector 检查是否实现了协议方法
    if ([viewControllerClass respondsToSelector:@selector(navigationInstance)]) {
        // 使用 performSelector 并转换为正确的类型
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIViewController *viewController = [viewControllerClass performSelector:@selector(navigationInstance)];
        #pragma clang diagnostic pop
        if (viewController) {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
