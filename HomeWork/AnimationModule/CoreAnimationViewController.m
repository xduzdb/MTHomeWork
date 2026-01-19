#import "CoreAnimationViewController.h"

@interface CoreAnimationViewController ()

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, strong) UIView *basketView;
@property (nonatomic, strong) UIView *backboardView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint originalBallCenter;
@property (nonatomic, assign) CGPoint ballVelocity;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, assign) CGFloat gravity;
@property (nonatomic, assign) CGFloat airResistance;

@end

@implementation CoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
