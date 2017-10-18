//
//  DMLSegmentedControl.m
//  Pods
//
//  Created by DongMeiliang on 5/12/16.
//
//

#import "DMLSegmentedControl.h"

@interface UIColor (DMLSegmentedControlPrivate)

/**
    -1.0f <= correctionFactor <= 1.0f
    factor < 0, dark
    factor > 0, light
 */
- (UIColor *)dml_correctionColorWithFactor:(float)factor;

@end

@implementation UIColor (DMLSegmentedControlPrivate)

- (UIColor *)dml_correctionColorWithFactor:(float)factor
{
    CGFloat red, green, blue, alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (factor < 0) {
        factor = 1 + factor;
        
        red *= factor;
        green *= factor;
        blue *= factor;
    }
    else {
        red = (1 - red) * factor + red;
        green = (1 - green) * factor + green;
        blue = (1 - blue) * factor + blue;
    }
    
    // Restrict color compoent to [0, 1]
    red = MAX(0, red);
    red = MIN(1, red);
    
    green = MAX(0, green);
    green = MIN(1, green);
    
    blue = MAX(0, blue);
    blue = MIN(1, blue);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

static CGFloat const sIntrinsicContentSizeHeight = 40.0f;
static CGFloat const sHairLineWidthFactor = 0.8;
static CGFloat const sHairLineHeightFactor = 0.06;
static CGFloat const sHalfFactor = 0.5;
static float const sColorLightFactor = 0.4;

@interface DMLSegmentedControl ()

@property (nonatomic, copy) NSArray *items;
@property (nonatomic) NSMutableArray *segments;

@property (nonatomic) UIView *hairLine;
@property (nonatomic) UIColor *lightTintColor;

@end

@implementation DMLSegmentedControl

- (instancetype)initWithItems:(NSArray<NSString *> *)items
{
    self = [super init];
    if (self) {
        _items = [items copy];
        
        _hairLine = [UIView new];
        _hairLine.backgroundColor = self.tintColor;
        
        [self addSubview:_hairLine];
        
        _selectedSegmentIndex = 0;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, sIntrinsicContentSizeHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.items > 0 && !self.segments) {
        self.segments = [NSMutableArray new];
        
        for (NSString *item in self.items) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = self.tintColor;
            label.text = item;
            
            [self addSubview:label];
            
            [self.segments addObject:label];
        }
    }
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    if (self.segments.count) {
        frame.size.width /= self.segments.count;
    }
    
    if (!self.lightTintColor) {
        self.lightTintColor = [self.tintColor dml_correctionColorWithFactor:sColorLightFactor];
    }
    
    for (NSUInteger i = 0; i < self.segments.count; ++i) {
        frame.origin.x = i * frame.size.width;
        
        UILabel *label = self.segments[i];
        
        label.frame = frame;
        
        if (i != self.selectedSegmentIndex) {
            label.textColor = self.lightTintColor;
        }
        else {
            label.textColor = self.tintColor;
        }
    }
    
    CGFloat segmentWidth = frame.size.width;
    
    frame.size.width = sHairLineWidthFactor * segmentWidth;
    frame.origin.x = segmentWidth * (self.selectedSegmentIndex + sHalfFactor) - frame.size.width * sHalfFactor;// segmentWidth * i + (segmentWidth / 2 - width / 2)
    
    frame.size.height = sHairLineHeightFactor * CGRectGetHeight(self.frame);
    frame.origin.y = CGRectGetHeight(self.frame) - frame.size.height;
    
    self.hairLine.frame = frame;
    
    self.hairLine.layer.cornerRadius = CGRectGetHeight(self.hairLine.frame) * 0.5;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    self.hairLine.backgroundColor = tintColor;
    
    self.lightTintColor = [tintColor dml_correctionColorWithFactor:sColorLightFactor];
    
    for (NSUInteger i = 0; i < self.segments.count; ++i) {
        UILabel *label = self.segments[i];
        
        if (i != self.selectedSegmentIndex) {
            label.textColor = self.lightTintColor;
        }
        else {
            label.textColor = self.tintColor;
        }
    }
    
}

#pragma mark - Public Methods

- (NSUInteger)numberOfSegments
{
    return self.items.count;
}

#pragma mark - Responding to Touch Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{ }

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{ }

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.segments.count > 0) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        
        for (NSUInteger i = 0; i < self.segments.count; ++i) {
            UILabel *label = self.segments[i];
            
            if (CGRectContainsPoint(label.frame, touchPoint)) {
                if (self.selectedSegmentIndex != i) {
                    NSInteger previousSelectedIndex = self.selectedSegmentIndex;
                    self.selectedSegmentIndex = i;
                    
                    [UIView animateWithDuration:0.4 animations:^{
                        CGRect frame = self.hairLine.frame;
                        
                        CGFloat segmentWidth = CGRectGetWidth(self.frame) / self.segments.count;
                        
                        frame.origin.x = segmentWidth * (i + sHalfFactor) - frame.size.width * sHalfFactor;
                        
                        self.hairLine.frame = frame;
                        
                        UILabel *label = self.segments[previousSelectedIndex];
                        label.textColor = self.lightTintColor;
                        
                        label = self.segments[i];
                        label.textColor = self.tintColor;
                    }];
                    
                    // Notify our target (if we have one) of the change.
                    [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
                }
                break;
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{ }

#pragma mark - Private Methods

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent*)event
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

@end
