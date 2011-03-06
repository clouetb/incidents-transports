//
//  HelpPageViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 06/03/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpPageViewController : UIViewController {
	IBOutlet UIImageView *imageView;
	NSString *imageName;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet NSString *imageName;

- (id)initWithImageName:(NSString *)imageName;

@end
