//
//  IncidentAddViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IncidentAddViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	NSArray *type;
	NSArray *lines;
	NSString *selectedType;
	NSDictionary *transportData;
	BOOL keyboardVisible;
	IBOutlet UIPickerView *picker;
	IBOutlet UITextView *incidentText;
	IBOutlet UITextField *lineField;
	CGFloat animatedDistance;
	int consecutiveReturns;
}

@property (nonatomic, retain) NSArray *type;
@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, retain) NSString *selectedType;
@property (nonatomic, retain) NSDictionary *transportData;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UITextView *incidentText;
@property (nonatomic, retain) IBOutlet UITextField *lineField;

- (IBAction)textDoneEditing:(id) sender;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void) save:(id)sender;
- (void) cancel:(id)sender;
@end
