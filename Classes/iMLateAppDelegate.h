//
//  iMLateAppDelegate.h
//  iMLate
//
//  Created by Benoît Clouet on 25/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iMLateAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

