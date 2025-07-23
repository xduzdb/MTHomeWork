//
//  ContactViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "ContactViewController.h"
#import "ContactModel.h"
#import "AddObjectViewController.h"

static NSString *kContactCellIdentifier = @"kContactCellIdentifier";
static NSString *kContactViewDemo = @"kContactViewDemo";
static CGFloat kQuickHeaderItemHeight = 40;
static CGFloat kQuickHeaderItemWidth = 40;

@interface ContactViewController ()

// 静态数据，12个英文字母开头分了12组数据，每组7-10个元素
@property (nonatomic, strong) ContactModel *itemModels;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *sectionArr;
@property (nonatomic, strong) NSMutableArray<NSString *> *sectionHeaderArr;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModel];
    [self setUI];
}
#pragma mark -setUI
- (void)setModel {
    self.itemModels = [[ContactModel alloc] init];
    // 把元素扩充为可变，可编辑
    self.sectionHeaderArr = [self.itemModels.sectionHeaderArr mutableCopy];
    self.sectionArr = [[NSMutableArray alloc] initWithCapacity:self.itemModels.modelArr.count];
    NSArray *section = [[NSArray alloc] init];
    for (section in self.itemModels.modelArr) {
        [self.sectionArr addObject:[section mutableCopy]];
    }
}

- (void)setUI {
    // viewController相关UI
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kContactViewDemo;
    
    UIButton *insertBtn = [[UIButton alloc] init];
    insertBtn.backgroundColor = [UIColor clearColor];
    [insertBtn setTitle:@"添加" forState:UIControlStateNormal];
    [insertBtn setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    
    [insertBtn sizeToFit];
    [insertBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:insertBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    // tableview相关UI
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _tableView.style
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kContactCellIdentifier];
    [self.view addSubview:self.tableView];
    
    
//    _tableView.tableHeaderView
//    headerview  UITableViewHeaderFooterView
//    
//    contentSize
//    contentInset   contentOffset
//    
//    下拉刷新。 上拉加载更多
//    
//    局部刷新
//    
//    reloadData
//    
//    reloadSection  reload  in range
//    
//    
//    视图层级。 section。row。list
//    
    CGFloat x = self.tableView.bounds.size.width - kQuickHeaderItemWidth;
    NSArray *headerArr = self.itemModels.sectionHeaderArr;
    NSInteger headerCount = headerArr.count;
    UIScrollView *scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 200, kQuickHeaderItemWidth, headerCount * kQuickHeaderItemHeight)];
    scorllView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:scorllView];
    for (int i = 0; i < headerCount; i++) {
        UILabel *quickHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + i * kQuickHeaderItemHeight, kQuickHeaderItemWidth, kQuickHeaderItemHeight)];
        quickHeaderLabel.text = headerArr[i];
        quickHeaderLabel.textColor = UIColor.blackColor;
        quickHeaderLabel.textAlignment = NSTextAlignmentCenter;
        // 用于快速定位
        quickHeaderLabel.tag = i;
        quickHeaderLabel.userInteractionEnabled = YES;
        [scorllView addSubview:quickHeaderLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quickHeaderItemClick:)];
        [quickHeaderLabel addGestureRecognizer:tapGesture];
    }
}

#pragma mark -Action
- (void)addBtnClick {
    AddObjectViewController *vc = [[AddObjectViewController alloc] init];
    // 使用 presentViewController 以模态方式显示
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)quickHeaderItemClick: (UITapGestureRecognizer *)sender {
    UILabel *targetView = (UILabel *)sender.view;
    NSInteger tag = targetView.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSString *header = [NSString stringWithFormat:@"%c", 'A' + tag];
    // 选了哪个
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:header
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        // 设定 2 秒后自动消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

#pragma mark -Delegate && DataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 获取当前所需数据
    NSString *itemModel = self.sectionArr[indexPath.section][indexPath.row];
    // cell复用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCellIdentifier forIndexPath:indexPath];
    // 不想自定义Cell，选择用tag来标识contentView子视图是否有绑定的label
//    for (UIView *subView in cell.contentView) {
//        [subView removeFromSuperview];
//    }
//    [cell.contentView ]
//    cell.selectionStyle = 
    UILabel *textLabel = [cell.contentView viewWithTag:100];
    if (!textLabel) {
        CGFloat width = cell.contentView.bounds.size.width;
        CGFloat height = cell.contentView.bounds.size.height;
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, width, height)];
        textLabel.tag = 100;
        [cell.contentView addSubview:textLabel];
    }
    textLabel.text = itemModel;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.sectionArr[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaderArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderArr[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 每行默认启用删除样式
    // TODO: 先改数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.sectionArr[indexPath.section].count == 1) {
            [self showAlertWithTitle:@"警告" msg:@"无法删除所有数据。至少需要保留一个分组。"];
            return;
        }
        [self.sectionArr[indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        if (self.sectionArr[indexPath.section].count == 0) {
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
//            [self.sectionArr removeObjectAtIndex:indexPath.section];
//            [self.sectionHeaderArr removeObjectAtIndex:indexPath.section];
//            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
    }
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg {
    // 禁止删除弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
