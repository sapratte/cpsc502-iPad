//
//  ViewController.m
//  SOD-iOS-Client
//
//  Created by ASE Group on 3/13/2014.
//  Copyright (c) 2014 ASE Group. All rights reserved.
//

#import "ViewController.h"

#import "NavigationMenu.h"



@interface ViewController ()

@end

@implementation ViewController  {
	
	BOOL navSelected;
	UIView *menu;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self = [super init];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
	
	
	
	// ------------------------------------
	
	navSelected = NO;
	
	
}




- (IBAction)navButtonPressed:(id)sender
{
	UIButton *navButton = (UIButton *)sender;
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	protocol = [[NavigationMenu alloc] initWithFrame:frame atPoint:navButton.center];
	[protocol setDelegate:self];
	[self.view addSubview:protocol];
}

- (void)menuButtonSelected:(id)sender
{
	NSLog(@"Button Pressed!");
	[self performSegueWithIdentifier:@"showPOS" sender:self];
}









@end
