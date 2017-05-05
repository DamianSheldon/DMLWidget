//
//  DMLSegmentedControl.h
//  Pods
//
//  Created by DongMeiliang on 5/12/16.
//
//

#import <UIKit/UIKit.h>

@interface DMLSegmentedControl : UIControl

@property(nonatomic, readonly) NSUInteger numberOfSegments;
@property(nonatomic) NSInteger selectedSegmentIndex;

- (instancetype)initWithItems:(NSArray<NSString *> *)items;

@end
