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

@interface RootViewController : UITableViewController {
	NSMutableArray *incidentsList;
	IBOutlet UIBarButtonItem *addButtonItem;
	IBOutlet UIBarButtonItem *refreshButtonItem;
}

@property (nonatomic, retain) NSArray *incidentsList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButtonItem;


- (IBAction) addButtonPressed: (id)sender;
- (IBAction) refreshButtonPressed: (id)sender;
- (NSMutableArray *)allocIncidentsArray;
@end
