/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
@interface MiscUtils : NSObject {
}
+ (NSRect)rectFromPointA:(NSPoint)pointA andPointB:(NSPoint)pointB;
+ (void) printRect:(NSRect)toPrint;
+ (void) printCGRect:(CGRect)cgRect;
+ (void) printPoint:(NSPoint)toPrint;
+ (void) printCGPoint:(CGPoint)cgPoint;
+ (void) printTransform:(CGAffineTransform)t;
+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect;
@end
NS_INLINE NSRect SFCopyRect(NSRect toCopy) {
	return NSMakeRect(toCopy.origin.x, toCopy.origin.y, 
										toCopy.size.width, toCopy.size.height);
}
NS_INLINE NSRect SFMakeRect(NSPoint origin, NSSize size) {
	return NSMakeRect(origin.x, origin.y, size.width, size.height);
}
NS_INLINE NSPoint SFCopyPoint(NSPoint toCopy) {
	return NSMakePoint(toCopy.x, toCopy.y);
}
static inline CGRect
convertToCGRect(NSRect rect)
{
	return *(const CGRect *)&rect;
}
static inline NSRect
convertToNSRect(CGRect rect)
{
	return *(const NSRect *)&rect;
}
static inline NSPoint
convertToNSPoint(CGPoint point)
{
	return *(const NSPoint *)&point;
}
static inline CGPoint
convertToCGPoint(NSPoint point)
{
	return *(const CGPoint *)&point;
}
