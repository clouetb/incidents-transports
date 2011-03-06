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

- (NSNumber *)voteForIncident:(NSString *)type {
	NSMutableURLRequest *theRequest;
	NSURLResponse *theResponse;
	NSData *result;
	NSError *error = nil;
	NSURL *URL;
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
	
	// Execute and build a string from the result
	result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
	NSString *string = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
	LogDebug (@"%@", string);
	
	// Return the value assigned by the server
	return [NSNumber numberWithInteger:[string integerValue]];
}

// Vote for incident existing +1
- (void)plusButtonPressed:(id)sender {
	LogDebug(@"Plus button pressed");
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	NSString *plus = @"plus";
	
	// Trigger the request with correct parameters
	NSNumber *numberOfPlus = [self voteForIncident:plus];
	
	[self checkForError:numberOfPlus];
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	// Update cached value
	[incident setValue:numberOfPlus forKey:VOTE_PLUS];
	LogDebug(@"Value %@", [incident objectForKey:VOTE_PLUS]);
	
	// Update 
	[plusButton setTitle:[NSString stringWithFormat:@"+1\t(%@)", [incident objectForKey:VOTE_PLUS]]
				 forState:UIControlStateNormal];
}

// Vote for incident not existing -1
- (void)minusButtonPressed:(id)sender {
	LogDebug(@"Minus button pressed");
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	NSString *minus = @"minus";
	NSNumber *numberOfMinus = [self voteForIncident:minus];
	
	[self checkForError:numberOfMinus];
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	[incident setValue:numberOfMinus forKey:VOTE_MINUS];
	LogDebug(@"Value %@", [incident objectForKey:VOTE_MINUS]);
	[minusButton setTitle:[NSString stringWithFormat:@"-1\t(%@)", [incident objectForKey:VOTE_MINUS]]
				 forState:UIControlStateNormal];
}

// Vote for incident end
- (void)endButtonPressed:(id)sender {
	LogDebug(@"Minus button pressed");
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];

	NSString *end = @"end";
	NSNumber *numberOfEnd = [self voteForIncident:end];
	
	[self checkForError:numberOfEnd];
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	[incident setValue:numberOfEnd forKey:VOTE_ENDED];
	LogDebug(@"Value %@", [incident objectForKey:VOTE_ENDED]);
	[endButton setTitle:[NSString stringWithFormat:@"Incident terminé\t(%@)", [incident objectForKey:VOTE_ENDED]]
				 forState:UIControlStateNormal];
}

- (void)checkForError:(NSNumber *) numberOfVotes {
	// If the result is still 0, there is an error.
	if ([numberOfVotes intValue] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Impossible de soumettre le vote" 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
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


@end
