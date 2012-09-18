//
//AppDelegate.m
//CoreScroll
//
//Created by Alex Gray on 8/3/12.
//
//

#import "AppDelegate.h"
#import <AtoZ/AtoZ.h>
#import <AZCoreScroll/AZCoreScroll.h>

@implementation AppDelegate

- (void) awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:AtoZSharedInstanceUpdated];
	NSLog(@"Has shared? \"%@\"", StringFromBOOL([AtoZ hasSharedInstance]));
//	NSLog(@"%@",[[AtoZ dockSorted] valueForKeyPath:@"name"] );
	NSLog(@"Has shared? \"%@\"", StringFromBOOL([AtoZ hasSharedInstance]));

//	NSImage *web = [NSImage imageFromWebPageAtURL:[NSURL URLWithString:@"http://google.com"] encoding:NSUTF8StringEncoding];
//	AZLOG(web);
//	[web saveAs:@"/Users/localadmin/Desktop/google.png"];
}

-(void) didChangeValueForKeyP:(NSString *)key {

	NSLog(@"Has notificationhave shared? \"%@\"", StringFromBOOL([AtoZ hasSharedInstance]));

	NSLog(@"Weaaa: Log?: %", key);
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application

//	AtoZ *u = [AtoZ sharedInstance];

}

@end
