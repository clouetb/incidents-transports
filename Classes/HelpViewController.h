//
//  HelpViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpPageViewController.h"

@interface HelpViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	NSMutableArray *viewControllers;
	NSArray *imageNames;
	BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *imageNames;

- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;

@end
