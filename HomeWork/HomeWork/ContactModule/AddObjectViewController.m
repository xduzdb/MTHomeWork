//
//  addObjectViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/26.
//

#import "AddObjectViewController.h"

@interface AddObjectViewController ()

@end

@implementation AddObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // 添加 UILabel
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;  // 使用Auto Layout
    label.text = @"弹窗标题";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:label];

    // 添加 UITextView
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;  // 使用Auto Layout
    textView.text = @"这是一个文本输入框。";
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.cornerRadius = 5.0;
    [self.view addSubview:textView];

    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // UILabel约束
        [label.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        // UITextView约束
        [textView.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:20],
        [textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20]
    ]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
