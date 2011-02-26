//
//  RootViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 25/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface RootViewController : UITableViewController {
	NSMutableArray *incidentsList;
	IBOutlet UIBarButtonItem *addButtonItem;
}
@property (nonatomic, retain) NSArray *incidentsList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButtonItem;
- (IBAction) addButtonPressed: (id)sender;
@end
