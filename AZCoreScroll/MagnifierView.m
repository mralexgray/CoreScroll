//
//  CustomView.m
//  MaskTest
//
//  Created by Sean Christmann on 12/22/08.
//  Copyright 2008 EffectiveUI. All rights reserved.
//

#import "MagnifierView.h"

@implementation MagnifierView
@synthesize viewref, touchPoint;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
//		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	printf("draw magnifying glass\n");
	if(cachedImage == nil){
//		UIGraphicsBeginImageContext(self.bounds.size);
//		[self.viewref.layer renderInContext:UIGraphicsGetCurrentContext()];
//		cachedImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
//		UIGraphicsEndImageContext();
	}
//	CGImageRef imageRef = [cachedImage CGImage];
//	CGImageRef maskRef = [[UIImage imageNamed:@"loopmask.png"] CGImage];
//	CGImageRef overlay = [[UIImage imageNamed:@"loop.png"] CGImage];
//	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), 
//										CGImageGetHeight(maskRef),
//										CGImageGetBitsPerComponent(maskRef), 
//										CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef), 
//										CGImageGetDataProvider(maskRef), 
//										NULL, 
//										true);
//	//Create Mask
//	CGImageRef subImage = CGImageCreateWithImageInRect(imageRef, CGRectMake(touchPoint.x-18, touchPoint.y-18, 36, 36));
//	CGImageRef xMaskedImage = CGImageCreateWithMask(<#CGImageRef image#>, <#CGImageRef mask#>)(subImage, mask);
//
	// Draw the image
	// Retrieve the graphics context
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGAffineTransform xform = CGAffineTransformMake(
//													1.0,  0.0,
//													0.0, -1.0,
//													0.0,  0.0);
//	CGContextConcatCTM(context, xform);
//	CGRect area = CGRectMake(touchPoint.x-42, -touchPoint.y, 85, 85);
//	CGRect area2 = CGRectMake(touchPoint.x-40, -touchPoint.y+2, 80, 80);
//	
//	CGContextDrawImage(context, area2, xMaskedImage);
//	CGContextDrawImage(context, area, overlay);
}


//- (void)dealloc {
//	[cachedImage release];
//	[viewref release];
//    [super dealloc];
//}


@end
