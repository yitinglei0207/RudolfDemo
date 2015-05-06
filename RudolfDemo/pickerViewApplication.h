//
//  pickerViewApplication.h
//  
//
//  Created by Jason Lei on 2015/5/5.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//


{
    NSArray *pickerArray;
    NSInteger pickerIndex;
    NSInteger originalPickerY;
    UIView *pickerView;
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
    pickerArray = @[@"1",@"2", @"3"];
    
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