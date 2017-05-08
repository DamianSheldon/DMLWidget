//
//  DMLViewController.m
//  DMLSegmentedControl
//
//  Created by Meiliang Dong on 05/12/2016.
//  Copyright (c) 2016 Meiliang Dong. All rights reserved.
//

#import <DMLWidget/DMLSegmentedControl.h>

#import "DMLViewController.h"

@interface DMLViewController ()

@property (nonatomic) DMLSegmentedControl *segmentedControl;

@end

@implementation DMLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentedControl];
    
    [self configureConstraintsForSegmentedControl];
}

#pragma mark - Layout

- (void)configureConstraintsForSegmentedControl
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
}

#pragma mark - Action

- (void)segmentedContolValueChanged
{
    NSLog(@"%s", __func__);
}

#pragma mark - Getter

- (DMLSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[DMLSegmentedControl alloc] initWithItems:@[@"8元", @"12元", @"16元"]];
        [_segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_segmentedControl addTarget:self action:@selector(segmentedContolValueChanged) forControlEvents:UIControlEventValueChanged];
        
        _segmentedControl.tintColor = [UIColor colorWithRed:0.3 green:0.68 blue:0.98 alpha:1.0];
    }
    return _segmentedControl;
}

@end
