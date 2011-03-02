//
//  IncidentAddViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "MBProgressHUD.h"

@interface IncidentAddViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	NSArray *types;
	NSArray *lines;
	NSString *selectedType;
	NSDictionary *transportData;
	BOOL keyboardVisible;
	IBOutlet UIPickerView *picker;
	IBOutlet UITextView *incidentText;
	IBOutlet UITextField *lineField;
	IBOutlet UITextField *bgField;
	CGFloat animatedDistance;
	NSMutableData *responseData;
}

@property (nonatomic, retain) NSArray *types;
@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, retain) NSString *selectedType;
@property (nonatomic, retain) NSDictionary *transportData;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UITextView *incidentText;
@property (nonatomic, retain) IBOutlet UITextField *lineField;
@property (nonatomic, retain) IBOutlet UITextField *bgField;

- (IBAction)textDoneEditing:(id) sender;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void) save:(id)sender;
- (void) cancel:(id)sender;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
