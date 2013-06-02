/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SFScrollerProtocols.h"
// - assumes the layout manager is a SFTimeLineLayout
// - assumes all sublayers are SFSnapShotLayers
@interface SFScrollPaneLayer : CAScrollLayer < SFScrollerContent > 

@property	     BOOL selectionAnim;
@property     CGFloat contentWidth, visibleWidth, stepSize;
@property (assign) id <SFScrollerContentController> contentController;

- (void)selectSnapShot:				  (NSInteger)index;
- (void)moveSelection:				  (NSInteger)dx;
- (void)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint;

@end
