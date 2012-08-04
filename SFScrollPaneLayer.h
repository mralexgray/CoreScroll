#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "SFScrollerProtocols.h"


// - assumes the layout manager is a SFTimeLineLayout
// - assumes all sublayers are SFSnapShotLayers

@interface SFScrollPaneLayer : CAScrollLayer < SFScrollerContent > {

BOOL selectionAnim;

__unsafe_unretained id <SFScrollerContentController> _contentController;


CGFloat contentWidth;
CGFloat visibleWidth;
CGFloat stepSize;
}

@property(assign) id <SFScrollerContentController> contentController;

- (void)selectSnapShot:(NSInteger)index;
- (void)moveSelection:(NSInteger)dx;
- (void)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint;
@end
