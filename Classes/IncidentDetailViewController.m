//
//  IncidentDetailViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "IncidentDetailViewController.h"

@implementation IncidentDetailViewController

@synthesize	incident, dateTextField, reasonTextView, plusButton, minusButton, endButton;

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	responseData = [[NSMutableData alloc] init];
	// Format the dates to be nicely displayed
	NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateFormater dateFromString:[incident objectForKey:LAST_MODIFIED_TIME]];
	[dateFormater setDateFormat:@"dd/MM HH:mm"];
	
	// Put the transport line as the title of the dialog
	self.title = [[NSString alloc] initWithFormat:@"%@", [incident objectForKey:LINE]];
	dateTextField.text = [dateFormater stringFromDate:date];
	reasonTextView.text = [incident objectForKey:REASON];
	[plusButton setTitle:[NSString stringWithFormat:@"+1\t(%@)", [incident objectForKey:VOTE_PLUS]] 
				forState:UIControlStateNormal];
	[minusButton setTitle:[NSString stringWithFormat:@"-1\t(%@)", [incident objectForKey:VOTE_MINUS]]
				 forState:UIControlStateNormal];
	[endButton setTitle:[NSString stringWithFormat:@"Incident terminé\t(%@)", [incident objectForKey:VOTE_ENDED]]
				 forState:UIControlStateNormal];
	
}

- (void)voteForIncident:(NSString *)type {
	NSMutableURLRequest *theRequest;
	NSURL *URL;
	// Store the time at the start of the operation
    startTime = CFAbsoluteTimeGetCurrent();
	// Build the URL depending on the button pressed and on the incident ID
	NSString *URLString = [[NSString alloc] initWithFormat:@"http://%@/incident/action/%@/%@", 
			  [[NSUserDefaults standardUserDefaults] objectForKey:INCIDENT_SERVER_HOST],
			  [incident objectForKey:UID],
			  type];
	URL = [NSURL URLWithString:URLString];
	LogDebug (@"%@", URL);
	
	// Build the GET request
	theRequest = [NSMutableURLRequest requestWithURL:URL
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	
	// Asynchronously execute request
	[[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
    [URLString release];
}

// Vote for incident existing +1
- (void)plusButtonPressed:(id)sender {
	LogDebug(@"Plus button pressed");
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	NSString *plus = @"plus";
	
	// Trigger the request with correct parameters
    buttonToUpdate = plusButton;
	[self voteForIncident:plus];
}

// Vote for incident not existing -1
- (void)minusButtonPressed:(id)sender {
	LogDebug(@"Minus button pressed");
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	NSString *minus = @"minus";
    buttonToUpdate = minusButton;
	[self voteForIncident:minus];
}

// Vote for incident end
- (void)endButtonPressed:(id)sender {
	LogDebug(@"Minus button pressed");
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	NSString *end = @"end";
    buttonToUpdate = endButton;
    [self voteForIncident:end];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];   
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
	[dateTextField release];
	[reasonTextView release];
	[plusButton release];
	[minusButton release];
	[endButton release];
	[incident release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Impossible de soumettre le vote" 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
    [alert release];
	[responseData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Build a string from the result
    LogDebug(@"%@", responseData);
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	LogDebug (@"%@", string);
	// If time elapsed since beginning of operation is less than SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR sleep a bit
	CFTimeInterval difference = CFAbsoluteTimeGetCurrent() - startTime;
	if (difference < SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR)
		[NSThread sleepForTimeInterval:SECONDS_TO_DISPLAY_ACTIVITY_INDICATOR - difference];
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	// Return the value assigned by the server
	int returnValue = [string integerValue];
    if (returnValue != 0) {
        if (buttonToUpdate == minusButton) {
            [incident setValue:[NSNumber numberWithInt:returnValue] forKey:VOTE_MINUS];
            LogDebug(@"Value %@", [incident objectForKey:VOTE_MINUS]);
            [minusButton setTitle:[NSString stringWithFormat:@"-1\t(%@)", [incident objectForKey:VOTE_MINUS]]
                         forState:UIControlStateNormal];
            
        }
        if (buttonToUpdate == plusButton) {
            // Update cached value
            [incident setValue:[NSNumber numberWithInt:returnValue] forKey:VOTE_PLUS];
            LogDebug(@"New plus value %@", [incident objectForKey:VOTE_PLUS]);
            
            // Update 
            [plusButton setTitle:[NSString stringWithFormat:@"+1\t(%@)", [incident objectForKey:VOTE_PLUS]]
                        forState:UIControlStateNormal];
        }
        if (buttonToUpdate == endButton) {
            [incident setValue:[NSNumber numberWithInt:returnValue] forKey:VOTE_ENDED];
            LogDebug(@"Value %@", [incident objectForKey:VOTE_ENDED]);
            [endButton setTitle:[NSString stringWithFormat:@"Incident terminé\t(%@)", [incident objectForKey:VOTE_ENDED]]
                       forState:UIControlStateNormal];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Impossible de soumettre le vote" 
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

@end
