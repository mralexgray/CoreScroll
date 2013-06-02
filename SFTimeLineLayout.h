/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
/* Layer attributes:
		selectedSnapShot		NSNumber<int>
 
	Sublayer attributes:
		none 
*/
#define YMARGIN 30
#define XMARGIN 30
extern NSString *selectedSnapShot;
@interface SFTimeLineLayout : NSObject {
}
+ (id)layoutManager;
- (CGPoint)scrollPointForSelected:(CALayer *)layer;
@end
