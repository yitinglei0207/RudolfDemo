//
//  AboutWebViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/13.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "SWRevealViewController.h"
#import "AboutWebViewController.h"

@interface AboutWebViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation AboutWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"http://therudolf.weebly.com"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_aboutWeb loadRequest:requestObj];
    _aboutWeb.scalesPageToFit = YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moreButton:(id)sender {
    BOOL result = [[UIApplication sharedApplication] openURL:
                   [NSURL URLWithString:@"http://therudolf.weebly.com"]];

}
- (IBAction)callUsButton:(id)sender {
    BOOL result = [[UIApplication sharedApplication] openURL:
                   [NSURL URLWithString:@"tel://0931677890"]];
    //call james
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
