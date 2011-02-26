//
//  IncidentDetailViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "IncidentDetailViewController.h"


@implementation IncidentDetailViewController

@synthesize	incident, dateTextField, lineTextField, reasonTextView;

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateFormater dateFromString:[incident objectForKey:@"time"]];
	[dateFormater setDateFormat:@"dd/MM/yyyy HH:mm"];
	
	dateTextField.text = [dateFormater stringFromDate:date];
	lineTextField.text = [[incident objectForKey:@"line"] objectForKey:@"name"];
	reasonTextView.text = [incident objectForKey:@"reason"];
	
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[dateTextField release];
	[lineTextField release];
	[reasonTextView release];
	[incident release];
}


@end
