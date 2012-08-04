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
#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

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
