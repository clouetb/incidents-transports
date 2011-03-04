//
//  HourIncidentsViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 04/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "HourIncidentsViewController.h"


@implementation HourIncidentsViewController

// Triggered when the view is about to appear
- (void)viewDidLoad {
    [super viewDidLoad];
	self.RESTAction = REST_ACTION_HOUR;
}

- (void)dealloc {
    [super dealloc];
}


@end
