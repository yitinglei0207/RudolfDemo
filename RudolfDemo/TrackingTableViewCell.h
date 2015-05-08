//
//  TrackingTableViewCell.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/8.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
