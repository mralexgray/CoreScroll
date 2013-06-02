/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import "MiscUtils.h"
@implementation MiscUtils
+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect {
	NSImage* cropImage = [[NSImage alloc] initWithSize:NSMakeSize(sourceRect.size.width, sourceRect.size.height)];
	[cropImage lockFocus];
	{
		[sourceImage drawInRect:NSMakeRect(0, 0, sourceRect.size.width, sourceRect.size.height)
									 fromRect:sourceRect 
									operation:NSCompositeSourceOver fraction:1.0];
	}
	[cropImage unlockFocus];
	[cropImage autorelease];
	return cropImage;
}
+ (NSRect) rectFromPointA:(NSPoint)pointA andPointB:(NSPoint)pointB {
	// get the current distance from the original mouse down point
	float xDistance = pointB.x - pointA.x;
	float yDistance = pointB.y - pointA.y;
	// we need to create the selection rect, but the calculation is
	// different depending on whether the mouse has been dragged
	// up and/or to the left (lower coordinate values) or down and
	// to the right (higher coordinate values). 
	NSRect returnRect;
	if ( pointB.x < pointA.x )
	{
		returnRect.origin.x		= pointA.x + xDistance;
		returnRect.size.width	= fabs(xDistance);
	} else {
		returnRect.origin.x		= pointA.x;
		returnRect.size.width	= xDistance;
	}
	if ( pointB.y < pointA.y )
	{
		returnRect.origin.y		= pointA.y + yDistance;
		returnRect.size.height = fabs(yDistance);
	} else {
		returnRect.origin.y		= pointA.y;
		returnRect.size.height = yDistance;
	}
	return returnRect;
}
+ (void)printCGRect:(CGRect)cgRect {
	[MiscUtils printRect: convertToNSRect(cgRect)];
}
+ (void) printRect:(NSRect)toPrint {
	NSLog(@"Rect is x: %i y: %i width: %i height: %i ", (int)toPrint.origin.x, (int)toPrint.origin.y,
				(int)toPrint.size.width, (int)toPrint.size.height);	
}
+ (void) printCGPoint:(CGPoint)cgPoint {
	[MiscUtils printPoint:convertToNSPoint(cgPoint)];
}
+ (void) printPoint:(NSPoint)toPrint {
	NSLog(@"Point is x: %f y: %f", toPrint.x, toPrint.y);
}
+ (void) printTransform:(CGAffineTransform)t {
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.a, t.b);
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.c, t.d);
	NSLog(@"[ %1.1f %1.1f 1.0 ]", t.tx, t.ty);	
}
@end
