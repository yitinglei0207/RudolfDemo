

#import "RearViewController.h"
#import <Parse/Parse.h>
#import "TrackingTableViewController.h"
#import "PickDestinationViewController.h"
//#import "TrackTableViewController.h"
#import "MapViewController.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    else if (row == 4)
    {
        [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
        [PFUser logOut];
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo removeObjectForKey:@"email"];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"logged out");
        return;
    }
    _presentedRow = row;  // <- store the presented row
}


@end