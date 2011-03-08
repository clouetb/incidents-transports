//
//  RootViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 25/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "IncidentDetailViewController.h"
#import "IncidentAddViewController.h"
#import "MBProgressHUD.h"

@interface RootViewController : UITableViewController <IncidentAddViewControllerDelegate> {
	IBOutlet UIBarButtonItem *addButtonItem;
	IBOutlet UIBarButtonItem *refreshButtonItem;
	IBOutlet UIBarButtonItem *cancelButtonItem;
	NSString *RESTAction;
	NSString *displayFormat;
	NSMutableArray *incidentsList;
	NSMutableData *responseData;
	NSURLConnection *connection;
	CFTimeInterval lastRefresh;
}

@property (nonatomic, retain) NSArray *incidentsList;
@property (nonatomic, retain) NSString *RESTAction;
@property (nonatomic, retain) NSString *displayFormat;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButtonItem;
@property (retain) IBOutlet UIBarButtonItem *refreshButtonItem;
@property (retain) IBOutlet UIBarButtonItem *cancelButtonItem;
@property (retain) NSURLConnection *connection;

- (IBAction) addButtonPressed: (id)sender;
- (IBAction) refreshButtonPressed: (id)sender;
- (IBAction) cancelButtonPressed:(id)sender;

- (void)initAndLaunchAsyncRequest;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
