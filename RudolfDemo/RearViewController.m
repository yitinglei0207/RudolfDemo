

#import "RearViewController.h"

#import "TrackingTableViewController.h"
#import "PickDestinationViewController.h"
#import "TrackTableViewController.h"
#import "MapViewController.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return 4;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    NSInteger row = indexPath.row;
//    
//    if (nil == cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//    }
//    
//    
//    
//    return cell;
//}

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
    else if (row == 2)
    {
        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        return;
    }
    else if (row == 3)
    {
        [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
        return;
    }
    
    // otherwise we'll create a new frontViewController and push it with animation
    
//    UIViewController *newFrontController = nil;
//    
//    if (row == 0)
//    {
//        newFrontController = [[MapViewController alloc] init];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
//        [revealController pushFrontViewController:navigationController animated:YES];
//    }
//    
//    else if (row == 1)
//    {
//        //newFrontController = [[TrackingTableViewController alloc] init];
//        
//        TrackingTableViewController *trackingTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackingTableViewController"];
//        [self presentViewController:trackingTableViewController animated:YES completion:nil];
//        
//    }
//    UIViewController *newFrontController = nil;
//    
//    if (row == 0)
//    {
//        newFrontController = [[MapViewController alloc] init];
//    }
//    
//    else if (row == 1)
//    {
//        newFrontController = [[TrackingTableViewController alloc] init];
//    }
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
//    [revealController pushFrontViewController:navigationController animated:YES];
    
    
    
    _presentedRow = row;  // <- store the presented row
}



//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}

@end