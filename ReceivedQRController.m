//
//  ReceivedQRController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/11.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "ReceivedQRController.h"
#import "TrackingTableViewController.h"

@interface ReceivedQRController ()
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ReceivedQRController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isReading = NO;
    _captureSession = nil;
    [self startReading];
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


- (IBAction)startStopScanning:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_startScan setTitle:@"Stop" forState:UIControlStateNormal];
            [_lblStatus setText:@"Scanning"];
        }
    }
    else{
        [self stopReading];
        [_startScan setTitle:@"Start!"forState:UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}

-(BOOL)startReading{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewCode.layer.bounds];
    [_previewCode.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    
    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_startScan performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
            
            PFQuery *query = [PFQuery queryWithClassName:@"Delivery"];
            
            // Retrieve the object by id
            [query getObjectInBackgroundWithId:self.deliveryToBeUpdate.objectId
                                         block:^(PFObject *delivery, NSError *error) {
                                             
                                             if (!error) {
                                                 delivery[@"QRcodeSerial"] = _lblStatus.text;
                                                 delivery[@"status"] = @"received";
                                                 [delivery saveInBackground];
                                                 //========show Alert===========
                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"狀態已更新" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                                 [alert show];
                                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                             } else {
                                                 NSLog(@"There was a problem, check error.description");
                                             }
                                             
                                         }];
            
            
            
        }
    }
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
