//
//  PickDestinationViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickDestinationViewController.h"
#import "ConfirmationViewController.h"
@interface PickDestinationViewController ()
{
    NSArray *pickerArray;
    NSInteger pickerIndex;
    NSInteger originalPickerY;
    UIView *pickerView;
}
@end

@implementation PickDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalPickerY = self.view.frame.size.height;
    _pickUpFrom.text = _receivedSelectionText;
    
    //_destinationText.inputView = [self createPicker];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    // The number of columns of data
}



- (IBAction)doneSelectingDestination:(id)sender {
    [self performSegueWithIdentifier:@"toConfrimation" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toConfrimation"]) {
        ConfirmationViewController *destination = segue.destinationViewController;
        destination.receivedDestination = _destinationText.text;
        destination.receivedPickupSpot = _receivedSelectionText;
    }
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
    // The number of rows of data
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerIndex = row;
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
}


- (UIView*)createPicker{
    pickerArray = @[@"Airport",@"Hotel", @"Home"];
    
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    pickerView.backgroundColor = [UIColor colorWithRed:109.0/255.0 green:110.0/255.0 blue:120.0/255.0 alpha:1];
    
    //---------------set select button on top right-------------
    UIButton *selectPickButton = [UIButton buttonWithType:UIButtonTypeSystem ];
    [selectPickButton setTitle:@"Select" forState:UIControlStateNormal];
    selectPickButton.frame = CGRectMake(self.view.frame.size.width-100, 0, 90, 45);
    selectPickButton.titleLabel.textColor = [UIColor whiteColor];
    [selectPickButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //----------------------------------------------------------
    UIPickerView *destinationPick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 120)];
    destinationPick.delegate = self;
    [pickerView addSubview:destinationPick];
    [pickerView addSubview:selectPickButton];
    destinationPick.dataSource = self;
    return pickerView;
}

- (void)viewUp:(UIView*)view{
    //客製化用
    if (view.frame.origin.y == originalPickerY) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        CGRect frame = view.frame;
        frame.origin.y -= 210;
        view.frame = frame;
        [UIView commitAnimations];
    } else  {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        CGRect frame = view.frame;
        frame.origin.y += 210;
        view.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)selectButtonPressed:(UIButton *)button {
    NSLog(@"Button Pressed");
    _destinationText.text = pickerArray[pickerIndex];
    [_destinationText resignFirstResponder];
}

-(void)dismissKeyboard {
    [_destinationText resignFirstResponder];
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
