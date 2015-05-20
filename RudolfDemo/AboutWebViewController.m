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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"即將開啟瀏覽器" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}
- (IBAction)callUsButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"撥打電話給Rudolf" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    //call james
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        
    }else{
        if ([alertView.title isEqualToString:@"即將開啟瀏覽器"]) {
            BOOL open = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://therudolf.weebly.com"]];
        }else if([alertView.title isEqualToString:@"撥打電話給Rudolf"]){
            BOOL call = [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:@"tel://0989586794"]];
        }
        
    }
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
