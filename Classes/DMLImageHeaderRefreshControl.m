//
//  DMLImageHeaderRefreshControl.m
//  DMLWidget
//
//  Created by Meiliang Dong on 2018/5/8.
//

#import "DMLImageHeaderRefreshControl.h"

/*
    Declare all MJRefreshComponent methods that need override in subclass.
    In fact, I think this should be done in MJRefresh.
 */
@interface MJRefreshComponent (DMLImageHeaderRefreshControl)

- (void)prepare;

- (void)placeSubviews;

@end


@interface DMLImageHeaderRefreshControl ()
{
    UIImageView *_imageView;
}

@end


@implementation DMLImageHeaderRefreshControl

#pragma mark - Override

- (void)prepare
{
    [super prepare];

    if (!self.imageView.superview) {
        [self insertSubview:self.imageView atIndex:0];

        // Configure constraints
        if (@available(iOS 11.0, *)) {
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor].active = YES;
            [self.imageView.widthAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.widthAnchor].active = YES;

            [self.imageView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
            [self.imageView.heightAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.heightAnchor].active = YES;
        } else {
            [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0].active = YES;

            [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0].active = YES;
        }
    }
}

#pragma mark - Getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:nil];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

@end
