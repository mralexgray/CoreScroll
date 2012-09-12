
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import	<AtoZ/AtoZ.h>
@class SFScrollPaneLayer;
@class SFScrollerLayer;
// used for mouse drag events
typedef enum {
	SFTimeLineViewUndefinedEventType = (1 << 1),
	SFTimeLineViewNotifyScrollerEventType = (1 << 2),
} 	SFTimeLineViewEventType;

@interface CustomView : NSView {
	SFScrollPaneLayer *bodyLayer;
	SFScrollerLayer* scrollerLayer;
	CALayer* mainLayer;
@private
NSGradient* bgGradient;
SFTimeLineViewEventType _currentMouseEventType;
}
@end
