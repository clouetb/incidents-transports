//
//  LightViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "LightViewController.h"


@implementation LightViewController

@synthesize text, actionButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Lumière";
	NSString *IOSVersionString = [[UIDevice currentDevice] systemVersion];
	float IOSVersion = [IOSVersionString floatValue];
	BOOL IOS4OrMoreVersion = IOSVersion >= 4.0;
	if (IOS4OrMoreVersion) {
		
#if TARGET_IPHONE_SIMULATOR
		LogDebug(@"In simulator");
		actionButton.enabled = NO;
		text.text = @"Cet écran vous permet de vous éclairer dans le noir.";
#else
		LogDebug(@"In device");
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		// If torch not supported, disable button and print a specific text
		if ([device hasTorch] == NO) {
			actionButton.enabled = NO;
			text.text = @"Cet écran vous permet de vous éclairer dans le noir.";
		}
#endif
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[text release];
}

- (IBAction) actionButtonPressed: (id)sender{
// Not to be fired if targetting the simulator
#if TARGET_IPHONE_SIMULATOR
	LogDebug(@"In simulator");
#else
	LogDebug(@"In device");
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (device.torchMode == AVCaptureTorchModeOff) {
		// Create an AV session
		AVCaptureSession *AVSession = [[AVCaptureSession alloc] init];
		
		// Create device input and add to current session
		AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
		[AVSession addInput:input];
		
		// Create video output and add to current session
		AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
		[AVSession addOutput:output];
		
		// Start session configuration
		[AVSession beginConfiguration];
		[device lockForConfiguration:nil];
		
		// Set torch to on
		[device setTorchMode:AVCaptureTorchModeOn];
		
		[device unlockForConfiguration];
		[AVSession commitConfiguration];
		
		// Start the session
		[AVSession startRunning];
		
		// Keep the session around
		session = AVSession;
		
		[output release];
	}
	else
	{
		[session stopRunning];
		[session release];
		session = nil;

	}
#endif
}

@end
