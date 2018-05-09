//
//  DMLImageHeaderRefreshControlViewController.m
//  DMLWidget_Example
//
//  Created by Meiliang Dong on 2018/5/8.
//  Copyright © 2018 DamianSheldon. All rights reserved.
//

#import "DMLHeaderRefreshControlViewController.h"


@interface DMLHeaderRefreshControlViewController ()

@property (nonatomic) NSMutableArray *data;

@end


@implementation DMLHeaderRefreshControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 44.0;

    //    DMLImageHeaderRefreshControl *imageHeaderRefreshControl = [DMLImageHeaderRefreshControl headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //    imageHeaderRefreshControl.imageView.backgroundColor = [UIColor purpleColor];
    //    self.tableView.mj_header = imageHeaderRefreshControl;

    self.tableView.mj_header = self.refreshHeader;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    cell.textLabel.text = self.data[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Private

- (NSString *)partialRandomString
{
    return [NSString stringWithFormat:@"random string---%d", arc4random_uniform(1000000)];
}

#pragma mark - Public

- (void)loadNewData
{
    NSInteger count = 5 + arc4random_uniform(5);
    for (NSInteger i = 0; i < count; i++) {
        [self.data insertObject:[self partialRandomString] atIndex:0];
    }

    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - Getter

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [NSMutableArray arrayWithCapacity:0];

        // Prepopulate one screen data
        NSInteger count = (NSInteger)ceil(CGRectGetHeight(self.view.frame) / self.tableView.rowHeight);
        for (NSInteger i = 0; i < count; i++) {
            [_data addObject:[self partialRandomString]];
        }
    }
    return _data;
}

@end
