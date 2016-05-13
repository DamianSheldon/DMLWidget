//
//  DMLSegmentedControl.h
//  Pods
//
//  Created by DongMeiliang on 5/12/16.
//
//

#import <UIKit/UIKit.h>

@interface DMLSegmentedControl : UIControl

- (instancetype)initWithItems:(NSArray<NSString *> *)items;

@property (nonatomic) float pointRadius;// Default is 6.0f
@property (nonatomic) float lineHeight;// Default is 6.0f
@property (nonatomic) float minumSpaceBetweenPoints;// Default is 60.0f;

@property (nonatomic) float thumbRadius;// Default is 18.0f, if items is 0 less than 0.125 * screenWidth, else less than 0.25 * (screenWidth / items.count)

@property (nonatomic) UIColor *fluteColor;

@property (nonatomic, readonly, copy) NSArray *segmentedItems;

@property(nonatomic) NSInteger selectedSegmentIndex;// Set this property to -1 to turn off the current selection.

@end
