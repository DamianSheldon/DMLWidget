//
//  DMLImageHeaderRefreshControlViewController.h
//  DMLWidget_Example
//
//  Created by Meiliang Dong on 2018/5/8.
//  Copyright © 2018 DamianSheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefreshHeader.h>


@interface DMLHeaderRefreshControlViewController : UITableViewController

@property (nonatomic) MJRefreshHeader *refreshHeader;

- (void)loadNewData;

@end
