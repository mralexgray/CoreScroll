
#import "AZSnapShotLayer.h"
#import <CoreText/CoreText.h>
#import <AtoZ/AtoZ.h>
#import <FunSize/FunSize.h>

#define SFBlackColor	CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor	CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)

//#define YMARGIN 20.0 // JUST RIGHT
//#define XMARGIN 0.0//30.0

@implementation AZSnapShotLayer	{	CGGradientRef backgroundGradient;	}
static NSInteger snapshotNumber;

@synthesize trannyLayer, constrainLayer, imageLayer, gradLayer;

+ (AZSnapShotLayer*)rootSnapshot
{
	AZSnapShotLayer *root 		= [[[self class] alloc] init];
	root.anchorPoint 			= CGPointMake(.5,.5);
	root.bounds 				= CGRectMake(0, 0,1, 1);
	root.layoutManager 			= [CAConstraintLayoutManager layoutManager];
	root.autoresizingMask 		= kCALayerHeightSizable | kCALayerWidthSizable;
	CALayer *contentLayer 		= ReturnLayer(root);//[CALayer layer];				// Our container layer
	root.contentLayer 			= contentLayer;
//	contentLayer.anchorPoint 	= CGPointMake(0, 0);
//	contentLayer.bounds 		= CGRectMake(00, 00, 50, 50);
//	contentLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//				.borderWidth 	= 2.0;
//				.borderColor 	= SFWhiteColor;
//				.backgroundColor = SFBlackColor;

//				.constraints = @[ AZConstRelSuper(kCAConstraintHeight), AZConstRelSuper(kCAConstraintWidth) ];
	snapshotNumber++;
	CATextLayer* labelLayer 		= [CATextLayer layer];
	labelLayer.style 			= @{	@"font" 			: @"Ubuntu Mono Bold",
										@"alignmentMode"		: kCAAlignmentCenter,
										@"fontSize"			: @(200),
										@"wrapped" 			: @(NO),			};
	labelLayer.delegate = self;
	labelLayer.foregroundColor 	= CGColorCreateGenericRGB(1, 1, 1, 1);
//	[labelLayer addConstraintsSuperSize];
	[labelLayer addConstraints:@[	AZConstRelSuper(kCAConstraintMinX),
									AZConstRelSuper(kCAConstraintHeight),
									AZConstRelSuper(kCAConstraintWidth)]];
	labelLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//	labelLayer.frame = contentLayer.bounds;
//	labelLayer.position = CGPointrMake(50, 20+i*50);
//	labelLayer.anchorPoint = AZCenterOfRect(contentLayer.bounds);
//	labelLayer.bounds = CGRectMake(0, 0, contentLayer.bounds.size.w, contentLayer.bounds.size.height);
	// The selection layer will pulse continuously.
	// This is accomplished by setting a bloom filter on the layer
	AddBloom(labelLayer);
	AddShadow(labelLayer);
	// create the animation that will handle the pulsing.
	CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
	// the attribute we want to animate is the inputIntensity	of the pulseFilter
	pulseAnimation.keyPath 			= @"filters.pulseFilter.inputIntensity";
	// we want it to animate from the value 0 to 1
	pulseAnimation.fromValue 		= @(0.0);
	pulseAnimation.toValue 			= @(4.5);
	// over a one second duration, and run an infinite number of times
	pulseAnimation.duration 			= 1.0;
	pulseAnimation.repeatCount 		= HUGE_VALF;
	// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity	input to go from 0 to 1 to 0
	pulseAnimation.autoreverses 	= YES;
	// use a timing curve of easy in, easy out..
	pulseAnimation.timingFunction 	= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
	[labelLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	labelLayer.zPosition = 23;
	[contentLayer addSublayer:labelLayer];

	[root setLabelLayer:labelLayer];
	[root addSublayer:contentLayer];
	return root;
}

- (void)didChangeValueForKey:(NSString *)key {
		if ([key isEqualToString:@"bounds"] || [key isEqualToString:@"frame"]) {
		_labelLayer.fontSize = _labelLayer.bounds.size.height;
//		 setNeedsLayout];
	}
	[super didChangeValueForKey:key];
}

- (void) setObjectRep:(id)objectRep {

	_objectRep = objectRep;
	self.imageLayer = [CALayer layer];
	imageLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	imageLayer.constraints = @[
								AZConstScaleOff(kCAConstraintWidth, @"superlayer", .7, 0),
								AZConstScaleOff(kCAConstraintMaxX, 	@"superlayer", .9,0),
								AZConst(kCAConstraintMidY, 	@"superlayer")	];


	NSImage *i = [objectRep valueForKey:@"image"];
	i.scalesWhenResized	= YES;
	i.size				= AZSizeFromDimension(512);
	imageLayer.contents = i;// [[objectRep valueForKey:@"image"];//imageScaledToFitSize:contentLayer.bounds.size];


	CIFilter *filter = [CIFilter filterWithName:@"CIEdges"];
//	[filter setValue:i forKey:@"inputImage"];
	[filter setValue:[NSNumber numberWithFloat:4.0] forKey:@"inputIntensity"];
//	CIImage *imageToDraw = [filter valueForKey:@"outputImage"];
//	filter.name			= @"edges";
	imageLayer.filters 	= @[filter];

	imageLayer.contentsGravity = kCAGravityResizeAspect;

	[self.contentLayer addSublayer:imageLayer];
	self.mask = imageLayer;
	_labelLayer.string = [[objectRep valueForKey:@"name"] firstLetter];
	NSLog(@"set objectRepcomplete for:%@",[objectRep valueForKey:@"name"]);

}

- (CALayer *) gradLayer {

	size_t num_locations = 3;
	CGFloat locations[3] = { 0.0, 0.7, 1.0 };
	CGFloat components[12] = {	0.0, 0.0, 0.0, 1.0,      0.5, 0.7, 1.0, 1.0,	1.0, 1.0, 1.0, 1.0 };
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
- (void) setSelected:(BOOL)selected {
	_selected = selected;
	if(!_selected) {
		CAShapeLayer * l = [self lassoLayerForLayer:self];
		l.name = @"lasso";
		[self addSublayer:l];
		[self flipDown];
		NSBeep();
//		[self flipDown];
		self.mask = imageLayer;
		_labelLayer.hidden = YES;
//		.backgroundColor = SFWhiteColor;
//		_labelLayer.foregroundColor = SFBlackColor;
	} else {
		self.mask = nil;
		_labelLayer.hidden = NO;
		[self sublayersBlockSkippingSelf:^(CALayer *layer) {
			if ([layer.name isEqualToString:@"lasso"]) [layer removeFromSuperlayer];
		}];
		[self flipBack];
//		self.backgroundColor = SFBlackColor;
		_labelLayer.foregroundColor = SFWhiteColor;
	}
}


@end
