
#import "SFSnapShotLayer.h"
#define SFBlackColor  CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor  CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)

#define YMARGIN 40.0 // JUST RIGHT
#define XMARGIN 0.0//30.0
@implementation SFSnapShotLayer {
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
	contentLayer.constraints = @[ AZConstRelSuper(kCAConstraintHeight), AZConstRelSuper(kCAConstraintWidth) ];
	snapshotNumber++;
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
	imageLayer.constraints = @[ AZConstScaleOff(kCAConstraintWidth, @"superlayer",.5,0),
//								AZConstScaleOff(kCAConstraintMaxX, 	@"superlayer", .9,0),
								AZConstRelSuper(kCAConstraintMidX ),
								AZConstRelSuper(kCAConstraintMidY )	];
	NSImage *i = [objectRep valueForKey:@"image"];
	[i setScalesWhenResized:YES];
	[i setSize:NSMakeSize(512,512)];
	imageLayer.contents = i;// [[objectRep valueForKey:@"image"];//imageScaledToFitSize:contentLayer.bounds.size];
	imageLayer.contentsGravity = kCAGravityResizeAspect;
	[self.contentLayer addSublayer:imageLayer];
	NSDictionary* textStyle = @{@"Ubuntu Mono Bold" : @"font", kCAAlignmentCenter : @"alignmentMode"};
	CATextLayer* labelLayer = [CATextLayer layer];
	labelLayer.fontSize = contentLayer.bounds.size.height;
//	labelLayer.frame = contentLayer.bounds;
	labelLayer.style = textStyle;
	labelLayer.foregroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
//	labelLayer.position = CGPointrMake(50, 20+i*50);
//	labelLayer.anchorPoint = AZCenterOfRect(contentLayer.bounds);
	labelLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//	labelLayer.string = @"stub";
//	labelLayer.bounds = CGRectMake(0, 0, contentLayer.bounds.size.w, contentLayer.bounds.size.height);
//	labelLayer.frame = contentLayer.bounds;

	_labelLayer.string = [[objectRep valueForKey:@"name"] substringWithRange:NSMakeRange(0, 1)];
	NSLog(@"set objectRepcomplete for:%@",[objectRep valueForKey:@"name"]);

	// The selection layer will pulse continuously.
	// This is accomplished by setting a bloom filter on the layer
	// create the filter and set its default values
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
	// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
	[filter setName:@"pulseFilter"];
	// set the filter to the selection layer's filters
	[labelLayer setFilters:[NSArray arrayWithObject:filter]];
	// create the animation that will handle the pulsing.
	CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
	// the attribute we want to animate is the inputIntensity  of the pulseFilter
	pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
	// we want it to animate from the value 0 to 1
	pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
	pulseAnimation.toValue = [NSNumber numberWithFloat: 1.5];
	// over a one second duration, and run an infinite number of times
	pulseAnimation.duration = 1.0;
	pulseAnimation.repeatCount = HUGE_VALF;
	// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity  input to go from 0 to 1 to 0
	pulseAnimation.autoreverses = YES;
	// use a timing curve of easy in, easy out..
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
	[labelLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];

	labelLayer.constraints = $array(	AZConst(kCAConstraintHeight, @"superlayer"),AZConst(kCAConstraintWidth, @"superlayer"), AZConst(kCAConstraintMidX, @"superlayer"), AZConst(kCAConstraintMidY, @"superlayer"));

	[contentLayer addSublayer:labelLayer];
	self.labelLayer = labelLayer;

}
- (CALayer *) gradLayer {

	size_t num_locations = 3;
	CGFloat locations[3] = { 0.0, 0.7, 1.0 };
	CGFloat components[12] = {	0.0, 0.0, 0.0, 1.0,		0.5, 0.7, 1.0, 1.0,		1.0, 1.0, 1.0, 1.0 };
	
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
	if(_isSelected) {	self.backgroundColor = SFWhiteColor; _labelLayer.foregroundColor = SFBlackColor; }
	else 			{	self.backgroundColor = SFBlackColor; _labelLayer.foregroundColor = SFWhiteColor; }
}

@end
