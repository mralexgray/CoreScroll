
#import "SFSnapShotLayer.h"

#define SFBlackColor  CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor  CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)


#define YMARGIN 20.0 // JUST RIGHT
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
	root.bounds = CGRectMake(00, 00, 60, 30);
	root.layoutManager = [CAConstraintLayoutManager layoutManager];

	// Our container layer
	CALayer *contentLayer = [CALayer layer];
	root.contentLayer = contentLayer;
	contentLayer.anchorPoint = CGPointMake(0, 0);
	contentLayer.bounds = CGRectMake(00, 00, 60, 30);
	contentLayer.borderWidth = 2.0;
	contentLayer.borderColor = SFWhiteColor;
	contentLayer.backgroundColor = SFBlackColor;

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
	labelLayer.anchorPoint = CGPointMake(0, 0);

	labelLayer.string = @"Layer with some text";
//	labelLayer.bounds = CGRectMake(0, 0, contentLayer.bounds.size.w, contentLayer.bounds.size.height);
	labelLayer.frame = contentLayer.bounds;

//	CATextLayer* labelLayer = [CATextLayer layer];
//	labelLayer.string = @"r6";// [NSString stringWithFormat:@"%ld", snapshotNumber];
//	labelLayer.fontSize = 24;
//	labelLayer.foregroundColor = SFWhiteColor;
//	labelLayer.font = (__bridge CGFontRef)[NSFont fontWithName:@"Lucida Grande" size:24];
////(CFBridgingRetain(@"Lucida Grande");
	[labelLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
	[labelLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];


	[contentLayer addSublayer:labelLayer];
	[root setLabelLayer:labelLayer];
	[root addSublayer:contentLayer];


	//[contentLayer autorelease];
	return root;
}

- (void) setObjectRep:(id)objectRep {

	_objectRep = objectRep;
	imageLayer = [CALayer layer];
	

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
		[self startWiggling];
	} else {
		self.backgroundColor = SFBlackColor;
		_labelLayer.foregroundColor = SFWhiteColor;
		[self stopWiggling];
	}
}


- (void)startWiggling {
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
	anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05],
				   [NSNumber numberWithFloat:0.05],
				   nil];
	anim.duration = RAND_FLOAT_VAL(1,2);
	anim.autoreverses = YES;
	anim.repeatCount = HUGE_VALF;
	[self addAnimation:anim forKey:@"wiggleRotation"];

	anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
	anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1],
				   [NSNumber numberWithFloat:1],
				   nil];
	anim.duration = RAND_FLOAT_VAL(1,2);//0.07f + ((tileIndex % 10) * 0.01f);
	anim.autoreverses = YES;
	anim.repeatCount = HUGE_VALF;
	anim.additive = YES;
	[self addAnimation:anim forKey:@"wiggleTranslationY"];
}
- (void)stopWiggling {
	[self removeAnimationForKey:@"wiggleRotation"];
	[self removeAnimationForKey:@"wiggleTranslationY"];
}


@end
