/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
@class SFScrollPaneLayer;
@class SFScrollerLayer;
// used for mouse drag events
typedef enum {	SFTimeLineViewUndefinedEventType = (1 << 1),
					SFTimeLineViewNotifyScrollerEventType = (1 << 2),
} SFTimeLineViewEventType;

@interface CustomView : NSView 
@property	SFScrollPaneLayer *bodyLayer;
@property	CALayer* rootBox;
@property SFScrollerLayer* scrollerLayer;
@end
