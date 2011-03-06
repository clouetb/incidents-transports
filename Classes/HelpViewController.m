//
//  HelpViewController.m
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController

@synthesize window, scrollView, pageControl, viewControllers, imageNames;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Aide";
	imageNames = [[NSArray alloc] initWithArray: [NSArray arrayWithContentsOfFile:
										  [[NSBundle mainBundle] pathForResource:@"help-images" ofType:@"plist"]] copyItems:YES];
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	for (int i = 0; i < [imageNames count]; i++) {
		[controllers addObject:[NSNull null]];
	}
	
    self.viewControllers = controllers;
    [controllers release];
	
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [imageNames count], scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = [imageNames count];
    pageControl.currentPage = 0;
	
	for (int i = 0; i < [imageNames count]; i++) {
		[self loadScrollViewWithPage:i];
	}
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= [imageNames count]) return;
	
    HelpPageViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[HelpPageViewController alloc] initWithImageName:[imageNames objectAtIndex:page]];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (pageControlUsed) {
		 return;
	}
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	pageControl.currentPage = page;

	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
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
	[window release];
	[scrollView release];
	[pageControl release];
}


@end
