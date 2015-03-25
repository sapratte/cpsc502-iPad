//
//  POSManagerViewController.h
//  Brigade-iPad
//
//  Created by Sydney Pratte on 2014-04-21.
//  Copyright (c) 2014 Sydney Pratte. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavigationMenu.h"

@interface POSManagerViewController : UIViewController  <NavigationMenuDelegate> {
	
	NavigationMenu *protocol;
}


@property (strong, nonatomic) IBOutlet UIImageView *rewardContainer;
@property (strong, nonatomic) IBOutlet UIImageView *addedRewardImage;

- (IBAction)navButtonPressed:(id)sender;

@end
