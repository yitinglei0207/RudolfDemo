//
//  PickDestinationViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "PickDestinationViewController.h"
#import "ConfirmationViewController.h"
@interface PickDestinationViewController ()
{
    NSArray *destinationsArray;
    NSInteger pickerIndex;
}
@end

@implementation PickDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickUpFrom.text = _receivedSelectionText;
    destinationsArray = @[@"Taipei Main Station",@"SongShan Airport", @"Taoyuan Inti. Airport"];
    
    self.destinationPick.dataSource = self;
    self.destinationPick.delegate = self;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return destinationsArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return destinationsArray[row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneSelectingDestination:(id)sender {
    [self performSegueWithIdentifier:@"toConfrimation" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toConfrimation"]) {
        ConfirmationViewController *destination = segue.destinationViewController;
        destination.receivedDestination = destinationsArray[pickerIndex];
        destination.receivedPickupSpot = _receivedSelectionText;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerIndex = row;
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
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
