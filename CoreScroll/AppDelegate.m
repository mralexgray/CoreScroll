//
//AppDelegate.m
//CoreScroll
//
//Created by Alex Gray on 8/3/12.
//
//
#import "AppDelegate.h"
#import <AtoZ/AtoZ.h>
#import "CustomView.h"

@implementation AppDelegate
- (void) awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:AtoZSharedInstanceUpdated];
	NSLog(@"Has shared? \"%@\"", StringFromBOOL([AtoZ hasSharedInstance]));
	NSLog(@"%@",[[AtoZ dockSorted] valueForKeyPath:@"name"] );
	NSLog(@"Has shared? \"%@\"", StringFromBOOL([AtoZ hasSharedInstance]));
}
-(void) didChangeValueForKeyP:(NSString *)key {
	NSLog(@"Has notificationhave shared? \"%@\"", StringFromBOOL([AtoZ hasSharedInstance]));
	NSLog(@"Weaaa: Log?: %", key);
	
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
//	AtoZ *u = [AtoZ sharedInstance];
}
@end
