//
//  ViewController.h
//  SOD-iOS-Client
//
//  Created by ASE Group on 3/13/2014.
//  Copyright (c) 2014 ASE Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationMenu.h"

@interface ViewController : UIViewController <UITextFieldDelegate, NavigationMenuDelegate> {
	
	NavigationMenu *protocol;
}

- (IBAction)navButtonPressed:(id)sender;


@property (retain, nonatomic) IBOutlet UITextView *txtStatus;
@property (retain, nonatomic) IBOutlet UITextField *txtTestData;

@end
