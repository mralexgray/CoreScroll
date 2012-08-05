/* 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted 
 provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of 
 conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice, this list of 
 conditions and the following disclaimer in the documentation and/or other materials 
 provided with the distribution.
 
 - Neither the name of the "Preen and Prune Group", "Allusions Software" nor the names of its contributors may be 
 used to endorse or promote products derived from this software without specific prior 
 written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 
 Prune and Preen Ware. 
 
 If you find this kode useful I welcome you to toss an email in the general direction
 of matthieu.cormier@gmail.com
 
 
 */
#import "MiscUtils.h"

@implementation MiscUtils

+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect {

NSImage* cropImage = [[NSImage alloc] initWithSize:NSMakeSize(sourceRect.size.width, sourceRect.size.height)];
[cropImage lockFocus]; {
[sourceImage drawInRect:NSMakeRect(0, 0, sourceRect.size.width, sourceRect.size.height)
 fromRect:sourceRect 
operation:NSCompositeSourceOver fraction:1.0];
}
[cropImage unlockFocus];

//[cropImage autorelease];
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
if ( pointB.x < pointA.x ) {
returnRect.origin.x= pointA.x + xDistance;
returnRect.size.width= fabs(xDistance);
} else {
returnRect.origin.x= pointA.x;
returnRect.size.width= xDistance;
}

if ( pointB.y < pointA.y ) {
returnRect.origin.y= pointA.y + yDistance;
returnRect.size.height = fabs(yDistance);
} else {
returnRect.origin.y= pointA.y;
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
