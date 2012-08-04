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
#import "CustomView.h"
#import <QuartzCore/QuartzCore.h>
#import "SFSnapShotLayer.h"
#import "SFTimeLineLayout.h"
#import "SFScrollPaneLayer.h"
#import "SFScrollerLayer.h"

#import "MiscUtils.h"

#define SFLeftArrowKey 123
#define SFRightArrowKey 124
#define SHIFT_ANIM_SPEED 2.0f

@interface CustomView (PrivateMethods)
- (void)setupLayers;
- (void)setupListeners;
- (void)moveSelection:(NSInteger)dx;
@end

@implementation CustomView

- (void)awakeFromNib {
	// draw a basic gradient for the view background
	NSColor* gradientBottom = [NSColor colorWithCalibratedWhite:0.10 alpha:1.0];
	NSColor* gradientTop= [NSColor colorWithCalibratedWhite:0.35 alpha:1.0];

	bgGradient = [[NSGradient alloc] initWithStartingColor:gradientBottom
											   endingColor:gradientTop];

	[self setupLayers];
	[self setupListeners];
}


- (void)setupLayers {
	CGRect viewFrame = NSRectToCGRect( self.frame );
	viewFrame.origin.y = 0;

	// create a layer and match its frame to the view's frame
	self.wantsLayer = YES;
	CALayer* mainLayer = self.layer;
	mainLayer.name = @"mainLayer";
	mainLayer.frame = viewFrame;
	mainLayer.delegate = self;

	// causes the layer content to be drawn in -drawRect:
	[mainLayer setNeedsDisplay];


	CGFloat midX = CGRectGetMidX( mainLayer.frame );
	CGFloat midY = CGRectGetMidY( mainLayer.frame );

	// create a "container" layer for all content layers.
	// same frame as the view's master layer, automatically
	// resizes as necessary.
	CALayer* contentContainer = [CALayer layer];
	contentContainer.bounds = mainLayer.bounds;
	contentContainer.delegate = self;
	contentContainer.anchorPoint= CGPointMake(0.5,0.5);
	contentContainer.position = CGPointMake( midX, midY );
	contentContainer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	[contentContainer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
	[self.layer addSublayer:contentContainer];


	scrollerLayer = [SFScrollerLayer layer];
	scrollerLayer.name = @"scroller";
	[scrollerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY offset:10]];
	[scrollerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMinY offset:10 + SCROLLER_HEIGHT]];


	bodyLayer = [SFScrollPaneLayer layer];
	bodyLayer.borderWidth = 0.0;
	bodyLayer.name = @"scrollLayer";
	bodyLayer.scrollMode = kCAScrollHorizontally;
	bodyLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	[bodyLayer setLayoutManager:[SFTimeLineLayout layoutManager]];
	[bodyLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
	[bodyLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth offset:-20]];
	[bodyLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"scroller" attribute:kCAConstraintMaxY offset:10]];
	[bodyLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY offset:-10]];




	// TODO -- SFScrollLayer -- has reference to site and listens for change methods
	int i;
	for ( i = 0; i < 200; i++ ) {
		[bodyLayer addSublayer:[SFSnapShotLayer rootSnapshot]];
	}


	[scrollerLayer setScrollerContent:bodyLayer];
	[bodyLayer setContentController:scrollerLayer];

	[contentContainer addSublayer:bodyLayer];
	[contentContainer addSublayer:scrollerLayer];

	[contentContainer layoutSublayers];
	[contentContainer layoutIfNeeded];

	[bodyLayer selectSnapShot:0];
}


- (void)setupListeners {

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appNoLongerActive:)
												 name:NSApplicationWillResignActiveNotification
											   object:[NSApplication sharedApplication]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive:)
												 name:NSApplicationWillBecomeActiveNotification
											   object:[NSApplication sharedApplication]];

}

#pragma mark -
#pragma mark NSView Methods

- (void)drawRect:(NSRect)rect {
	// Everything else is handled by core animation
	[bgGradient drawInRect:self.bounds angle:90.0];
}




#pragma mark -
#pragma mark NSResponder Methods

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)e {

	// every app with eye candy needs a slow mode invoked by the shift key
	if ([e modifierFlags] & (NSAlphaShiftKeyMask|NSShiftKeyMask))
		[CATransaction setValue:@SHIFT_ANIM_SPEED forKey:@"animationDuration"];

	switch ([e keyCode])
	{
		case SFLeftArrowKey:
			[self moveSelection:-1];
			break;

		case SFRightArrowKey:
			[self moveSelection:+1];
			break;
		default:
			NSLog (@"unhandled key event: %d\n", [e keyCode]);
			[super keyDown:e];
	}
}

- (void) mouseDown: (NSEvent *) event {
	NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
	CGPoint cgLocation = NSPointToCGPoint(location);

	if ([event modifierFlags] & (NSAlphaShiftKeyMask|NSShiftKeyMask))
		[CATransaction setValue:@SHIFT_ANIM_SPEED forKey:@"animationDuration"];


	if ( CGRectContainsPoint ( bodyLayer.frame, cgLocation )) {
		[bodyLayer mouseDownAtPointInSuperlayer:cgLocation];
		return;
	}

	if ( CGRectContainsPoint ( scrollerLayer.frame, cgLocation ) ) {
		if( [scrollerLayer mouseDownAtPointInSuperlayer:cgLocation] ) {
			_currentMouseEventType = SFTimeLineViewNotifyScrollerEventType;
		}
		return;
	}

}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	CGPoint cgLocation = NSPointToCGPoint(location);

	if ( _currentMouseEventType == SFTimeLineViewNotifyScrollerEventType ) {
		[scrollerLayer mouseDragged:cgLocation];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	CGPoint cgLocation = NSPointToCGPoint(location);

	if ( _currentMouseEventType == SFTimeLineViewNotifyScrollerEventType ) {
		[scrollerLayer mouseUp:cgLocation];
	}

	_currentMouseEventType = SFTimeLineViewUndefinedEventType;
}

- (void)scrollWheel:(NSEvent *)theEvent {
	[scrollerLayer moveSlider:-[theEvent deltaX] ];
}


#pragma mark -
#pragma mark Listener Methods

- (void) appNoLongerActive:(NSNotification*)notification {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	[scrollerLayer setOpacity:0.7];
	[bodyLayer setOpacity:0.7];
}

- (void) appBecameActive:(NSNotification*)notification {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	[scrollerLayer setOpacity:1.0];
	[bodyLayer setOpacity:1.0];
}



#pragma mark -
#pragma mark private methods

- (void)moveSelection:(NSInteger)dx {
	[bodyLayer moveSelection:dx];
}


@end
