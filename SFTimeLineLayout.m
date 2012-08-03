/*   
 Copyright (c) MMIIX, Matthieu Cormier
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted 
 provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of 
 conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice, this list of 
 conditions and the following disclaimer in the documentation and/or other materials 
 provided with the distribution.
 
 - Neither the name of the "Preen and Prune Group", "Allusions Software" nor the names of its contributors may be 
 used to endorse or promote products derived from this software without specific prior 
 written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 
 Prune and Preen Ware. 
 
 If you find this kode useful I welcome you to toss an email in the general direction
 of matthieu.cormier@gmail.com
 
 
 */
#import "SFTimeLineLayout.h"
#import <Foundation/Foundation.h>


NSString *selectedSnapShot = @"selectedSnapShot";



@implementation SFTimeLineLayout

static SFTimeLineLayout *sharedLayoutManager;

+ (id)layoutManager {
	if (sharedLayoutManager == nil) {
		sharedLayoutManager = [[self alloc] init];
	}
	return sharedLayoutManager;
}

- (SFTimeLineLayout *)init {
	if ([super init]) {
		
	}

	return self;
}

- (CGPoint)scrollPointForSelected:(CALayer *)layer {
 	NSNumber *number = [layer valueForKey:selectedSnapShot];
	int selectedIndex = number != nil ? [number integerValue] : 0;
  NSInteger totalSnapShots = [ [layer sublayers] count];
  
  CALayer* snapShot = [ [layer sublayers] objectAtIndex:selectedIndex];
  CALayer* lastShot = [ [layer sublayers] objectAtIndex:totalSnapShots - 1];
  CALayer* firstShot = [ [layer sublayers] objectAtIndex:0];
    
  // What will the visible rect be if we center the selected snapshot? 
  CGRect selectedRect = [snapShot frame];
  CGFloat newXOrigin = (selectedRect.origin.x  + selectedRect.size.width * 0.5) - [layer visibleRect].size.width * 0.5;   
  CGRect newVisRect = CGRectMake(newXOrigin, 0, [layer visibleRect].size.width, [layer visibleRect].size.height);
    
  // If the first snapshot is in the new visible rect, anchor to the beginning. 
  if ( CGRectIntersectsRect([firstShot frame], newVisRect )  ) {
    return CGPointMake(0, 0);   
  }
    
  // If the last snapshot is in the new visiblerect, anchor to the end.
  if ( CGRectIntersectsRect([lastShot frame], newVisRect )  ) {
    CGFloat newOrigin = ([lastShot frame].origin.x + [lastShot frame].size.width + XMARGIN) - newVisRect.size.width;           
    return CGPointMake(newOrigin, 0);   
  }
    
  // otherwise center the offscreen selected item
  return newVisRect.origin;  
}


- (CGSize)preferredSizeOfLayer:(CALayer *)layer {
  NSInteger i = [layer.sublayers count];
  CGFloat currentSnapshotDim = layer.bounds.size.height - YMARGIN * 2;
  
  return CGSizeMake(XMARGIN*(i+1) +currentSnapshotDim*i, layer.frame.size.height);
}


- (void)layoutSublayersOfLayer:(CALayer *)layer {
  //NSLog(@"layoutSublayersOfLayer called "  );
  NSArray* array = [layer sublayers];
  NSInteger count = [array count];
  
  CGFloat currentSnapshotDim = layer.bounds.size.height - YMARGIN * 2;
  
  NSInteger i;
  CALayer* subLayer;

  for ( i = 0; i < count; i++ ) {
    subLayer = [array objectAtIndex:i]; 
    subLayer.frame = CGRectMake(XMARGIN*(i+1) +currentSnapshotDim*i, YMARGIN, 
                                currentSnapshotDim, currentSnapshotDim);
  }
    
}

@end
