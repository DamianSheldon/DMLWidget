//
//  DMLRaindropHeaderRefreshControl.m
//  DMLWidget
//
//  Created by Meiliang Dong on 2018/5/8.
//

#import <QuartzCore/QuartzCore.h>

#import "DMLRaindropHeaderRefreshControl.h"

//#define kMinTopRadius       12.5
//#define kMaxTopRadius       16
//#define kMinBottomRadius    3
//#define kMaxBottomRadius    16
//#define kMinBottomPadding   4
//#define kMaxBottomPadding   6
//#define kMinArrowSize       2
//#define kMaxArrowSize       3
//#define kMinArrowRadius     5
//#define kMaxArrowRadius     7

static CGFloat const sRaindropViewWidth = 32.0;

static CGFloat const sRaindropMinTopRadius = 12.5;
static CGFloat const sRaindropMaxTopRadius = 16;

static CGFloat const sRaindropMinBottomRadius = 3;
static CGFloat const sRaindropMaxBottomRadius = 16;

static CGFloat const sRaindropMinArrowSize = 2;
static CGFloat const sRaindropMaxArrowSize = 3;

static CGFloat const sRaindropMinArrowRadius = 3;
static CGFloat const sRaindropMaxArrowRadius = 5;

static inline CGFloat lerp(CGFloat a, CGFloat b, CGFloat p)
{
    return a + (b - a) * p;
}

@class DMLRaindropView;


@interface DMLRaindropShapeLayerContentProvider : NSObject <CALayerDelegate>

@property (nonatomic, weak) DMLRaindropView *raindropView;

@end


@implementation DMLRaindropShapeLayerContentProvider

- (instancetype)initWithRaindropView:(DMLRaindropView *)view
{
    if (self = [super init]) {
        _raindropView = view;
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGMutablePathRef raindropPath = CGPathCreateMutable();

    // Top radius
    // TODO: Replace MJRefreshHeaderHeight with refresh header height
    CGFloat topRadiusRadio = (sRaindropMinTopRadius - sRaindropMaxTopRadius) / (MJRefreshHeaderHeight - sRaindropViewWidth);
    CGFloat b = sRaindropMaxTopRadius - topRadiusRadio * sRaindropViewWidth;

    CGFloat currentTopRadius = floor(topRadiusRadio * CGRectGetHeight(layer.frame) + b);

    CGFloat x = floor(0.5 * CGRectGetWidth(layer.frame) - currentTopRadius);
    CGPoint p1 = CGPointMake(x, currentTopRadius);
    //    CGPoint p2 = CGPointMake(CGRectGetWidth(layer.frame) - x, currentTopRadius);

    CGPoint arcCenter = CGPointMake(0.5 * CGRectGetWidth(layer.frame), currentTopRadius);

    CGPathMoveToPoint(raindropPath, NULL, p1.x, p1.y);
    CGPathAddArc(raindropPath, NULL, arcCenter.x, arcCenter.y, currentTopRadius, M_PI, 2 * M_PI, NO);

    //    CGPathAddLineToPoint(raindropPath, NULL, p2.x, p2.y);

    // Bottom radius
    CGFloat bottomRadiusRadio = (sRaindropMinBottomRadius - sRaindropMaxBottomRadius) / (MJRefreshHeaderHeight - sRaindropViewWidth);
    CGFloat b1 = sRaindropMaxBottomRadius - bottomRadiusRadio * sRaindropViewWidth;

    CGFloat currentBottomRadius = floor(bottomRadiusRadio * CGRectGetHeight(layer.frame) + b1);

    x = floor(0.5 * CGRectGetWidth(layer.frame) - currentBottomRadius);
    CGPoint p3 = CGPointMake(CGRectGetWidth(layer.frame) - x, CGRectGetHeight(layer.frame) - currentBottomRadius);
    CGPoint p4 = CGPointMake(x, CGRectGetHeight(layer.frame) - currentBottomRadius);

    // Right curve
    //    CGPathAddLineToPoint(raindropPath, NULL, p3.x, p3.y);
    CGPoint cp = CGPointMake(p3.x, p1.y + 0.5 * (p3.y - p1.y));
    CGPathAddQuadCurveToPoint(raindropPath, NULL, cp.x, cp.y, p3.x, p3.y);

    // Append bottom arc
    arcCenter.y = p4.y;
    CGPathAddArc(raindropPath, NULL, arcCenter.x, arcCenter.y, currentBottomRadius, 0, M_PI, NO);
    //    CGPathAddLineToPoint(raindropPath, NULL, p4.x, p4.y);

    // Left curve
    //    CGPathCloseSubpath(raindropPath);
    cp.x = p4.x;
    CGPathAddQuadCurveToPoint(raindropPath, NULL, cp.x, cp.y, p1.x, p1.y);

    //    CGPathAddRect(raindropPath, NULL, CGRectMake(0, 0, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame)));

    CGContextSetFillColorWithColor(ctx, [UIColor brownColor].CGColor);
    CGContextAddPath(ctx, raindropPath);
    CGContextFillPath(ctx);

    CGPathRelease(raindropPath);
}

@end


@interface DMLRaindropArrowLayerContentProvider : NSObject <CALayerDelegate>

@property (nonatomic, weak) DMLRaindropView *raindropView;

@end


@implementation DMLRaindropArrowLayerContentProvider

- (instancetype)initWithRaindropView:(DMLRaindropView *)view
{
    if (self = [super init]) {
        _raindropView = view;
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGFloat percentage = (CGRectGetHeight(layer.frame) - sRaindropViewWidth) / (MJRefreshHeaderHeight - sRaindropViewWidth);
    CGFloat currentArrowSize = lerp(sRaindropMaxArrowSize, sRaindropMinArrowSize, percentage);
    CGFloat currentArrowRadius = lerp(sRaindropMaxArrowRadius, sRaindropMinArrowRadius, percentage);
    CGFloat arrowBigRadius = currentArrowRadius + (currentArrowSize / 2);
    CGFloat arrowSmallRadius = currentArrowRadius - (currentArrowSize / 2);

    //    CGPoint topOrigin = CGPointMake(0.5 * sRaindropViewWidth, 0.5 * sRaindropViewWidth);
    CGPoint topOrigin = CGPointMake(0.5 * CGRectGetWidth(layer.frame), 0.5 * sRaindropViewWidth);

    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowBigRadius, 0, 3 * M_PI_2, NO);
    CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius - currentArrowSize);
    CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x + (2 * currentArrowSize), topOrigin.y - arrowBigRadius + (currentArrowSize / 2));
    CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + (2 * currentArrowSize));
    CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + currentArrowSize);
    CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowSmallRadius, 3 * M_PI_2, 0, YES);
    CGPathCloseSubpath(arrowPath);

    CGContextAddPath(ctx, arrowPath);
    //    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //    CGContextStrokePath(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);

    CGPathRelease(arrowPath);
}

@end

typedef NS_ENUM(NSUInteger, DMLRaindropScene) {
    DMLRaindropSceneSnivel,
    DMLRaindropSceneActivity
};


@interface DMLRaindropView : UIView

@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) CAShapeLayer *arrowLayer;

@property (nonatomic) DMLRaindropShapeLayerContentProvider *shapeLayerContentProvider;
@property (nonatomic) DMLRaindropArrowLayerContentProvider *arrowLayerContentProvider;

@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic) DMLRaindropScene scene;

- (void)transitionToScene:(DMLRaindropScene)scene;

@end


@implementation DMLRaindropView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];

        _shapeLayer = [CAShapeLayer layer];
        //        _shapeLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_shapeLayer];

        _arrowLayer = [CAShapeLayer layer];
        //        _arrowLayer.backgroundColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:_arrowLayer];

        _shapeLayerContentProvider = [[DMLRaindropShapeLayerContentProvider alloc] initWithRaindropView:self];
        _shapeLayer.delegate = _shapeLayerContentProvider;

        _arrowLayerContentProvider = [[DMLRaindropArrowLayerContentProvider alloc] initWithRaindropView:self];
        _arrowLayer.delegate = _arrowLayerContentProvider;

        _scene = DMLRaindropSceneSnivel;
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = CGRectInset(self.frame, 2, 2);
    frame.origin = CGPointMake(2, 2);
    self.shapeLayer.frame = frame;
    [self.shapeLayer setNeedsDisplay];

    frame.size.height = frame.size.width;
    self.arrowLayer.frame = frame;
    [self.arrowLayer setNeedsDisplay];
}

- (void)transitionToScene:(DMLRaindropScene)scene
{
    if (self.scene != scene) {
        self.scene = scene;
        switch (scene) {
            case DMLRaindropSceneSnivel: {
                self.activityIndicatorView.hidden = YES;
                if (self.activityIndicatorView.isAnimating) {
                    [self.activityIndicatorView stopAnimating];
                }

                self.shapeLayer.hidden = NO;
                self.arrowLayer.hidden = NO;

                break;
            }
            case DMLRaindropSceneActivity: {
                if (!self.activityIndicatorView.superview) {
                    [self addSubview:self.activityIndicatorView];

                    // Configure constraints
                    if (@available(iOS 11.0, *)) {
                        [self.activityIndicatorView.centerXAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerXAnchor].active = YES;
                        [self.activityIndicatorView.widthAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.widthAnchor].active = YES;

                        [self.activityIndicatorView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
                        [self.activityIndicatorView.heightAnchor constraintEqualToAnchor:self.activityIndicatorView.widthAnchor].active = YES;
                    }

                    self.activityIndicatorView.hidden = NO;
                }

                if (!self.activityIndicatorView.isAnimating) {
                    [self.activityIndicatorView startAnimating];
                }

                self.shapeLayer.hidden = YES;
                self.arrowLayer.hidden = YES;

                break;
            }
        }
    }
}

#pragma mark - Getter

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _activityIndicatorView;
}

@end


@interface MJRefreshHeader ()

@property (assign, nonatomic) CGFloat insetTDelta;

@end


@interface DMLRaindropHeaderRefreshControl ()
{
    MJRefreshState _state;
}

@property (nonatomic) DMLRaindropView *raindropView;
@property (nonatomic) NSLayoutConstraint *heightConstraintOfRaindropView;
@property (nonatomic) NSLayoutConstraint *topConstraintOfRaindropView;

@end


@implementation DMLRaindropHeaderRefreshControl

#pragma mark - Override

- (void)prepare
{
    [super prepare];

    self.backgroundColor = [UIColor purpleColor];

    //    self.mj_h = 2 * MJRefreshHeaderHeight;

    if (!self.raindropView.superview) {
        [self insertSubview:self.raindropView atIndex:0];

        // Configure constraints
        CGFloat topMargin = self.mj_h - sRaindropViewWidth;
        if (@available(iOS 11.0, *)) {
            [self.raindropView.centerXAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerXAnchor].active = YES;
            [self.raindropView.widthAnchor constraintEqualToConstant:sRaindropViewWidth].active = YES;

            //            [self.raindropView.centerYAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerYAnchor].active = YES;
            self.topConstraintOfRaindropView = [self.raindropView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:topMargin];
            self.topConstraintOfRaindropView.active = YES;

            self.heightConstraintOfRaindropView = [self.raindropView.heightAnchor constraintEqualToConstant:sRaindropViewWidth];
            self.heightConstraintOfRaindropView.active = YES;
        } else {
            [NSLayoutConstraint constraintWithItem:self.raindropView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:self.raindropView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sRaindropViewWidth].active = YES;

            //            [NSLayoutConstraint constraintWithItem:self.raindropView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0].active = YES;
            self.topConstraintOfRaindropView = [NSLayoutConstraint constraintWithItem:self.raindropView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:topMargin];
            self.topConstraintOfRaindropView.active = YES;

            self.heightConstraintOfRaindropView = [NSLayoutConstraint constraintWithItem:self.raindropView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sRaindropViewWidth];
            self.heightConstraintOfRaindropView.active = YES;
        }
    }
}

//- (void)placeSubviews
//{
//    [super placeSubviews];
//}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;

        // sectionheader停留解决
        CGFloat insetT = -self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? -self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;

        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }

    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.mj_inset;

    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    //    NSLog(@"offsetY:%.2f\n", offsetY);

    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;

    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;

    // Adjust top margin and height of raindrop if neccesary
    BOOL needUpdateHeight = NO;
    BOOL needUpdateTopConstraint = NO;

    CGFloat raindropVisibleOffsetY = happenOffsetY - sRaindropViewWidth;
    CGFloat baselineTopMargin = self.mj_h - sRaindropViewWidth;
    CGFloat newTopMargin = baselineTopMargin;
    CGFloat h = sRaindropViewWidth;

    if (offsetY < raindropVisibleOffsetY) {
        needUpdateHeight = YES;

        needUpdateTopConstraint = YES;
        CGFloat verticalOffset = raindropVisibleOffsetY - offsetY;

        newTopMargin = baselineTopMargin - verticalOffset;
        newTopMargin = MAX(0, newTopMargin);

        h = self.mj_h - newTopMargin;
    } else {
        if (self.heightConstraintOfRaindropView.constant > sRaindropViewWidth) {
            needUpdateHeight = YES;
        }

        if (self.topConstraintOfRaindropView.constant < baselineTopMargin) {
            needUpdateTopConstraint = YES;
            newTopMargin = baselineTopMargin;
        }
    }
    //    NSLog(@"newTopMargin:%.2f\n", newTopMargin);
    //    if (needUpdateHeight) {
    //        // Limit pullingPercent to [0, 1]
    //        pullingPercent = MAX(0, pullingPercent);
    //        pullingPercent = MIN(pullingPercent, 1);
    //
    //        // Update height of raindrop
    //        h = lerp(sRaindropViewWidth, self.mj_h, pullingPercent);
    //    }

    if (needUpdateHeight || needUpdateTopConstraint) {
        self.heightConstraintOfRaindropView.constant = h;

        self.topConstraintOfRaindropView.constant = newTopMargin;

        [self setNeedsUpdateConstraints];
    }

    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        } else if (self.state == MJRefreshStatePulling && offsetY < (normal2pullingOffsetY - self.mj_h)) {
            // Transition raindrop's UI
            [self.raindropView transitionToScene:DMLRaindropSceneActivity];

            [self beginRefreshing];
        }
    } else {
        if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent;
        }

        if (self.state == MJRefreshStateIdle) {
            // End refresh before scroll view content offset reset
            // Switch raindrop from snivel to activity if nessary

            [self.raindropView transitionToScene:DMLRaindropSceneSnivel];
        }
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshState oldState = _state;
    if (state == oldState) {
        return;
    }

    // Update state
    _state = state;

    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing) return;

        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // 恢复inset和offset
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetT += self.insetTDelta;

            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;

            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
    } else if (state == MJRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    }
}

- (void)endRefreshing
{
    [super endRefreshing];

    // Switch raindrop from activity to snivel if nessary
    [self.raindropView transitionToScene:DMLRaindropSceneSnivel];
}

#pragma mark - Getter

- (MJRefreshState)state
{
    return _state;
}

- (DMLRaindropView *)raindropView
{
    if (!_raindropView) {
        _raindropView = [[DMLRaindropView alloc] initWithFrame:CGRectZero];
        _raindropView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _raindropView;
}

@end
