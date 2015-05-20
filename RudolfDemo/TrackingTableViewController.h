//
//  TrackingTableViewController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/6.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *trackingTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
