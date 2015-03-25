//
//  POSManagerViewController.m
//  Brigade-iPad
//
//  Created by Sydney Pratte on 2014-04-21.
//  Copyright (c) 2014 Sydney Pratte. All rights reserved.
//

#import "POSManagerViewController.h"
#import "AppDelegate.h"

#import "SOD.h"
#import "SocketIOPacket.h"
#import "Device.h"

@interface POSManagerViewController ()

@property (nonatomic, strong) SOD *SOD;

@end

@implementation POSManagerViewController {
	
	CGPoint moveStart;
	UIImageView *moveView;
	UIImageView *reward;
}

typedef void(^MyResponseCallback)(NSDictionary* response);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//create SoD instance, setup dimensions and device type
	self.SOD = [[SOD alloc] initWithAddress:@"beastwin.marinhomoreira.com" andPort:3000];
	self.SOD.device.height = 1;
	self.SOD.device.width = 1;
	self.SOD.device.name = @"Retail iPad";
	self.SOD.device.deviceType = @"iPad";
	self.SOD.device.FOV = 33;
	self.SOD.device.orientation = 45;
	//self.SOD.height = 50;
	//self.SOD.width = 50;
	//self.SOD.name = @"Test iPad";
	//self.SOD.deviceType = @"iPad";
	
	//send info about this device to server
	[self.SOD registerDevice];
	
	if(self){
		
		//add event handlers, name = eventName which server sent to
		//For example, socket.emit("string", "testString") will call stringReceivedHandler
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stringReceivedHandler:) name:@"string" object:nil];
		
		// Enter view leave view event
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enviewEventHandler:) name:@"enterView" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveViewEventHandler:) name:@"leaveView" object:nil];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dictionaryReceivedHandler:) name:@"dictionary" object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventReceivedHandler:) name:@"event" object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestReceivedHandler:) name:@"request" object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestedDataReceivedHandler:) name:@"requestedData" object:nil];
	}

	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addRewardToWall:)];
	[_rewardContainer addGestureRecognizer:longPress];

	// Set moveView background image and oriantaion
	moveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[moveView setImage:[UIImage imageNamed:@"moveToWall.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	NSLog(@"Main Button Pressed!");
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)addRewardToWall:(UILongPressGestureRecognizer *)gesture {

	// get touch point
    CGPoint point = [gesture locationInView:moveView];
    
    // if touch started save the start position
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.view addSubview:moveView];
        moveStart = [gesture locationInView:moveView];
		
		// Add reward Icon
        reward = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 173, 173)];
		[reward setImage:[UIImage imageNamed:@"rewardIcon.png"]];
		reward.center = moveStart;
		
		[moveView addSubview:reward];
    }
    // calculate new image center position
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // move image
		reward.center = point;
    }
	else if (gesture.state == UIGestureRecognizerStateEnded)
	{
		// Sanp icon to location
		[UIView animateWithDuration:0.3f animations:^{
			reward.center = CGPointMake(moveView.center.x, 0);
			[reward layoutIfNeeded];
		} completion:^(BOOL finished){
			
			
			
			// Send to Wall
			
			NSString *stringData = @"newAd";
			
			MyResponseCallback requestCallback = ^(id reply)
			{
				NSLog(@"%@", [reply objectForKey:@"status"]);
			};
			
			[self.SOD sendEvent:stringData toEvent:@"newAd" withSelection:@"all" andCallBack:requestCallback];

			
			
			[reward removeFromSuperview];
			[moveView removeFromSuperview];
			[_addedRewardImage setHidden:NO];
		}];
	}

}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





// ---------------------------------- SOD ------------------------------------------------

- (IBAction)reconnectToServer:(id)sender {
	[self.SOD reconnectToServer];
}

- (IBAction)calibrateDeviceAngle:(id)sender {
	[self.SOD calibrateDeviceAngle];
}

- (IBAction)sendTestString:(id)sender {
	NSString* stringData = @"Data";
	MyResponseCallback requestCallback = ^(id reply)
	{
		NSLog(@"%@", [reply objectForKey:@"status"]);
	};
	[self.SOD sendString:stringData withSelection:@"inView" andCallBack:requestCallback];
	
}
- (IBAction)sendTestDictionary:(id)sender {
	NSString* stringData = @"Data";
	NSDictionary* dictionaryData = [NSDictionary dictionaryWithObjectsAndKeys:
									[[[UIDevice currentDevice] identifierForVendor] UUIDString], @"deviceID", stringData, @"string", nil];
	MyResponseCallback requestCallback = ^(id reply)
	{
		NSLog(@"%@", [reply objectForKey:@"status"]);
	};
	[self.SOD sendDictionary:dictionaryData withSelection:@"all" andCallBack:requestCallback];
}
- (IBAction)sendRequest:(id)sender {
	NSString* requestName = @"Data";
	MyResponseCallback requestCallback = ^(id reply)
	{
		NSLog(@"%@", [reply objectForKey:@"status"]);
	};
	[self.SOD requestDataWithRequestName:requestName andSelection:@"all" andCallBack:requestCallback];
}

- (IBAction)setPairingState:(id)sender {
	
	[self.SOD setPairingState];
}

- (IBAction)unpairDevice:(id)sender {

	[self.SOD unpairDevice];
}

- (IBAction)unpairAllDevices:(id)sender {
	[self.SOD unpairAllDevices];
}

- (IBAction)unpairAllPeople:(id)sender {

	[self.SOD unpairAllPeople];
}

- (IBAction)restartMotionManager:(id)sender {

	[self.SOD restartMotionManager];
}

- (IBAction)getPeopleFromServer:(id)sender {

	MyResponseCallback requestCallback = ^(id reply)
	{
		NSString *outputString = @"";
		if([reply isKindOfClass:[NSDictionary class]]){
			NSDictionary* dict = reply;
			outputString = @"ID: %@, Location: %@, Pair Status: %@",[dict objectForKey:@"ID"],[dict objectForKey:@"Location"], [dict objectForKey:@"OwnedDeviceID"];
		}
		else{
			NSArray* arr = reply;
			for (int i=0; i<[arr count]; i++) {
				NSDictionary* dict = [arr objectAtIndex:i];
				outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"ID: %@, Location: %@, Orientation: %@, PairingState: %@, OwnedDeviceID: %@",[dict objectForKey:@"ID"],[dict objectForKey:@"Location"], [dict objectForKey:@"Orientation"], [dict objectForKey:@"PairingState"], [dict objectForKey:@"OwnedDeviceID"]]];
			}
		}
		NSLog(@"%@", outputString);
	};
	[self.SOD getAllTrackedPeoplewithCallBack:requestCallback];
}

- (IBAction)getDevicesFromServer:(id)sender {
	MyResponseCallback requestCallback = ^(id reply)
	{
		NSString *outputString = @"";
		for(id key in reply){
			NSDictionary* dict = [reply valueForKeyPath:key];
			outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"ID: %@, SocketID: %@, Location: %@, Orientation: %@, PairingState: %@, OwnerID: %@",[dict objectForKey:@"ID"], [dict objectForKey:@"socketID"], [dict objectForKey:@"Location"], [dict objectForKey:@"Orientation"], [dict objectForKey:@"PairingState"], [dict objectForKey:@"OwnerID"]]];
		}
		NSLog(@"%@", outputString);
	};
	
	[self.SOD getDevicesWithSelection:@"all" withCallBack:requestCallback];
}

- (IBAction)getDevicesInView:(id)sender {
	MyResponseCallback requestCallback = ^(id reply)
	{
		NSString *outputString = @"";
		for(id key in reply){
			NSDictionary* dict = [reply valueForKeyPath:key];
			outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"ID: %@, SocketID: %@, Location: %@, Orientation: %@, PairingState: %@, OwnerID: %@",[dict objectForKey:@"ID"], [dict objectForKey:@"socketID"], [dict objectForKey:@"Location"], [dict objectForKey:@"Orientation"], [dict objectForKey:@"PairingState"], [dict objectForKey:@"OwnerID"]]];
		}
		NSLog(@"%@", outputString);
	};
	[self.SOD getDevicesWithSelection:@"inView" withCallBack:requestCallback];
}


- (IBAction)getSingleDeviceByID:(id)sender {
	

}


- (void)stringReceivedHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"String received: %@", [theData objectForKey:@"data"]);
}

- (void)enviewEventHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"Enter View event received: %@,%@", [theData objectForKey:@"observer"],[theData objectForKey:@"visitor"]);
}
- (void)leaveViewEventHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"Leave View event received: %@,%@", [theData objectForKey:@"observer"],[theData objectForKey:@"visitor"]);
	
}

- (void)dictionaryReceivedHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"Dictionary received: %@", [theData objectForKey:@"data"]);
}

- (void)eventReceivedHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"Event received: %@", [theData objectForKey:@"data"]);
}

/**
 *  <#Description#>
 *
 *  @param event <#event description#>
 */
- (void)requestReceivedHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"Received request for... %@", [theData objectForKey:@"data"]);
	NSString* PID = [[event userInfo] objectForKey:@"PID"];
	NSDictionary *dataToSendBack = [NSDictionary dictionaryWithObjectsAndKeys:
									@"this is the sample data", @"data", nil];
	NSLog(@"Viewcontroller sending an acknowledgement with PID %@ and data... %@", PID, dataToSendBack);
	[self.SOD sendAcknowledgementWithPID:PID andData:dataToSendBack];
}

//handler for receiving the requested data (Request/reply pattern)
- (void)requestedDataReceivedHandler: (NSNotification*) event
{
	NSDictionary *theData = [[event userInfo] objectForKey:@"data"];
	NSLog(@"Requested data received: %@", [theData objectForKey:@"data"]);
}



/**
 *  Convert a dictionary to string for output.
 *
 *  @param dictionary dictionary to be converted
 *
 *  @return string representation of dictionary
 */
-(NSString*) dictionaryToString:(NSDictionary*) dictionary{
	NSMutableString *returnString = [[NSMutableString alloc] init];
	for(NSString *aKey in [dictionary allKeys])
		[returnString appendFormat:@"%@ : %@\n", aKey, [dictionary valueForKey:aKey]];
	return returnString;
}




@end
