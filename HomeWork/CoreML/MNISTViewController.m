//
//  MNISTViewController.m
//  HomeWork
//
//  Created by 张家和 on 2025/6/25.
//

#import "MNISTViewController.h"
#import <CoreML/CoreML.h>
#import <Vision/Vision.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DrawingView : UIView
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *paths;
- (void)clearDrawing;
- (UIImage *)getDrawingAsImage;
@end

@implementation DrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.paths = [NSMutableArray array];
        
        // 设置圆角和边框
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor systemBlueColor].CGColor;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    self.path = [UIBezierPath bezierPath];
    self.path.lineWidth = 8.0;
    self.path.lineCapStyle = kCGLineCapRound;
    self.path.lineJoinStyle = kCGLineJoinRound;
    [self.path moveToPoint:point];
    [self.paths addObject:self.path];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.path addLineToPoint:point];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] setStroke];
    for (UIBezierPath *path in self.paths) {
        [path stroke];
    }
}

- (void)clearDrawing {
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

- (UIImage *)getDrawingAsImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface MNISTViewController ()

@property (nonatomic, strong) DrawingView *drawingView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *confidenceLabel;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *predictButton;
@property (nonatomic, strong) MLModel *model;
@property (nonatomic, strong) VNCoreMLModel *visionModel;

@end

@implementation MNISTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self loadModel];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"手写数字识别";
    self.navigationItem.backButtonTitle = @"";
    
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"MNIST 手写数字识别";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleLabel];
    
    // 说明标签
    self.instructionLabel = [[UILabel alloc] init];
    self.instructionLabel.text = @"在下方黑色区域手写一个数字（0-9）";
    self.instructionLabel.font = [UIFont systemFontOfSize:16];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.textColor = [UIColor secondaryLabelColor];
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.instructionLabel];
    
    // 绘图视图
    self.drawingView = [[DrawingView alloc] init];
    self.drawingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.drawingView];
    
    // 清除按钮
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton setTitle:@"清除" forState:UIControlStateNormal];
    self.clearButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.clearButton.backgroundColor = [UIColor systemRedColor];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clearButton.layer.cornerRadius = 8;
    self.clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.clearButton addTarget:self action:@selector(clearDrawing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    // 识别按钮
    self.predictButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.predictButton setTitle:@"识别" forState:UIControlStateNormal];
    self.predictButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.predictButton.backgroundColor = [UIColor systemBlueColor];
    [self.predictButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.predictButton.layer.cornerRadius = 8;
    self.predictButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.predictButton addTarget:self action:@selector(predictDigit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.predictButton];
    
    // 结果标签
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.text = @"识别结果: --";
    self.resultLabel.font = [UIFont boldSystemFontOfSize:28];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.textColor = [UIColor systemBlueColor];
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.resultLabel];
    
    // 置信度标签
    self.confidenceLabel = [[UILabel alloc] init];
    self.confidenceLabel.text = @"置信度: --%";
    self.confidenceLabel.font = [UIFont systemFontOfSize:16];
    self.confidenceLabel.textAlignment = NSTextAlignmentCenter;
    self.confidenceLabel.textColor = [UIColor secondaryLabelColor];
    self.confidenceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.confidenceLabel];
}

- (void)setupLayout {
    [NSLayoutConstraint activateConstraints:@[
        // 标题
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        // 说明
        [self.instructionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:15],
        [self.instructionLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.instructionLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        // 绘图区域
        [self.drawingView.topAnchor constraintEqualToAnchor:self.instructionLabel.bottomAnchor constant:20],
        [self.drawingView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.drawingView.widthAnchor constraintEqualToConstant:280],
        [self.drawingView.heightAnchor constraintEqualToConstant:280],
        
        // 按钮
        [self.clearButton.topAnchor constraintEqualToAnchor:self.drawingView.bottomAnchor constant:20],
        [self.clearButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:40],
        [self.clearButton.widthAnchor constraintEqualToConstant:100],
        [self.clearButton.heightAnchor constraintEqualToConstant:44],
        
        [self.predictButton.topAnchor constraintEqualToAnchor:self.drawingView.bottomAnchor constant:20],
        [self.predictButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-40],
        [self.predictButton.widthAnchor constraintEqualToConstant:100],
        [self.predictButton.heightAnchor constraintEqualToConstant:44],
        
        // 结果
        [self.resultLabel.topAnchor constraintEqualToAnchor:self.clearButton.bottomAnchor constant:30],
        [self.resultLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.resultLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.confidenceLabel.topAnchor constraintEqualToAnchor:self.resultLabel.bottomAnchor constant:10],
        [self.confidenceLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.confidenceLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
    ]];
}

- (void)loadModel {
    NSError *error;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MNISTClassifier" withExtension:@"mlmodelc"];
    
    if (!modelURL) {
        NSLog(@"❌ 找不到 MNISTClassifier.mlmodelc 文件，请确保已添加到项目中");
        [self showAlert:@"模型加载失败" message:@"找不到 MNISTClassifier.mlmodelc 文件\n请将模型文件拖拽到项目中"];
        return;
    }
    
    // 加载模型
    self.model = [MLModel modelWithContentsOfURL:modelURL error:&error];
    if (error) {
        NSLog(@"❌ 模型加载失败: %@", error.localizedDescription);
        [self showAlert:@"模型加载失败" message:error.localizedDescription];
        return;
    }
    
    // 创建Vision模型
    self.visionModel = [VNCoreMLModel modelForMLModel:self.model error:&error];
    if (error) {
        NSLog(@"❌ Vision模型创建失败: %@", error.localizedDescription);
        [self showAlert:@"Vision模型创建失败" message:error.localizedDescription];
        return;
    }
    
    NSLog(@"✅ MNIST模型加载成功");
}

- (void)clearDrawing {
    [self.drawingView clearDrawing];
    self.resultLabel.text = @"识别结果: --";
    self.confidenceLabel.text = @"置信度: --%";
    
    // 添加触觉反馈
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [generator impactOccurred];
}

- (void)predictDigit {
    if (!self.visionModel) {
        [self showAlert:@"模型未就绪" message:@"请确保 MNISTClassifier.mlmodel 已正确加载"];
        return;
    }
    
    // 添加触觉反馈
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
    
    // 获取绘图
    UIImage *drawingImage = [self.drawingView getDrawingAsImage];
    if (!drawingImage) {
        [self showAlert:@"获取绘图失败" message:@"请先在黑色区域绘制一个数字"];
        return;
    }
    
    // 预处理图像
    UIImage *processedImage = [self preprocessImage:drawingImage];
    if (!processedImage) {
        [self showAlert:@"图像处理失败" message:@"无法预处理图像"];
        return;
    }
    
    // 创建识别请求
    VNCoreMLRequest *request = [[VNCoreMLRequest alloc] initWithModel:self.visionModel completionHandler:^(VNRequest *request, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showAlert:@"识别失败" message:error.localizedDescription];
                return;
            }
            
            [self handlePredictionResults:request.results];
        });
    }];
    
    request.imageCropAndScaleOption = VNImageCropAndScaleOptionCenterCrop;
    
    // 执行识别
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:[CIImage imageWithCGImage:processedImage.CGImage] options:@{}];
    
    NSError *error;
    if (![handler performRequests:@[request] error:&error]) {
        [self showAlert:@"识别执行失败" message:error.localizedDescription];
    }
}

- (UIImage *)preprocessImage:(UIImage *)image {
    // 转换为28x28灰度图像（MNIST标准）
    CGSize targetSize = CGSizeMake(28, 28);
    
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 1.0);
    
    // 设置背景为黑色
    [[UIColor blackColor] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, targetSize.width, targetSize.height));
    
    // 计算居中绘制的rect
    CGFloat scale = MIN(targetSize.width / image.size.width, targetSize.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    CGRect drawRect = CGRectMake((targetSize.width - scaledSize.width) / 2,
                                (targetSize.height - scaledSize.height) / 2,
                                scaledSize.width,
                                scaledSize.height);
    
    [image drawInRect:drawRect];
    
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return processedImage;
}

- (void)handlePredictionResults:(NSArray<VNObservation *> *)results {
    if (results.count == 0) {
        self.resultLabel.text = @"识别结果: 无结果";
        self.confidenceLabel.text = @"置信度: --%";
        return;
    }
    
    // 获取最佳预测结果
    VNClassificationObservation *topResult = (VNClassificationObservation *)results.firstObject;
    
    if ([topResult isKindOfClass:[VNClassificationObservation class]]) {
        NSString *digit = topResult.identifier;
        CGFloat confidence = topResult.confidence * 100;
        
        self.resultLabel.text = [NSString stringWithFormat:@"识别结果: %@", digit];
        self.confidenceLabel.text = [NSString stringWithFormat:@"置信度: %.1f%%", confidence];
        
        // 如果置信度高，添加成功反馈
        if (confidence > 80.0) {
            UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
            [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
            
            self.resultLabel.textColor = [UIColor systemGreenColor];
        } else if (confidence > 50.0) {
            self.resultLabel.textColor = [UIColor systemOrangeColor];
        } else {
            self.resultLabel.textColor = [UIColor systemRedColor];
        }
        
        NSLog(@"✅ 识别结果: %@ (置信度: %.1f%%)", digit, confidence);
        
        // 显示更详细的结果
        if (results.count > 1) {
            NSMutableString *detailString = [NSMutableString stringWithString:@"其他可能结果:\n"];
            for (int i = 1; i < MIN(3, results.count); i++) {
                VNClassificationObservation *result = (VNClassificationObservation *)results[i];
                if ([result isKindOfClass:[VNClassificationObservation class]]) {
                    [detailString appendFormat:@"%@: %.1f%% ", result.identifier, result.confidence * 100];
                }
            }
            NSLog(@"📊 %@", detailString);
        }
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end 
