//
//  IncidentDetailViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IncidentDetailViewController : UIViewController {
	IBOutlet UITextField *dateTextField;
	IBOutlet UITextView *reasonTextView;
	IBOutlet UIButton *plusButton;
	IBOutlet UIButton *minusButton;
	IBOutlet UIButton *endButton;
	NSMutableDictionary *incident;
}

@property (nonatomic, retain) IBOutlet UITextField *dateTextField;
@property (nonatomic, retain) IBOutlet UITextView *reasonTextView;
@property (nonatomic, retain) IBOutlet UIButton *plusButton;
@property (nonatomic, retain) IBOutlet UIButton *minusButton;
@property (nonatomic, retain) IBOutlet UIButton *endButton;
@property (nonatomic, retain) NSMutableDictionary *incident;

- (IBAction) minusButtonPressed: (id)sender;
- (IBAction) plusButtonPressed: (id)sender;
- (IBAction) endButtonPressed: (id)sender;

@end
