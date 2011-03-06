//
//  AboutViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize text;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"À propos";
	NSError *error;
	self.text.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
											pathForResource:@"about" ofType:@"txt"] 
											encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Impossible de récuperer le texte d'information" 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	[text release];
}


@end
