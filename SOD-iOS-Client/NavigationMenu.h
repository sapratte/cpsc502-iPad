//
//  NavigationMenu.h
//  Brigade-iPad
//
//  Created by Sydney Pratte on 2014-04-17.
//  Copyright (c) 2014 Sydney Pratte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationMenuDelegate <NSObject>

@required
- (IBAction)menuButtonSelected:(id)sender;

@end

@interface NavigationMenu : UIView
{
    id <NavigationMenuDelegate> delegate;
}

@property (retain) id delegate;

- (id)initWithFrame:(CGRect)frame atPoint:(CGPoint)p;

@end
