//
//  DrawView.m
//  MaskTest
//
//  Created by Sean Christmann on 12/22/08.
//  Copyright 2008 EffectiveUI. All rights reserved.
//

#import "DrawView.h"


@implementation DrawView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor =[UIColor orangeColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0.05, 0.25, 0.5, 1.0);
	CGContextSetLineWidth(context, 1.0);
	int i = 0;
	while(i < 101){
		CGContextMoveToPoint(context, 0, i);
		CGContextAddLineToPoint(context, 320, i);
		CGContextStrokePath(context);
		i += 20;
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
