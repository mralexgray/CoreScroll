/*   
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@interface SFSnapShotLayer : CALayer {
	@private
  BOOL _isSelected;
  CATextLayer* _labelLayer;  
}
+ (SFSnapShotLayer*)rootSnapshot;
@property(assign) CATextLayer* labelLayer;
@property BOOL isSelected;
@end