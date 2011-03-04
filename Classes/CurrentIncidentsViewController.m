//
//  CurrentIncidentsViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 04/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "CurrentIncidentsViewController.h"


@implementation CurrentIncidentsViewController

// Triggered when the view is about to appear
- (void)viewDidLoad {
    [super viewDidLoad];
	self.RESTAction = REST_ACTION_CURRENT;
}

- (void)dealloc {
    [super dealloc];
}


@end
