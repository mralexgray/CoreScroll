//
//  DrawView.m
//  MaskTest
//
//  Created by Sean Christmann on 12/22/08.
//  Copyright 2008 EffectiveUI. All rights reserved.
//

#import "DrawView.h"
#import <AtoZ/AtoZ.h>

//#import "AtoZ.h"

@implementation DrawView
{
	NSImage *o;
	NSPoint p;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.wantsLayer = YES;
		self.layer.zPosition = 10000;
		[self trackFullView];
		p = NSZeroPoint;
    }
    return self;
}

- (void) mouseMoved:(NSEvent *)theEvent{

	p = theEvent.locationInWindow;
	[self setNeedsDisplay:YES];

}

- (BOOL) isFlipped {	return  NO;		}

- (void)drawRect:(NSRect)dirtyRect {
//	[super drawRect:rect];
//	CGContextRef context = [[NSGraphicsContext currentContext]graphicsPort];//UIGraphicsGetCurrentContext();
//	[NSGraphicsContext saveGraphicsState];
	[GREEN set];
	NSRectFill([self frame]);
	NSBezierPath *pp = [NSBezierPath bezierPathWithRect:[self frame]];
	pp.lineWidth = 30;
	[YELLOw set];
	[pp stroke];
	if (!o) o 	= [NSImage randomIcon];
	[o drawAtPoint:p fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];


	
//	[NSGraphicsContext restoreGraphicsState];
//	CGContextSe/tRGBStrokeColor(context, 0.05, 0.25, 0.5, 1.0);
//	CGContextSetLineWidth(context, 1.0);
//	int i = 0;
//	while(i < 101){
//		CGContextMoveToPoint(context, 0, i);
//		CGContextAddLineToPoint(context, 320, i);
//		CGContextStrokePath(context);
//		i += 20;
//	}
}


//- (void)dealloc {
//    [super dealloc];
//}
//

@end
