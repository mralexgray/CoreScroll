/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <AtoZ/AtoZ.h>

//@class SFScrollPaneLayer;
//@class SFScrollerLayer;
// used for mouse drag events
typedef enum {	SFTimeLineViewUndefinedEventType = (1 << 1),
					SFTimeLineViewNotifyScrollerEventType = (1 << 2),
} SFTimeLineViewEventType;

@interface CustomView : NSView 
@property (strong) AZScrollPaneLayer *bodyLayer;  // 	SFScrollPaneLayer *bodyLayer;
@property(strong)	CALayer* rootBox;
@property (strong) AZScrollerLayer *scrollerLayer;	// SFScrollerLayer* scrollerLayer;
@end
