
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import	<AtoZ/AtoZ.h>

@class AZScrollPaneLayer;
@class AZScrollerLayer;

// used for mouse drag events

typedef enum {
	AZTimeLineViewUndefinedEventType = (1 << 1),
	AZTimeLineViewNotifyScrollerEventType = (1 << 2),
} 	AZTimeLineViewEventType;


@interface AZCoreScrollView : NSView


@property (nonatomic, retain) AZScrollPaneLayer *bodyLayer;
@property (nonatomic, retain) AZScrollerLayer* scrollerLayer;
@property (nonatomic, retain) CALayer* mainLayer;

//@private
@property (nonatomic, retain) NSGradient* bgGradient;
@property (nonatomic, assign) AZTimeLineViewEventType currentMouseEventType;


@end
