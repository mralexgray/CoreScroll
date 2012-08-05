
#import "SFSnapShotLayer.h"

#define SFBlackColor  CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor  CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)


#define YMARGIN 0.0 // JUST RIGHT
#define XMARGIN 0.0//30.0

@implementation SFSnapShotLayer
{

	CGGradientRef backgroundGradient;

}
static NSInteger snapshotNumber;


@synthesize isSelected	= _isSelected;
@synthesize labelLayer 	= _labelLayer;
@synthesize objectRep 	= _objectRep;
@synthesize trannyLayer, constrainLayer, contentLayer, imageLayer, gradLayer;


// TODO -- rename method
+ (SFSnapShotLayer*)rootSnapshot {



	SFSnapShotLayer *root = [[[self class] alloc] init];
	root.anchorPoint = CGPointMake(0, 0);
	root.bounds = CGRectMake(00, 00, 50, 50);
	root.layoutManager = [CAConstraintLayoutManager layoutManager];
//	root.constraints = $array(	AZConst(kCAConstraintHeight, @"superlayer"),AZConst(kCAConstraintWidth, @"superlayer"));
	root.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	// Our container layer
	CALayer *contentLayer = [CALayer layer];
	root.contentLayer = contentLayer;
	contentLayer.anchorPoint = CGPointMake(0, 0);
	contentLayer.bounds = CGRectMake(00, 00, 50, 50);
	contentLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	contentLayer.borderWidth = 2.0;
	contentLayer.borderColor = SFWhiteColor;
	contentLayer.backgroundColor = SFBlackColor;
	contentLayer.backgroundColor = SFBlackColor;
	contentLayer.constraints = $array(	AZConst(kCAConstraintHeight, @"superlayer"),AZConst(kCAConstraintWidth, @"superlayer"));
	snapshotNumber++;
	NSDictionary* textStyle = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"Ubuntu Mono Bold", @"font",
							   kCAAlignmentLeft, @"alignmentMode",
							   nil];

	CATextLayer* labelLayer = [CATextLayer layer];
	labelLayer.fontSize = 40;
	labelLayer.style = textStyle;
	labelLayer.foregroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
//	labelLayer.position = CGPointrMake(50, 20+i*50);
	labelLayer.anchorPoint = AZCenterOfRect(contentLayer.bounds);
	labelLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;

	labelLayer.string = @"stub";
//	labelLayer.bounds = CGRectMake(0, 0, contentLayer.bounds.size.w, contentLayer.bounds.size.height);
	labelLayer.frame = contentLayer.bounds;

//	CATextLayer* labelLayer = [CATextLayer layer];
//	labelLayer.string = @"r6";// [NSString stringWithFormat:@"%ld", snapshotNumber];
//	labelLayer.fontSize = 24;
//	labelLayer.foregroundColor = SFWhiteColor;
//	labelLayer.font = (__bridge CGFontRef)[NSFont fontWithName:@"Lucida Grande" size:24];
////(CFBridgingRetain(@"Lucida Grande");
	labelLayer.constraints = $array(	AZConst(kCAConstraintHeight, @"superlayer"),AZConst(kCAConstraintWidth, @"superlayer"), AZConst(kCAConstraintMidX, @"superlayer"), AZConst(kCAConstraintMidY, @"superlayer"));


	[contentLayer addSublayer:labelLayer];
	[root setLabelLayer:labelLayer];
	[root addSublayer:contentLayer];


	//[contentLayer autorelease];
	return root;
}

- (void) setObjectRep:(id)objectRep {

	_objectRep = objectRep;
	self.imageLayer = [CALayer layer];
//	imageLayer.frame = self.contentLayer.bounds;
//	imageLayer.position = CGPointMake(1,0);
	imageLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	imageLayer.constraints = @[
								AZConstScaleOff(kCAConstraintWidth, @"superlayer",.5,0),
								AZConstScaleOff(kCAConstraintMaxX, 	@"superlayer", .9,0),
								AZConst(kCAConstraintMidY, 	@"superlayer")	];


	imageLayer.contents = [[objectRep valueForKey:@"image"]coloredWithColor:WHITE];
	imageLayer.contentsGravity = kCAGravityResizeAspect;
	[self.contentLayer addSublayer:imageLayer];
	_labelLayer.string = [[objectRep valueForKey:@"name"] substringWithRange:NSMakeRange(0, 1)];
	NSLog(@"set objectRepcomplete for:%@",[objectRep valueForKey:@"name"]);

}

- (CALayer *) gradLayer {


	size_t num_locations = 3;
	CGFloat locations[3] = { 0.0, 0.7, 1.0 };
	CGFloat components[12] = {	0.0, 0.0, 0.0, 1.0,
		0.5, 0.7, 1.0, 1.0,
		1.0, 1.0, 1.0, 1.0 };
	
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	backgroundGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);

	CGSize b = self.bounds.size;
	
	NSImage* compositeImage = [[NSImage alloc] initWithSize:b];

    [compositeImage lockFocus];

	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextDrawRadialGradient(ctx, backgroundGradient,
								CGPointMake(b.width/2, b.height), b.width,
								CGPointMake(b.width/2, -b.height/2), 0,
								kCGGradientDrawsAfterEndLocation);



	return gradLayer;
}
- (void) setIsSeleczted:(BOOL)isSelected {
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
