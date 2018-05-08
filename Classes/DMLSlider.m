//
//  DMLSlider.m
//  Pods
//
//  Created by DongMeiliang on 05/05/2017.
//
//

#import "DMLSlider.h"


@interface DMLThumbView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) float ringThickness;
@end


@implementation DMLThumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];

        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

        _ringThickness = 2.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Draw background circle
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:rect];

    [[UIColor whiteColor] setFill];

    [circlePath fill];

    // Draw ring
    CGRect r = CGRectInset(rect, 1, 1);
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = 0.5 * CGRectGetWidth(r) - self.ringThickness;

    UIBezierPath *ringPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];

    ringPath.lineWidth = self.ringThickness;
    [[self dml_blueColor] setStroke];
    [ringPath stroke];
}

#pragma mark - Private

- (UIColor *)dml_blueColor
{
    return [UIColor colorWithRed:33.0 / 255.0 green:169.0 / 255.0 blue:174.0 / 255.0 alpha:1.0];
}

@end

static CGFloat const sIntrinsicContentSizeHeight = 50.0f;


@interface DMLSlider ()

@property (nonatomic, copy) NSArray *segmentedItems;

@property (nonatomic) DMLThumbView *thumbView;

@property (nonatomic) NSLayoutConstraint *thumbViewXConstraint;
@property (nonatomic) NSLayoutConstraint *thumbViewWidthConstraint;
@property (nonatomic) NSLayoutConstraint *thumbViewHeightConstraint;

@property (nonatomic) NSMutableArray *positionRects;

@end


@implementation DMLSlider

- (instancetype)initWithItems:(NSArray<NSString *> *)items
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _segmentedItems = [items copy];

        _pointRadius = 6.0f;
        _lineHeight = 6.0f;
        _minumSpaceBetweenPoints = 100.0f;

        _thumbRadius = 18.0f;

        _fluteColor = [UIColor lightGrayColor];

        _selectedSegmentIndex = -1;

        _thumbView = [DMLThumbView new];
        if (_segmentedItems.count > 0) {
            _thumbView.titleLabel.text = _segmentedItems[0];
        }
        [self addSubview:_thumbView];

        [_thumbView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _thumbViewXConstraint = [NSLayoutConstraint constraintWithItem:_thumbView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraint:_thumbViewXConstraint];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_thumbView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

        _thumbViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_thumbView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_thumbRadius * 2];
        [self addConstraint:_thumbViewWidthConstraint];

        _thumbViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_thumbView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_thumbRadius * 2];
        [self addConstraint:_thumbViewHeightConstraint];

        _positionRects = [NSMutableArray arrayWithCapacity:6];

        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipeGesture];

        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipeGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithItems:nil];
    self.frame = frame;

    return self;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeMake(self.minumSpaceBetweenPoints, sIntrinsicContentSizeHeight);

    if (self.segmentedItems.count > 1) {
        size.width = (self.segmentedItems.count - 1) * size.width;
    }

    return size;
}

- (void)drawRect:(CGRect)rect
{
    if (self.segmentedItems.count > 0) {
        CGRect insetRect = CGRectInset(rect, self.thumbRadius, 0);

        // Circle rect
        CGFloat y = 0.5 * (CGRectGetHeight(rect) - 2 * self.pointRadius);
        CGFloat diameter = 2 * self.pointRadius;

        __block CGRect r = CGRectMake(CGRectGetMinX(insetRect), y, diameter, diameter);

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);

        UIBezierPath *outlinePath = [UIBezierPath bezierPath];

        // Line
        [outlinePath moveToPoint:CGPointMake(CGRectGetMinX(insetRect) + self.pointRadius, CGRectGetMidY(insetRect))];
        [outlinePath addLineToPoint:CGPointMake(CGRectGetMaxX(insetRect) - self.pointRadius, CGRectGetMidY(insetRect))];

        [self.fluteColor setStroke];
        outlinePath.lineWidth = self.lineHeight;

        [outlinePath stroke];

        CGContextRestoreGState(context);
        // Point
        __block UIBezierPath *pointPath;

        if (self.positionRects.count > 0) {
            [self.positionRects removeAllObjects];
        }

        __block CGRect positionRect = CGRectMake(0, 0.5 * CGRectGetHeight(rect) - self.thumbRadius, 2 * self.thumbRadius, 2 * self.thumbRadius);

        // First point
        [self.positionRects addObject:[NSValue valueWithCGRect:positionRect]];

        pointPath = [UIBezierPath bezierPathWithOvalInRect:r];
        [self.fluteColor setFill];
        [pointPath fill];

        // Last point
        void (^drawLastCircle)(void) = ^() {
            r.origin.x = CGRectGetMaxX(insetRect) - CGRectGetWidth(r);
            pointPath = [UIBezierPath bezierPathWithOvalInRect:r];

            [self.fluteColor setFill];
            [pointPath fill];

            positionRect.origin.x = CGRectGetMaxX(rect) - CGRectGetWidth(positionRect);
            [self.positionRects addObject:[NSValue valueWithCGRect:positionRect]];
        };

        if (self.segmentedItems.count > 2) {
            //  Points > 2
            CGFloat space = CGRectGetWidth(insetRect) / (self.segmentedItems.count - 1);
            CGFloat pointSpace = CGRectGetWidth(rect) / (self.segmentedItems.count - 1);
            for (NSUInteger i = 1; i < self.segmentedItems.count - 1; i++) {
                r.origin.x = self.thumbRadius + i * space - 0.5 * CGRectGetWidth(r);
                pointPath = [UIBezierPath bezierPathWithOvalInRect:r];

                [self.fluteColor setFill];
                [pointPath fill];

                positionRect.origin.x = i * pointSpace - 0.5 * CGRectGetWidth(positionRect);
                [self.positionRects addObject:[NSValue valueWithCGRect:positionRect]];
            }

            drawLastCircle();
        } else if (self.segmentedItems.count > 1) {
            // Points == 2
            drawLastCircle();
        }
    }
}

- (void)updateConstraints
{
    if (self.selectedSegmentIndex != -1) {
        NSValue *rectValue = self.positionRects[self.selectedSegmentIndex];
        CGRect rect = [rectValue CGRectValue];
        self.thumbViewXConstraint.constant = CGRectGetMinX(rect);
    } else {
        self.thumbViewXConstraint.constant = 0;
    }
    [super updateConstraints];
}

#pragma mark - Private Methods

- (void)updateThumbTitle:(NSString *)title
{
    self.thumbView.titleLabel.text = [title copy];
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    NSSet *allTargets = [self allTargets];

    for (id target in allTargets) {
        NSArray *actionsForTarget = [self actionsForTarget:target forControlEvent:controlEvents];

        // Actions are returned as NSString objects, where each string is the
        // selector for the action.
        for (NSString *action in actionsForTarget) {
            SEL selector = NSSelectorFromString(action);
            [self sendAction:selector to:target forEvent:event];
        }
    }
}

#pragma mark - Action

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)gesture
{
    if (self.enabled) {
        if (self.selectedSegmentIndex >= 1) {
            self.selectedSegmentIndex -= 1;
            // Notify our target (if we have one) of the change.
            [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:nil];
        }
    }
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)gesture
{
    if (self.enabled && self.segmentedItems.count > 0) {
        NSInteger index = self.selectedSegmentIndex;
        NSInteger threshold = self.segmentedItems.count - 1;

        if (!(self.selectedSegmentIndex != -1)) {
            index = self.selectedSegmentIndex + 1; // Increase to 0
        }

        if (index < threshold) {
            self.selectedSegmentIndex = index + 1;
            // Notify our target (if we have one) of the change.
            [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:nil];
        }
    }
}

#pragma mark - Setters

- (void)setPointRadius:(float)pointRadius
{
    if (pointRadius >= self.lineHeight && pointRadius < self.thumbRadius) {
        _pointRadius = pointRadius;
        [self setNeedsDisplay];
    }
}

- (void)setLineHeight:(float)lineHeight
{
    if (lineHeight > 0 && lineHeight <= self.pointRadius) {
        _lineHeight = lineHeight;
        [self setNeedsDisplay];
    }
}

- (void)setMinumSpaceBetweenPoints:(float)minumSpaceBetweenPoints
{
    CGRect fullScreenRect = [UIScreen mainScreen].bounds;
    CGFloat threshold = CGRectGetWidth(fullScreenRect);
    threshold = 0.125 * threshold;
    if (self.segmentedItems.count > 0) {
        threshold = 0.25 * CGRectGetWidth(fullScreenRect) / self.segmentedItems.count;
    }

    if (minumSpaceBetweenPoints > 2 * self.thumbRadius && minumSpaceBetweenPoints < threshold) {
        _minumSpaceBetweenPoints = minumSpaceBetweenPoints;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setThumbRadius:(float)thumbRadius
{
    if (thumbRadius < 0.5 * self.minumSpaceBetweenPoints) {
        _thumbRadius = thumbRadius;
        [self setNeedsLayout];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (selectedSegmentIndex < self.segmentedItems.count) {
        _selectedSegmentIndex = selectedSegmentIndex;

        // Update thumb title
        NSString *title = self.segmentedItems[_selectedSegmentIndex];
        [self updateThumbTitle:title];

        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - Responding to Touch Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.segmentedItems.count > 0) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];

        for (NSUInteger i = 0; i < self.positionRects.count; i++) {
            NSValue *rectValue = self.positionRects[i];
            CGRect rect = [rectValue CGRectValue];

            if (CGRectContainsPoint(rect, touchPoint)) {
                if (self.selectedSegmentIndex != i) {
                    self.selectedSegmentIndex = i;

                    // Notify our target (if we have one) of the change.
                    [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
                }
                break;
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
