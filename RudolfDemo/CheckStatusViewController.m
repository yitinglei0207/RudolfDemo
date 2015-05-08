//
//  CheckStatusViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/8.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "CheckStatusViewController.h"

@interface CheckStatusViewController ()

@end

@implementation CheckStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.destinationLabel.text = [self.receivedDic objectForKey:@"Destination"];
    self.createdAtLabel.text = [self.receivedDic objectForKey:@"CreatedAt"];
    self.statusLabel.text = [self.receivedDic objectForKey:@"Status"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
