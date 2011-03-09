//
//  WebViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView, urlAddress, website, activityIndicator;

- (void)viewDidLoad {
	self.title = website;
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://%@", urlAddress]];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self.activityIndicator stopAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.activityIndicator stopAnimating];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self.activityIndicator startAnimating];
}

- (void)dealloc {
    [super dealloc];
	[webView release];
	[urlAddress release];
	[activityIndicator release];
}


@end
