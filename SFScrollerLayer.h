/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SFScrollerProtocols.h"
#define SCROLLER_HEIGHT 16.0 // The default height
typedef enum {
	SFNoInput = (1 << 1),
	SFLeftArrowInput = (1 << 2),
	SFRightArrowInput = (1 << 3),
	SFSliderInput = (1 << 4),
	SFTrayInputLeft = (1 << 5),
	SFTrayInputRight = (1 << 6),	
} SFScrollerMouseDownInput;
@interface SFScrollerLayer : CALayer < SFScrollerContentController > {
	CALayer* leftArrow;
	CALayer* leftArrowHighlight;
	CALayer* rightArrow;
	CALayer* rightArrowHighlight;
	CALayer* tray;
	CALayer* slider;
	id <SFScrollerContent> _scrollerContent;
	// -------- Event variables --------------
	SFScrollerMouseDownInput _inputMode;
	CGPoint _mouseDownPointForCurrentEvent;
	BOOL _mouseOverSelectedInput;
	NSTimer* mouseDownTimer;
}
@property(assign) id <SFScrollerContent> scrollerContent;
// returns YES if the scroller should be notified of mouse 
// dragged and mouse up notifications
- (BOOL)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint;
- (void)mouseDragged:(CGPoint)inputPoint;
- (void)mouseUp:(CGPoint)inputPoint;
- (void)moveSlider:(CGFloat)dx;
@end
