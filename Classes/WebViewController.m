//
//  WebViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView, urlAddress, website;

- (void)viewDidLoad {
	self.title = website;
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://%@", urlAddress]];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
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
	[webView release];
	[urlAddress release];
}


@end
