#import "AttachmentViewController.h"
#import "CoreAnimationViewController.h"

@interface AttachmentViewController ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) UIGravityBehavior *boardGravityBehavior;
@property (nonatomic, strong) UIGravityBehavior *controlGravityBehavior;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupBehaviors];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加底部切换按钮
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [switchButton setTitle:@"切换到Core Animation实现" forState:UIControlStateNormal];
    switchButton.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 40);
    [switchButton addTarget:self action:@selector(switchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    // 创建boardView
    self.boardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height/2)];
    self.boardView.alpha = 0.5;
    self.boardView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.boardView];
    
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

- (void)setupBehaviors {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 添加boardView的重力行为
    self.boardGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.boardView]];
    [self.dynamicAnimator addBehavior:self.boardGravityBehavior];
    
    // 添加控制点的重力行为
    self.controlGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ballView, self.upView, self.downView]];
    
    __weak typeof(self) weakSelf = self;
    self.controlGravityBehavior.action = ^{
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:weakSelf.boardView.center];
        [path addCurveToPoint:weakSelf.ballView.center 
                controlPoint1:weakSelf.upView.center 
                controlPoint2:weakSelf.downView.center];
        weakSelf.shapeLayer.path = path.CGPath;
    };
    [self.dynamicAnimator addBehavior:self.controlGravityBehavior];
    
    // 添加碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.boardView]];
    [collisionBehavior addBoundaryWithIdentifier:@"Left" fromPoint:CGPointMake(-1, 0) toPoint:CGPointMake(-1, height)];
    [collisionBehavior addBoundaryWithIdentifier:@"Right" fromPoint:CGPointMake(width+1, 0) toPoint:CGPointMake(width+1, height)];
    [collisionBehavior addBoundaryWithIdentifier:@"Middle" fromPoint:CGPointMake(0, height/2) toPoint:CGPointMake(width, height/2)];
    [self.dynamicAnimator addBehavior:collisionBehavior];
    
    // 添加吸附行为
    UIAttachmentBehavior *upAttch = [[UIAttachmentBehavior alloc] initWithItem:self.boardView 
                                                             offsetFromCenter:UIOffsetMake(1, 1) 
                                                             attachedToItem:self.upView 
                                                             offsetFromCenter:UIOffsetZero];
    
    UIAttachmentBehavior *downAttch = [[UIAttachmentBehavior alloc] initWithItem:self.upView 
                                                               offsetFromCenter:UIOffsetZero 
                                                               attachedToItem:self.downView 
                                                               offsetFromCenter:UIOffsetZero];
    
    UIAttachmentBehavior *ballAttch = [[UIAttachmentBehavior alloc] initWithItem:self.downView 
                                                               offsetFromCenter:UIOffsetZero 
                                                               attachedToItem:self.ballView 
                                                               offsetFromCenter:UIOffsetMake(0, -30)];
    
    [self.dynamicAnimator addBehavior:upAttch];
    [self.dynamicAnimator addBehavior:downAttch];
    [self.dynamicAnimator addBehavior:ballAttch];
    
    // 添加动力学元素行为
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.boardView, self.upView, self.downView, self.ballView]];
    itemBehavior.elasticity = 0.5;
    [self.dynamicAnimator addBehavior:itemBehavior];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            // 开始拖动时，确保先移除所有现有的重力行为
            [self.dynamicAnimator removeBehavior:self.boardGravityBehavior];
            // 重置视图状态
            [self.dynamicAnimator updateItemUsingCurrentState:pan.view];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [pan translationInView:self.view];
            CGPoint center = pan.view.center;
            
            // 限制垂直移动范围
            CGFloat newY = center.y + translation.y;
            CGFloat maxY = height/2 - pan.view.frame.size.height/2;
            CGFloat minY = 0;  // 添加最小值限制
            
            // 确保在有效范围内
            newY = MAX(minY, MIN(newY, maxY));
            center.y = newY;
            pan.view.center = center;
            
            [pan setTranslation:CGPointZero inView:self.view];
            
            // 实时更新动力学状态
            [self.dynamicAnimator updateItemUsingCurrentState:pan.view];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            // 先移除可能存在的重力行为
            [self.dynamicAnimator removeBehavior:self.boardGravityBehavior];
            
            // 确保视图状态是最新的
            [self.dynamicAnimator updateItemUsingCurrentState:pan.view];
            
            // 添加新的重力行为
            [self.dynamicAnimator addBehavior:self.boardGravityBehavior];
            break;
        }
            
        default:
            break;
    }
}

- (void)switchButtonTapped {
    CoreAnimationViewController *coreAnimVC = [[CoreAnimationViewController alloc] init];
    [self.navigationController pushViewController:coreAnimVC animated:YES];
}

@end
