/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import "SFSnapShotLayer.h"
#define SFBlackColor	CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor	CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)
#define YMARGIN 20.0
#define XMARGIN 30.0
@implementation SFSnapShotLayer
static NSInteger snapshotNumber;
@synthesize isSelected=_isSelected;
@synthesize labelLayer=_labelLayer;
// TODO -- rename method
+ (SFSnapShotLayer*)rootSnapshot {
	SFSnapShotLayer* contentLayer = [[[self class] alloc] init];
	contentLayer.bounds = CGRectMake(00, 00, 60, 30);
	contentLayer.anchorPoint = CGPointMake(0.0, 0.0);
	contentLayer.borderWidth = 2.0;
	contentLayer.borderColor = SFWhiteColor;
	contentLayer.backgroundColor = SFBlackColor;
	contentLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	snapshotNumber++;
	CATextLayer* labelLayer = [CATextLayer layer];
	labelLayer.string = [NSString stringWithFormat:@"%li", (long)snapshotNumber];
	labelLayer.fontSize = 24;
	labelLayer.foregroundColor = SFWhiteColor;
	labelLayer.font = @"Lucida Grande";
	[labelLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
	[labelLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
	[contentLayer addSublayer:labelLayer];
	[contentLayer setLabelLayer:labelLayer];
	
	[contentLayer autorelease];
	return contentLayer;
}
- (void) setIsSelected:(BOOL)isSelected {
	_isSelected = isSelected;
	if(_isSelected) {
		self.backgroundColor = SFWhiteColor;
		_labelLayer.foregroundColor = SFBlackColor;
	} else {
		self.backgroundColor = SFBlackColor;		
		_labelLayer.foregroundColor = SFWhiteColor;
	}
}
@end
