//
//  ConfirmationViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "SWRevealViewController.h"
#import "AirportConfirmController.h"
#import <Parse/Parse.h>

@interface AirportConfirmController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *indicatorBackground;
    
    NSArray *pickerArray;
    NSInteger pickerIndex;
    UIPickerView *pickerView;
    
    NSArray *pickerTerminal;
    
}
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

@implementation AirportConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerArray = @[@"松山機場",@"桃園國際機場"];
    pickerTerminal = @[@"第一航廈",@"第二航廈"];
    // Do any additional setup after loading the view.
    self.fromPickupLabel.text = self.receivedPickupSpot;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.estimationTime.text = [dateFormatter stringFromDate:_boardingTime.date];
    
    _airportName.text = pickerArray[0];
    _terminal.text = pickerTerminal[0];
    
    self.airportName.inputView = [self createPicker:pickerArray];
    self.terminal.inputView = [self createPicker:pickerTerminal];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //set gesture for dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
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


- (IBAction)confirmButtonPressed:(id)sender {
    NSNumber *serialNumber = [[NSNumber alloc]initWithInt:arc4random()%100000000];
    NSLog(@"%@",serialNumber);
    
    //set indicator
    [self activityIndicatorSetup];
    [_indicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    PFObject *delivery = [PFObject objectWithClassName:@"Delivery"];
    delivery[@"PickupSpot"]  = _fromPickupLabel.text;
    delivery[@"Destination"] = _airportName.text;
    delivery[@"AdditionalInfo"] = _terminal.text;
    delivery[@"status"] = @"pending";
    delivery[@"BoardingORHotelTime"] = _boardingTime.date;
    delivery[@"Username"] = [[PFUser currentUser] objectForKey:@"name"];
    delivery[@"Email"] = [[PFUser currentUser] objectForKey:@"email"];
    delivery[@"SerialNumber"] = serialNumber;
    //delivery[@"toPhoneNumber"] = _phoneLabel.text;
    [delivery saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"訂單已送出" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];
}
//- (IBAction)confirmButton:(id)sender {
//
//
//}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissKeyboard {
    [_airportName resignFirstResponder];
    [_terminal resignFirstResponder];
}



#pragma mark - Picker setup

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
    // The number of rows of data
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_airportName.editing == YES) {
        return pickerArray[row];
    }else{
        return pickerTerminal[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerIndex = row;
    if (_airportName.editing == YES) {
        _airportName.text = pickerArray[row];
    }else{
        _terminal.text = pickerTerminal[row];
    }
    
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
}


- (UIPickerView*)createPicker:(NSArray*)array{
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 120)];
    
    pickerView.showsSelectionIndicator = YES;
    
    
    //---------------set select button on top right-------------
    //    UIButton *selectPickButton = [UIButton buttonWithType:UIButtonTypeSystem ];
    //    [selectPickButton setTitle:@"Select" forState:UIControlStateNormal];
    //    selectPickButton.frame = CGRectMake(self.view.frame.size.width-100, 0, 90, 45);
    //    selectPickButton.titleLabel.textColor = [UIColor whiteColor];
    //    [selectPickButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [pickerView addSubview:selectPickButton];
    //_airportName.text = array[0];
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    return pickerView;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
@end
