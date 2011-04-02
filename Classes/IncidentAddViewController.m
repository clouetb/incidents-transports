//
//  IncidentAddViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "IncidentAddViewController.h"


@implementation IncidentAddViewController

@synthesize types, lines, selectedType, transportData, picker, incidentText, lineField, bgField, delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	types = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"transport-means" ofType:@"plist"]];
	transportData = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"transport-lines" ofType:@"plist"]];
	selectedType = [types objectAtIndex:0];
	lines = [transportData objectForKey:selectedType];
	self.lineField.enabled = NO;
	self.title = @"Ajout incident";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave	target:self action:@selector(save:)] autorelease];
}

- (void) save:(id)sender {
	NSMutableURLRequest *theRequest;
	NSString *lineValue;
	NSURL *URL;
	NSMutableDictionary *incidentValues;
	[incidentText resignFirstResponder];
	[lineField resignFirstResponder];
	
	// Store the time at the start of the operation
	startTime = CFAbsoluteTimeGetCurrent();
	
	// Display an activity indicator
	[MBProgressHUD showHUDAddedTo:self.view.superview.superview.superview animated:YES];
	SBJsonWriter *json = [SBJsonWriter new];
	
	// Build the URL depending on the button pressed and on the incident ID
	NSString *URLString = [[NSString alloc] initWithFormat:@"http://%@/api/incident", 
                           [[NSUserDefaults standardUserDefaults] objectForKey:INCIDENT_SERVER_HOST]];
	LogDebug(@"URL %@", URLString);
	URL = [NSURL URLWithString:URLString];
	LogDebug (@"%@", URL);
	
	// Build the GET request
	theRequest = [NSMutableURLRequest requestWithURL:URL
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	incidentValues = [[NSMutableDictionary alloc] init];
	[incidentValues setObject:self.incidentText.text forKey:REASON];
	
	switch ([picker selectedRowInComponent:0]) {
		case 4:
			lineValue = [[NSString alloc] initWithFormat:@"%@ %@", 
						 selectedType, 
						 self.lineField.text];
            LogDebug(@"LineValue=%@", lineValue);
            if ([lineValue isEqualToString:@"Bus Précisez la ligne de bus."]) {
                [MBProgressHUD hideHUDForView:self.view.superview.superview.superview animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Précisez la ligne de bus." message:nil 
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                [json release];
                [URLString release];
                [incidentValues release];
                return;
            }
			break;
		case 5:
			lineValue = self.lineField.text;
            LogDebug(@"LineValue=%@", lineValue);
            if ([lineValue isEqualToString:@"Saisissez la ligne affectée."]) {
                [MBProgressHUD hideHUDForView:self.view.superview.superview.superview animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saisissez la ligne affectée." message:nil 
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                [json release];
                [URLString release];
                [incidentValues release];
                return;
            }

			break;
		default:
			lineValue = [[NSString alloc] initWithFormat:@"%@ %@", 
						 selectedType,
						 [lines objectAtIndex:[picker selectedRowInComponent:1]]];
			break;
	}
	[incidentValues setObject:lineValue forKey:LINE_NAME];
	[lineValue release];
	[incidentValues setObject:@"iMLate" forKey:SOURCE];
	LogDebug(@"Values : %@", [json stringWithObject:incidentValues]);
	
	// Init data placeholder
	responseData = [[NSMutableData alloc] init];
	[theRequest setHTTPBody:[json dataWithObject:incidentValues]];
	
	// Asynchronously execute request
	[[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
    [incidentValues release];
    [URLString release];
    [json release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseHeader = [(NSHTTPURLResponse *)response retain];
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	LogError(@"%@", [error localizedDescription]);
	// If time elapsed since beginning of operation is less than SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR sleep a bit
	CFTimeInterval difference = CFAbsoluteTimeGetCurrent() - startTime;
	if (difference < SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR)
		[NSThread sleepForTimeInterval:SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR - difference];
	[MBProgressHUD hideHUDForView:self.view.superview.superview.superview animated:YES];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message: 
                          [NSString stringWithFormat: @"Impossible de soumettre l'incident.\n%@", [error localizedDescription]] 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
    [alert release];
	[responseData release];
    [responseHeader release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// If time elapsed since beginning of operation is less than SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR sleep a bit
	CFTimeInterval difference = CFAbsoluteTimeGetCurrent() - startTime;
	if (difference < SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR)
		[NSThread sleepForTimeInterval:SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR - difference];
	[MBProgressHUD hideHUDForView:self.view.superview.superview.superview animated:YES];
    int status = [responseHeader statusCode];
    if (status == 201) {
        // Build a string from the result
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        LogDebug (@"Return received %@", string);
    } else if (status == 503) {
        // Request has been throttled
        NSDictionary *headers = [responseHeader allHeaderFields];
        LogDebug(@"Throttle %@", headers);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trop de requêtes" message:[NSString stringWithFormat: @"Le serveur vous considère temporairement comme un spammeur.\nMerci d'attendre %@ secondes avant de voter ou de déclarer de nouveaux incidents.", [headers valueForKey:@"Retry-After"]] 
            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
        [alert release];
        [responseData release];
        [responseHeader release];
        return;
    } else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat: @"Impossible de soumettre l'incident.\nCode %d: %@", status,
            [NSHTTPURLResponse localizedStringForStatusCode:status]] 
            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
		[alert show];
        [alert release];
        [responseData release];
        [responseHeader release];
		return;
	}
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[delegate addViewControllerDidFinish];
    [responseData release];
    [responseHeader release];
}

- (void) cancel:(id)sender {
	[incidentText resignFirstResponder];
	[lineField resignFirstResponder];
	LogDebug(@"Cancel pressed");
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[types release];
	[lines release];
	[selectedType release];
	[transportData release];
	[picker release];
	[incidentText release];
	[lineField release];
}

- (IBAction)textDoneEditing:(id) sender {
	[sender resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    } 
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (component == 0) {
		selectedType = [types objectAtIndex:[pickerView selectedRowInComponent:0]];
		LogDebug(@"Chosen Mean %@", selectedType);
		lines = [transportData objectForKey:selectedType];
		LogDebug(@"Loading Mean %@", lines);
		[picker reloadAllComponents];
		[picker selectRow:0 inComponent:1 animated:YES];
		switch (row) {
			case 4:
				self.lineField.enabled = YES;
				self.lineField.keyboardType = UIKeyboardTypeNumberPad;
				self.lineField.text = @"Précisez la ligne de bus.";
				break;
			case 5:
				self.lineField.enabled = YES;
				self.lineField.keyboardType = UIKeyboardTypeDefault;
				self.lineField.text = @"Saisissez la ligne affectée.";
				break;
			default:
				self.lineField.enabled = NO;
				self.lineField.text = @"";
				break;
		}
        
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return [types objectAtIndex:row];
			break;
		case 1:
			return [[transportData objectForKey:selectedType] objectAtIndex:row];
			break;
		default:
			break;
	}
	return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	switch (component){
		case 0: 
			return 190.0f;
		case 1: 
			return 110.0f;
	}
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		LogDebug(@"Means to load %d", [types count]);
		return [types count];
	} else {
		LogDebug(@"Lines to load %d", [lines count]);
		return [lines count];
	}
	
}

// CGStuff black magic...
// Remind me of sending some beer coupons to the cocoawithlove genius
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textField
{
    CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	// Select all the text in the incident text so that the user can wipe the entire content just by starting to type
	[self performSelector:@selector(selectAll:) withObject:incidentText afterDelay:0.01]; 
} 

// Select all the text in the textView
- (void)selectAll:(UITextView *)inView 
{ 
	inView.selectedRange = NSMakeRange(0, [incidentText.text length]); 
} 


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
