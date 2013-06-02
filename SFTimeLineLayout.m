/*	 
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.

 */
#import "SFTimeLineLayout.h"
#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
NSString *selectedSnapShot = @"selectedSnapShot";
@implementation SFTimeLineLayout
static SFTimeLineLayout *sharedLayoutManager;
+ (id)layoutManager { return sharedLayoutManager = sharedLayoutManager ?: self.new;	}

- (CGPoint)scrollPointForSelected:(CALayer *)layer {
	NSNumber *number = [layer valueForKey:selectedSnapShot];
	int selectedIndex = number != nil ? [number integerValue] : 0;
	NSInteger totalSnapShots = layer.sublayers.count;
	CALayer* snapShot = layer.sublayers[selectedIndex];
	CALayer* lastShot = layer.sublayers[totalSnapShots - 1];
	CALayer* firstShot = layer.sublayers[0];
		
	// What will the visible rect be if we center the selected snapshot? 
	CGRect selectedRect = snapShot.frame;
	CGFloat newXOrigin = (selectedRect.origin.x	+ selectedRect.size.width * 0.5) - [layer visibleRect].size.width * 0.5;	 
	CGRect newVisRect = CGRectMake(newXOrigin, 0, [layer visibleRect].size.width, [layer visibleRect].size.height);
		
	// If the first snapshot is in the new visible rect, anchor to the beginning. 
	if ( CGRectIntersectsRect(firstShot.frame,newVisRect)) return  CGPointMake(0, 0);
	// If the last snapshot is in the new visiblerect, anchor to the end.

	if ( CGRectIntersectsRect([lastShot frame], newVisRect ) ) {
		CGFloat newOrigin = ([lastShot frame].origin.x + [lastShot frame].size.width + XMARGIN) - newVisRect.size.width;
		
		return CGPointMake(newOrigin, 0);
	}
	return newVisRect.origin;

		
	// otherwise center the offscreen selected item

}
- (CGSize)preferredSizeOfLayer:(CALayer *)layer {
	NSInteger i = layer.sublayers.count;
	CGFloat currentSnapshotDim = layer.boundsHeight - YMARGIN * 2;
	return CGSizeMake(XMARGIN*(i+1) +currentSnapshotDim*i, layer.boundsHeight);
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
	//NSLog(@"layoutSublayersOfLayer called "	);


	CGFloat currentSnapshotDim = layer.bounds.size.height - YMARGIN * 2;
	
	for (int  i = 0; i < layer.sublayers.count; i++ ) {
		CALayer* subLayer = layer.sublayers[i]; 
		subLayer.frame = CGRectMake(XMARGIN*(i+1) +currentSnapshotDim*i, YMARGIN, 
																currentSnapshotDim, currentSnapshotDim);
	}
		
}
@end
