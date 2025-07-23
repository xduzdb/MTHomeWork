//
//  TestTableViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "TestTableViewController.h"

@interface TestTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat safeAreaHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger createdCellCount;

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.size.height;
    self.cellHeight = 93;
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"创建的cell总数: %ld", (long)self.createdCellCount);
    });
}

- (void)setupData {
    self.dataArray = [NSMutableArray array];
    self.createdCellCount = 0;
    
    for (int i = 0; i < 20; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"Cell %d", i + 1]];
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UITableView Cell高度测试";
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor redColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TestCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)setupLayout {
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    self.createdCellCount++;
    NSLog(@"创建了第 %ld 个cell, 地址: %p", (long)self.createdCellCount, cell);
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"当前总共创建了 %ld 个cell", (long)self.createdCellCount);
}



@end 
