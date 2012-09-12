//
//  CustomView.h
//  MaskTest
//
//  Created by Sean Christmann on 12/22/08.
//  Copyright 2008 EffectiveUI. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface MagnifierView : NSView {
	NSView *viewref;
	CGPoint touchPoint;
	NSImage *cachedImage;
}
@property(nonatomic, retain) NSView *viewref;
@property(assign) CGPoint touchPoint;
@end
