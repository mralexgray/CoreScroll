/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@interface SFSnapShotLayer : CALayer 
+ (SFSnapShotLayer*) rootSnapshot;
@property(nonatomic) CATextLayer* labelLayer;
@property(nonatomic) BOOL isSelected;
@end