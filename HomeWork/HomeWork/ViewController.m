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

static NSString *kContactTitle = @"跳转联系人列表";
static NSString *kSearchTitle = @"跳转搜索结果页列表";
static NSString *kTestTableTitle = @"UITableView复用";
static NSString *kAnimationTitle = @"UIView动画演示";

@interface ViewController ()
// 联系人TableView
@property (nonatomic, strong) UIButton *contactButton;
// MTSearch的CollectionView
@property (nonatomic, strong) UIButton *MTSearchButton;
// UITableView测试按钮
@property (nonatomic, strong) UIButton *testTableButton;
// UIView动画演示按钮
@property (nonatomic, strong) UIButton *animationButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setLayout];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backButtonTitle = @"";
    self.title = @"HomeWork";
    
    self.contactButton = [[UIButton alloc] init];
    self.contactButton.backgroundColor = [UIColor blackColor];
    [self.contactButton setTitle:kContactTitle forState: UIControlStateNormal];
    self.contactButton.titleLabel.textColor = [UIColor whiteColor];
    [self.contactButton addTarget:self action:@selector(jumpToContactView) forControlEvents:UIControlEventTouchUpInside];
    
    self.MTSearchButton = [[UIButton alloc] init];
    self.MTSearchButton.backgroundColor = [UIColor blackColor];
    [self.MTSearchButton setTitle:kSearchTitle forState: UIControlStateNormal];
    self.MTSearchButton.titleLabel.textColor = [UIColor whiteColor];
    [self.MTSearchButton addTarget:self action:@selector(jumpToSearchView) forControlEvents:UIControlEventTouchUpInside];
    
    self.testTableButton = [[UIButton alloc] init];
    self.testTableButton.backgroundColor = [UIColor blackColor];
    [self.testTableButton setTitle:kTestTableTitle forState: UIControlStateNormal];
    self.testTableButton.titleLabel.textColor = [UIColor whiteColor];
    [self.testTableButton addTarget:self action:@selector(jumpToTestTableView) forControlEvents:UIControlEventTouchUpInside];
    
    self.animationButton = [[UIButton alloc] init];
    self.animationButton.backgroundColor = [UIColor blackColor];
    [self.animationButton setTitle:kAnimationTitle forState: UIControlStateNormal];
    self.animationButton.titleLabel.textColor = [UIColor whiteColor];
    [self.animationButton addTarget:self action:@selector(jumpToAnimationView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.contactButton];
    [self.view addSubview:self.MTSearchButton];
    [self.view addSubview:self.testTableButton];
    [self.view addSubview:self.animationButton];
}

- (void)setLayout {
    self.contactButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.MTSearchButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.testTableButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.animationButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // contactButton 约束
        [self.contactButton.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor constant:-180],
        [self.contactButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:100],
        [self.contactButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-100],
        [self.contactButton.heightAnchor constraintEqualToConstant:80],

        // MTSearchButton 约束
        [self.MTSearchButton.topAnchor constraintEqualToAnchor:self.contactButton.bottomAnchor constant:15],
        [self.MTSearchButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:100],
        [self.MTSearchButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-100],
        [self.MTSearchButton.heightAnchor constraintEqualToConstant:80],
        
        // testTableButton 约束
        [self.testTableButton.topAnchor constraintEqualToAnchor:self.MTSearchButton.bottomAnchor constant:15],
        [self.testTableButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:100],
        [self.testTableButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-100],
        [self.testTableButton.heightAnchor constraintEqualToConstant:80],
        
        // animationButton 约束
        [self.animationButton.topAnchor constraintEqualToAnchor:self.testTableButton.bottomAnchor constant:15],
        [self.animationButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:100],
        [self.animationButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-100],
        [self.animationButton.heightAnchor constraintEqualToConstant:80],
    ]];
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

@end
