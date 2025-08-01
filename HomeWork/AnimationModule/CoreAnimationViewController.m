#import "CoreAnimationViewController.h"

@interface CoreAnimationViewController ()

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint originalBoardCenter;
@property (nonatomic, strong) CASpringAnimation *springAnimation;
@property (nonatomic, assign) CGFloat springVelocity;

@end

@implementation CoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self startDisplayLink];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    // 创建boardView
    self.boardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height/2)];
    self.boardView.alpha = 0.5;
    self.boardView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.boardView];
    self.originalBoardCenter = self.boardView.center;
    
    // 创建ballView
    self.ballView = [[UIView alloc] initWithFrame:CGRectMake(width/2-30, height/1.5, 60, 60)];
    self.ballView.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:self.ballView];
    self.ballView.layer.cornerRadius = 30;
    self.ballView.clipsToBounds = YES;
    self.ballView.layer.shadowOffset = CGSizeMake(-4, 4);
    self.ballView.layer.shadowOpacity = 0.5;
    self.ballView.layer.shadowRadius = 5;
    self.ballView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.ballView.layer.masksToBounds = NO;
    
    // 创建upView
    self.upView = [[UIView alloc] initWithFrame:CGRectMake(width/2-15, 
                                                          (self.ballView.center.y - self.boardView.center.y)/4 + self.boardView.center.y - 15, 
                                                          30, 30)];
    self.upView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.upView];
    
    // 创建downView
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(width/2-15, 
                                                            self.ballView.center.y - (self.ballView.center.y - self.boardView.center.y)/4 - 15, 
                                                            30, 30)];
    self.downView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.downView];
    
    // 创建shapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.lineWidth = 5;
    
    self.shapeLayer.shadowOffset = CGSizeMake(-1, 2);
    self.shapeLayer.shadowOpacity = 0.5;
    self.shapeLayer.shadowRadius = 5;
    self.shapeLayer.shadowColor = [UIColor blackColor].CGColor;
    self.shapeLayer.masksToBounds = NO;
    
    [self.view.layer insertSublayer:self.shapeLayer below:self.ballView.layer];
    
    // 添加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.boardView addGestureRecognizer:pan];
}

- (void)startDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateAttachedViews {
    // 计算各个视图之间的间距
    CGFloat totalDistance = self.ballView.center.y - self.boardView.center.y;
    CGFloat segment = totalDistance / 3;  // 将总距离分成三段
    
    // 更新上控制点位置
    self.upView.center = CGPointMake(self.boardView.center.x, 
                                   self.boardView.center.y + segment);
    
    // 更新下控制点位置
    self.downView.center = CGPointMake(self.boardView.center.x,
                                     self.boardView.center.y + segment * 2);
    
    // 更新小球位置
    self.ballView.center = CGPointMake(self.boardView.center.x,
                                     self.boardView.center.y + segment * 3);
}

- (void)updatePath {
    [self updateAttachedViews];
    
    // 更新贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.boardView.center];
    
    // 使用三次贝塞尔曲线创建更自然的弧度
    [path addCurveToPoint:self.ballView.center 
            controlPoint1:self.upView.center 
            controlPoint2:self.downView.center];
    
    self.shapeLayer.path = path.CGPath;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [pan translationInView:self.view];
            CGPoint velocity = [pan velocityInView:self.view];
            self.springVelocity = velocity.y;
            
            CGPoint center = pan.view.center;
            
            // 限制垂直移动范围
            CGFloat newY = center.y + translation.y;
            CGFloat maxY = height/2 - pan.view.frame.size.height/2;
            CGFloat minY = 0;
            
            newY = MAX(minY, MIN(newY, maxY));
            center.y = newY;
            pan.view.center = center;
            
            // 更新所有吸附视图的位置
            [self updateAttachedViews];
            
            [pan setTranslation:CGPointZero inView:self.view];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.boardView.center = self.originalBoardCenter;
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
