//
//  LightViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"


@interface LightViewController : UIViewController {
	UITextView *text;
	UIButton *actionButton;
#if TARGET_IPHONE_SIMULATOR
#else
	AVCaptureSession *session;
#endif
}

@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, retain) IBOutlet UIButton *actionButton;

- (IBAction) actionButtonPressed: (id)sender;

@end
