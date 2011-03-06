//
//  WebListViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"


@interface WebListViewController : UITableViewController {
	NSArray *websitesNames;
	NSDictionary *websites;
}

@property (nonatomic, retain) NSArray *websitesNames;
@property (nonatomic, retain) NSDictionary *websites;

@end
