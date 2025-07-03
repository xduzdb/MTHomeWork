//
//  ViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "ViewController.h"
#import "ContactViewController.h"
#import "MTSearchViewController.h"

static NSString *kContactTitle = @"跳转联系人列表";
static NSString *kSearchTitle = @"跳转搜索结果页列表";

@interface ViewController ()
// 联系人TableView
@property (nonatomic, strong) UIButton *contactButton;
// MTSearch的CollectionView
@property (nonatomic, strong) UIButton *MTSearchButton;

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
    
    [self.view addSubview:self.contactButton];
    [self.view addSubview:self.MTSearchButton];
}

- (void)setLayout {
    self.contactButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.MTSearchButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // contactButton 约束
        [self.contactButton.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor constant:-100],
        [self.contactButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:100],
        [self.contactButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-100],
        [self.contactButton.heightAnchor constraintEqualToConstant:100],

        // MTSearchButton 约束
        [self.MTSearchButton.topAnchor constraintEqualToAnchor:self.contactButton.bottomAnchor constant:20],
        [self.MTSearchButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:100],
        [self.MTSearchButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-100],
        [self.MTSearchButton.heightAnchor constraintEqualToConstant:100],
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

@end
