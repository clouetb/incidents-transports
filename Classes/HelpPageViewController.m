//
//  HelpPageViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "HelpPageViewController.h"


@implementation HelpPageViewController

@synthesize imageName, imageView;

- (id)initWithImageName:(NSString *)currentImageName {
    self = [super initWithNibName:@"HelpPageViewController" bundle:nil];
	self.imageName = currentImageName;
    return self;
}

- (void)viewDidLoad {
	LogDebug(@"View Loaded");
	UIImage *image;
	image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageName]];
	imageView.image = image;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	[imageView release];
}


@end
