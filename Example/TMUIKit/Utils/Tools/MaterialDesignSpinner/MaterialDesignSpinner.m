//
//  MMMaterialDesignSpinner.m
//  Pods
//
//  Created by Michael Maxwell on 12/28/14.
//
//

#import "MaterialDesignSpinner.h"

#define kLoadingViewH 134

@interface LoadingView ()

@property (strong, nonatomic) MaterialDesignSpinner *spinner;

@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation LoadingView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.frame = CGRectMake(16, kMTFYScreenH-16-kLoadingViewH, kMTFYScreenW-16*2, kLoadingViewH);
    self.backgroundColor = UIColor.whiteColor;
    [self.layer applyShadow:HEXCOLOR(0x85868B) alpha:1 x:0 y:0 blue:16 spread:0];
    self.layer.cornerRadius = 8;
}

#pragma mark - Public

- (void)show {
    if (self.spinner) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }

    MaterialDesignSpinner *spinner = [[MaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 32, 50, 50)];
    spinner.center = CGPointMake(self.width / 2.0, 50);
    spinner.lineWidth = 4;
    spinner.tintColor = HEXCOLOR(0x00C3CE);
    [spinner startAnimating];
    [self addSubview:spinner];
    self.spinner = spinner;

    if (![self superview]) {
        [self.superV addSubview:self];
    }
}

- (void)showWithStatus:(NSString *)status{
    [self show];
    if (!self.statusLabel.superview) {
        [self addSubview:self.statusLabel];
        CGPoint center = CGPointMake(self.spinner.center.x, kLoadingViewH-32);
        self.statusLabel.center = center;
    }
    self.statusLabel.text = status;
}

- (void)dismiss{
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
    [self removeFromSuperview];
}

#pragma mark - Getters and Setters

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.frame = CGRectMake(0, 0, KScreenW * 0.8, 15);
        _statusLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _statusLabel.textColor = HEXCOLOR(0x999999);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (id)superV {
    if (!_superV) {
        _superV = [[[UIApplication sharedApplication] delegate] window];
    }
    return _superV;
}

#pragma mark - Supperclass
#pragma mark - NSObject

//static LoadingView *_loadView = nil;
//+(instancetype) sharedInstance {
//    static dispatch_once_t userOnceToken;
//    dispatch_once(&userOnceToken, ^{
//        _loadView = [[self alloc] initWithFrame:CGRectMake(16, kMTFYScreenH-16-kLoadingViewH, kMTFYScreenW-16*2, kLoadingViewH)];
//        _loadView.backgroundColor = UIColor.whiteColor;
//        [_loadView.layer applyShadow:HEXCOLOR(0x85868B) alpha:1 x:0 y:0 blue:16 spread:0];
//        _loadView.layer.cornerRadius = 8;
//    });
//    return _loadView;
//}
//
//- (UILabel *)statusLabel{
//    if (!_statusLabel) {
//        _statusLabel = [[UILabel alloc] init];
//        _statusLabel.frame = CGRectMake(0, 0, KScreenW * 0.8, 15);
//        _statusLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        _statusLabel.textColor = HEXCOLOR(0x999999);
//        _statusLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _statusLabel;
//}

//+ (void)show{
//    if ([LoadingView sharedInstance].spinner) {
//        [[LoadingView sharedInstance].spinner removeFromSuperview];
//        [LoadingView sharedInstance].spinner = nil;
//    }
//
//    MaterialDesignSpinner *spinner = [[MaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 32, 50, 50)];
//    spinner.center = CGPointMake([LoadingView sharedInstance].width/2.0, 50);
//    spinner.lineWidth = 4;
//    spinner.tintColor = HEXCOLOR(0x00C3CE);
//    [spinner startAnimating];
//    [[LoadingView sharedInstance] addSubview:spinner];
//    [ addSubview:[LoadingView sharedInstance]] ;KEY_WINDOW
//    [LoadingView sharedInstance].spinner = spinner;
//}
//
//+ (void)showWithStatus:(NSString *)status{
//    [LoadingView show];
//    if (![LoadingView sharedInstance].statusLabel.superview) {
//        [[LoadingView sharedInstance] addSubview:[LoadingView sharedInstance].statusLabel];
//        CGPoint center = CGPointMake([LoadingView sharedInstance].spinner.center.x, kLoadingViewH-32);
//        [LoadingView sharedInstance].statusLabel.center = center;
//    }
//    [LoadingView sharedInstance].statusLabel.text = status;
//}
//
//+ (void)dismiss{
//    [[LoadingView sharedInstance].spinner stopAnimating];
//    [[LoadingView sharedInstance].spinner removeFromSuperview];
//    [LoadingView sharedInstance].spinner = nil;
//    [[LoadingView sharedInstance] removeFromSuperview];
//}

@end



static NSString *kMMRingStrokeAnimationKey = @"mmmaterialdesignspinner.stroke";
static NSString *kMMRingRotationAnimationKey = @"mmmaterialdesignspinner.rotation";

@interface MaterialDesignSpinner ()
@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readwrite) BOOL isAnimating;
@end

@implementation MaterialDesignSpinner

@synthesize progressLayer=_progressLayer;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.duration = 1.5f;
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:self.progressLayer];
    
    // See comment in resetAnimations on why this notification is used.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    self.progressLayer.strokeColor = self.tintColor.CGColor;
}

- (void)resetAnimations {
    // If the app goes to the background, returning it to the foreground causes the animation to stop (even though it's not explicitly stopped by our code). Resetting the animation seems to kick it back into gear.
    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)setAnimating:(BOOL)animate {
    (animate ? [self startAnimating] : [self stopAnimating]);
}



- (void)startAnimating {
    if (self.isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = self.duration / 0.375f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    [self.progressLayer addAnimation:animation forKey:kMMRingRotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = self.duration / 1.5f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = self.duration / 1.5f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = self.duration / 1.5f;
    endHeadAnimation.duration = self.duration / 3.0f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = self.duration / 1.5f;
    endTailAnimation.duration = self.duration / 3.0f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = self.timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:self.duration];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    animations.removedOnCompletion = NO;
    [self.progressLayer addAnimation:animations forKey:kMMRingStrokeAnimationKey];
    
    
    self.isAnimating = true;
    
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;
    
    [self.progressLayer removeAnimationForKey:kMMRingRotationAnimationKey];
    [self.progressLayer removeAnimationForKey:kMMRingStrokeAnimationKey];
    self.isAnimating = false;
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - Private

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 0.f;
}

#pragma mark - Properties

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}

@end
