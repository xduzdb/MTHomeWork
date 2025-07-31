//
//  MTSearchViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/7/2.
//

#import "SearchModel.h"
#import "MTSearchViewController.h"
#import "MTSearchCollectionViewCell.h"
static CGFloat const kMinimumLineSpacing = 8.f;
static CGFloat const kMinimumInteritemSpacing = 16.f;

@interface MTSearchViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation MTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"MTSearchViewDemo";
    // Do any additional setup after loading the view.
    [self setupSearchModel];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

#pragma mark -SetUI && SetModel

- (void)setupSearchModel {
    // Mock数据
    self.items = @[].mutableCopy;
    NSArray<UIColor *> *backgroundColors = @[[UIColor redColor], [UIColor yellowColor], [UIColor grayColor], [UIColor greenColor], [UIColor blueColor]];
    for (int i = 0; i < 100; i++) {
        BOOL isStick = (i % 5 == 0); // 每五个一个吸顶
        BOOL isSuperStick = (i % 7 == 0); // 每七个一个吸顶
        MTItemLayoutType type = (i % 5 == 0)  ? MTItemLayoutTypeSingle : MTItemLayoutTypeDouble; // 每五个一个单列
        CGFloat height = isSuperStick ? 50.0 : 70.0 + (i % 4) * 10 ; // 常驻吸顶都是高度50，其他都是随机高度 70-100之间
        UIColor *bgColor = isSuperStick ? UIColor.orangeColor : backgroundColors[i % backgroundColors.count] ;
        SearchModel *model = [[SearchModel alloc] initWithTitle:@"美食开胃菜"
                                                backgroundColor:bgColor
                                                        isStick:isStick
                                                   isSuperStick:isSuperStick
                                                         height:height
                                                           type:type
                                                           data:nil];
        [self.items addObject: model];
    }
}

- (void)setupUI {
    MTSearchMixLayout *layout = [[MTSearchMixLayout alloc] init];
    layout.minimumLineSpacing = kMinimumLineSpacing;
    layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:MTSearchCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints: @[
       [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
       [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
       [self.collectionView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
       [self.collectionView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
    ]];
}

#pragma mark -Delegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    SearchModel *itemModel = [[SearchModel alloc] init];
    if (indexPath.item < self.items.count) {
        itemModel = [self.items objectAtIndex:indexPath.item];
    }

    [cell configCellWith: itemModel];
    return cell;
}

#pragma mark -Layout
// 使用代理，mixLayout持有vc的代理
- (SearchModel *)itemModelForLayoutWithIndexPath:(NSIndexPath *)indexPath {
    SearchModel *itemModel = [[SearchModel alloc] init];
    if (indexPath.item < self.items.count) {
        itemModel = [self.items objectAtIndex:indexPath.item];
    }
    return itemModel;
}

@end
