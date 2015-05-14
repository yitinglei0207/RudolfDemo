//
//  PickDestinationViewController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickDestinationViewController : UIViewController<UIPickerViewDelegate , UIPickerViewDataSource>
//@property (weak, nonatomic) IBOutlet UIPickerView *destinationPick;
@property (weak, nonatomic) IBOutlet UILabel *pickUpFrom;

@property (nonatomic,strong) NSString *receivedSelectionText;
@end
