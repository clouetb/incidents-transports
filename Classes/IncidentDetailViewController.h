//
//  IncidentDetailViewController.h
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IncidentDetailViewController : UIViewController {
	IBOutlet UITextField *dateTextField;
	IBOutlet UITextField *lineTextField;
	IBOutlet UITextView *reasonTextView;
	NSDictionary *incident;
}

@property (nonatomic, retain) IBOutlet UITextField *dateTextField;
@property (nonatomic, retain) IBOutlet UITextField *lineTextField;
@property (nonatomic, retain) IBOutlet UITextView *reasonTextView;
@property (nonatomic, retain) NSDictionary *incident;
@end
