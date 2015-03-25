//
//  NavigationMenu.m
//  Brigade-iPad
//
//  Created by Sydney Pratte on 2014-04-17.
//  Copyright (c) 2014 Sydney Pratte. All rights reserved.
//

#import "NavigationMenu.h"



@implementation NavigationMenu  {
    
    NSArray *menuItems;
    CGPoint point;
    CGFloat endRadius;
    CGFloat nearRadius;
    CGFloat farRadius;
    CGFloat menuAngle;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame atPoint:(CGPoint)p
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.50f];
        menuItems = [self createMenuItems];
        point = p;
        endRadius = 100.0f;
        nearRadius = 90.0f;
        farRadius = 110.0;
        menuAngle = M_PI_2;
		
		UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 672, 95, 96)];
		[navButton setImage:[UIImage imageNamed:@"navButton_selected.png"] forState:UIControlStateNormal];
		[navButton addTarget:self action:@selector(closeMenu:) forControlEvents:UIControlEventTouchDown];
		
		[self addSubview:navButton];
        
        [self openMenu];
    }
    return self;
}

- (void)closeMenu:(UIButton*)button
{
	[self removeFromSuperview];
}

- (NSMutableArray *)createMenuItems
{
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	UIButton *item1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 49)];
	[item1 setImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
	[item1 addTarget:self action:@selector(displayMain:) forControlEvents:UIControlEventTouchDown];
	
	UIButton *item2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 49)];
	[item2 setImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
	[item2 addTarget:self action:@selector(displayPOSManager:) forControlEvents:UIControlEventTouchDown];
	
	UIButton *item3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 49)];
	[item3 setImage:[UIImage imageNamed:@"button3.png"] forState:UIControlStateNormal];
	
	UIButton *item4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 49)];
	[item4 setImage:[UIImage imageNamed:@"button4.png"] forState:UIControlStateNormal];
	
	[items addObject:item1];
	[items addObject:item2];
	[items addObject:item3];
	[items addObject:item4];
	
	return items;
}

// Animate menu opening
- (void)openMenu
{
    // add menu button items
    int count = [menuItems count];
    int n = 0;
    for (int i = 1; i <= [menuItems count]; i++)
    {
        CGPoint endPoint;
        CGPoint farPoint;
        CGPoint nearPoint;
        
        UIButton *item = [menuItems objectAtIndex:i-1];
		

        if (i == 1)
        {
            endPoint = CGPointMake(point.x, point.y - endRadius);
            farPoint = CGPointMake(point.x, point.y - farRadius);
            nearPoint = CGPointMake(point.x, point.y - nearRadius);
        }
		else if (i == 2)
		{
			endPoint = CGPointMake(point.x + endRadius - 52, point.y - endRadius + 15);
            farPoint = CGPointMake(point.x + farRadius - 52, point.y - farRadius + 15);
            nearPoint = CGPointMake(point.x + nearRadius - 52 , point.y - nearRadius + 15);
		}
		else if (i == 3)
		{
			endPoint = CGPointMake(point.x + endRadius - 15, point.y - endRadius + 52);
            farPoint = CGPointMake(point.x + farRadius - 15, point.y - farRadius + 52);
            nearPoint = CGPointMake(point.x + nearRadius - 15, point.y - nearRadius + 52);
		}
		else if (i == 4)
		{
			endPoint = CGPointMake(point.x + endRadius, point.y);
            farPoint = CGPointMake(point.x + farRadius, point.y);
            nearPoint = CGPointMake(point.x + nearRadius, point.y);
		}
        item.center = point;
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.30f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.center.x, item.center.y);
        CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
        CGPathAddLineToPoint(path, NULL, nearPoint.x, nearPoint.y);
        CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        
        [item.layer addAnimation:positionAnimation forKey:@"id"];
        item.center = endPoint;
        
        [self addSubview:item];
    }
    
}

#pragma mark - Button Actions

- (IBAction)displayPOSManager:(id)item
{
	[self removeFromSuperview];
	[[self delegate] menuButtonSelected:item];
}

- (IBAction)displayMain:(id)item
{
	[self removeFromSuperview];
	[[self delegate] menuButtonSelected:item];
}

@end
