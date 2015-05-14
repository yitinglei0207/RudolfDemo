//
//  ViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/4/24.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK.h>
#import "LoginViewController.h"
#import <UIKit/UIKit.h>

@interface LoginViewController ()
{
    UIImageView *indicatorBackground;
}
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)activityIndicatorSetup{
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.center = self.view.center;
    indicatorBackground = [[UIImageView alloc]init];
    indicatorBackground.backgroundColor = [UIColor darkGrayColor];
    indicatorBackground.alpha = 0.5;
    [indicatorBackground setFrame:CGRectMake(self.view.center.x-25, self.view.center.y-25, 50, 50)];
    indicatorBackground.layer.cornerRadius = 5;
    indicatorBackground.layer.masksToBounds = YES;
    [self.view addSubview:indicatorBackground];
    [self.view addSubview:_indicator];
}

- (IBAction)fbLogin:(id)sender {
    NSArray *permissionArray = @[ @"user_about_me", @"user_birthday",@"email"];
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [self activityIndicatorSetup];
    [_indicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error){
        if(!user){
            //login failed
            NSString *errorMessage = nil;
            if(!error){
                NSLog(@"User cancelled login");
                errorMessage = @"User cancelled login";
            }else{
                NSLog(@"error: %@",error );
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"login error" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"dismiss", nil];
            [alert show];
        }
        else{
            //login success
            if (user.isNew) {
                NSLog(@"user FB signed up and logged in");
                [self saveUserDataToParse];
            }else{
                NSLog(@"logged in!");
                [self saveUserDataToParse];
            }
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            [userInfo setObject:user.email forKey:@"email"];
            //[userInfo setObject:user.name forKey:@"userName"];
            //[userInfo setObject:_passwordText.text forKey:@"password"];
            [userInfo synchronize];
            UIViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWView"];
            [self presentViewController:menuViewController animated:YES completion:nil];
            
        }
        self.view.userInteractionEnabled = YES;
        [_indicator stopAnimating];
        [indicatorBackground removeFromSuperview];
        
    }];
}

-(void) saveUserDataToParse
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            //some people may be make birthday public
            //NSString *birthday = userData[@"birthday"];
            NSString *email =userData[@"email"];
            NSString *pictureURL =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            NSString *gender =userData[@"gender"];
            
            [[PFUser currentUser] setObject:name forKey:@"name"];
            [[PFUser currentUser] setObject:facebookID forKey:@"facebookID"];
            //[[PFUser currentUser] setObject:birthday forKey:@"birthday"];
            [[PFUser currentUser] setObject:email forKey:@"email"];
            [[PFUser currentUser] setObject:pictureURL forKey:@"pictureURL"];
            [[PFUser currentUser] setObject:gender forKey:@"gender"];
            
            [[PFUser currentUser] saveInBackground];
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}


@end
