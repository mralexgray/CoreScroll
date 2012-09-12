//
//  CustomView.h
//  MaskTest
//
//  Created by Sean Christmann on 12/22/08.
//  Copyright 2008 EffectiveUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface MagnifierView : UIView {
	UIView *viewref;
	CGPoint touchPoint;
	UIImage *cachedImage;
}
@property(nonatomic, retain) UIView *viewref;
@property(assign) CGPoint touchPoint;
@end
