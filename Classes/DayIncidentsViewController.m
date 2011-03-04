//
//  DayIncidentsViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 04/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "DayIncidentsViewController.h"


@implementation DayIncidentsViewController

// Triggered when the view is about to appear
- (void)viewDidLoad {
    [super viewDidLoad];
	self.RESTAction = REST_ACTION_DAY;
}

- (void)dealloc {
    [super dealloc];
}


@end
