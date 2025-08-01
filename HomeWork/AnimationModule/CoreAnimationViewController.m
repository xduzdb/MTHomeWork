#import "CoreAnimationViewController.h"

@interface CoreAnimationViewController ()

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint originalBoardCenter;

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

- (void)updatePath {
    // 更新控制点位置
    CGFloat progress = (self.boardView.center.y - self.originalBoardCenter.y) / 50.0; // 可以调整这个系数
    
    self.upView.center = CGPointMake(self.upView.center.x, 
                                    self.originalBoardCenter.y + (self.ballView.center.y - self.originalBoardCenter.y) / 4 + progress * 10);
    
    self.downView.center = CGPointMake(self.downView.center.x, 
                                      self.ballView.center.y - (self.ballView.center.y - self.originalBoardCenter.y) / 4 + progress * 5);
    
    // 更新贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.boardView.center];
    [path addCurveToPoint:self.ballView.center 
            controlPoint1:self.upView.center 
            controlPoint2:self.downView.center];
    
    self.shapeLayer.path = path.CGPath;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    if (!((pan.view.center.y + point.y) > height/2 - pan.view.frame.size.height/2)) {
        pan.view.center = CGPointMake(pan.view.center.x, pan.view.center.y + point.y);
        [pan setTranslation:CGPointZero inView:pan.view];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || 
        pan.state == UIGestureRecognizerStateCancelled || 
        pan.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:0.5 
                              delay:0 
             usingSpringWithDamping:0.5 
              initialSpringVelocity:0.5 
                            options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
            self.boardView.center = self.originalBoardCenter;
        } completion:nil];
    }
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end