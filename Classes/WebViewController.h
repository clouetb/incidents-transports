//
//  WebViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSString *urlAddress;
	NSString *website;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;
@property (nonatomic, retain) NSString *website;

@end
