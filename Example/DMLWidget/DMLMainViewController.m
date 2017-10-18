//
//  DMLMainViewController.m
//  DMLWidget
//
//  Created by Meiliang Dong on 18/10/2017.
//  Copyright © 2017 DamianSheldon. All rights reserved.
//

#import "DMLMainViewController.h"
#import "DMLSegmentedControlViewController.h"

static NSString * const sCellId = @"Cell";

typedef NS_ENUM(NSInteger, DMLWidgetElement) {
    DMLWidgetElementCamPreview = 0,
    DMLWidgetElementCollectionHeaderView,
    DMLWidgetElementCollectionCell,
    DMLWidgetElementSegmentedControl,
    DMLWidgetElementSlider
};

@interface DMLMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSDictionary *elementNames;
@property (nonatomic) NSDictionary *elementMappingExamples;

@end

@implementation DMLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DMLWidget";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self configureConstraintsForTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DMLWidgetElementSlider + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellId forIndexPath:indexPath];
    
    NSString *elementName = self.elementNames[@(indexPath.row)];
    cell.textLabel.text = elementName;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class clz = self.elementMappingExamples[@(indexPath.row)];
    if (clz) {
        UIViewController *vc = [clz new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Private Method

- (void)configureConstraintsForTableView
{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCellId];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSDictionary *)elementNames
{
    if (!_elementNames) {
        _elementNames = @{
                          @(DMLWidgetElementCamPreview): @"CamPreview",
                          @(DMLWidgetElementCollectionHeaderView): @"CollectionHeaderView",
                          @(DMLWidgetElementCollectionCell): @"CollectionCell",
                          @(DMLWidgetElementSegmentedControl): @"SegmentedControl",
                          @(DMLWidgetElementSlider): @"Slider"
                          };
    }
    return _elementNames;
}

- (NSDictionary *)elementMappingExamples
{
    if (!_elementMappingExamples) {
        _elementMappingExamples = @{
                                    @(DMLWidgetElementSegmentedControl): [DMLSegmentedControlViewController class]
                                    };
    }
    return _elementMappingExamples;
}

@end
