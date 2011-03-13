//
//  WebViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView, urlAddress, website, activityIndicator, backButton, forwardButton, refreshButton;

- (void)viewDidLoad {
	self.title = website;
    // Register for reachability changes
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    hostReach = [[Reachability reachabilityWithHostName:urlAddress] retain];
    NetworkStatus status = [hostReach currentReachabilityStatus];
    if (status == NotReachable) {
        websiteReachable = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Impossible de contacter le serveur"
                                                        message:[NSString stringWithFormat:@"iMLate ne peut contacter le serveur %@ parce que vous n'êtes pas connecté à internet", [[NSUserDefaults standardUserDefaults] stringForKey:INCIDENT_SERVER_HOST]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    } else {
        websiteReachable = YES;
    }
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://%@", urlAddress]];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//Load the request in the UIWebView.
    [self navigationItem].rightBarButtonItem = backButton;
	[webView loadRequest:requestObj];
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
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

- (void)reachabilityChanged: (NSNotification* )note {
    LogDebug(@"******");
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    if (curReach == hostReach){
        NetworkStatus status = [curReach currentReachabilityStatus];
        if (status == NotReachable) {
            websiteReachable = NO;
        } else {
            websiteReachable = YES;
        }
    }
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    LogDebug(@"Should start");
    if (!websiteReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Impossible de contacter le serveur"
                                                        message:[NSString stringWithFormat:@"iMLate ne peut contacter le serveur %@ parce que vous n'êtes pas connecté à internet", [[NSUserDefaults standardUserDefaults] stringForKey:INCIDENT_SERVER_HOST]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}

- (IBAction) backButtonPressed: (id)sender{
    [webView goBack];
}

- (IBAction) forwardButtonPressed: (id)sender{
    [webView goForward];
}

- (IBAction) refreshButtonPressed: (id)sender{
    [webView reload];
}
- (void)dealloc {
    [super dealloc];
	[webView release];
	[urlAddress release];
	[activityIndicator release];
}


@end
