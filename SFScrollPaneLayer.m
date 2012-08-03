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
#import "SFScrollPaneLayer.h"
#import "SFTimeLineLayout.h"
#import "SFSnapShotLayer.h"

#import "MiscUtils.h"

@interface SFScrollPaneLayer (PrivateMethods)
- (void)scrollToSelected;
- (NSInteger)selectedIndex;
- (void)zoomAnimation:(SFSnapShotLayer*)layer;
- (void)moveScrollView:(CGFloat)dx;
@end

@implementation SFScrollPaneLayer

@synthesize contentController=_contentController;

- (void)layoutSublayers {
  
  // save the center point of the visible 
  CGFloat relativeCenterPoint = ([self visibleRect].origin.x + [self visibleRect].size.width * 0.5) 
                                  / contentWidth;
  [super layoutSublayers];

  
  if ( contentWidth != [self contentWidth] || visibleWidth != [self visibleWidth] ) {
    contentWidth = [self contentWidth];
    visibleWidth = [self visibleWidth];
    stepSize = contentWidth / [[self sublayers] count];
    [_contentController scrollContentResized];
  }

  if ( ! [_contentController isRepositioning] ) {
    [self scrollToPoint:CGPointMake(contentWidth * relativeCenterPoint - visibleWidth * 0.5, 0)];
  }
}


- (void)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint {
 CGPoint point = [self convertPoint:inputPoint fromLayer:self.superlayer];
 
  for ( CALayer* sublayer in [self sublayers] ) {
    if ( CGRectContainsPoint ( sublayer.frame, point ) ) {
      NSInteger layerIndex = [[self sublayers] indexOfObject:sublayer];
      [self selectSnapShot:layerIndex];
    }
  }
     
}

- (void)selectSnapShot:(NSInteger)index {
  // -- check that integer is within bounds
  if( index < 0 || index >= [[self sublayers] count] ) {
    return;
  }
      
	NSInteger selectedIndex = [self selectedIndex];
  
  SFSnapShotLayer* snapShot = [ [self sublayers] objectAtIndex:selectedIndex];
  [snapShot setIsSelected:NO];
  snapShot = [ [self sublayers] objectAtIndex:index];
  [snapShot setIsSelected:YES];
    
  [self setValue:[NSNumber numberWithInteger: index] forKey:selectedSnapShot];
  
  
  [self zoomAnimation:snapShot];    

  // This will override the shift key...  This should be moved to view logic
  [CATransaction setValue:[NSNumber numberWithFloat:0.9] forKey:@"animationDuration"];

  [self scrollToSelected];
  

}

- (void)zoomAnimation:(SFSnapShotLayer*)layer {
  
  CGRect currentBounds = layer.bounds;
  CGFloat currentWidth = currentBounds.size.width;
  CGFloat expansion = XMARGIN * 0.25;
  CGRect newBounds = CGRectMake(0, 0, currentWidth + expansion, currentBounds.size.height + expansion);  
  CGFloat duration = 0.2;
  
  CABasicAnimation *boundsAnimation;
  
  boundsAnimation=[CABasicAnimation animationWithKeyPath:@"bounds"];
  boundsAnimation.duration=duration;
  boundsAnimation.repeatCount=1;
  boundsAnimation.autoreverses=YES;
  boundsAnimation.fromValue= [NSValue valueWithRect:convertToNSRect(currentBounds)];
  boundsAnimation.toValue=[NSValue valueWithRect:convertToNSRect(newBounds)];
  [layer addAnimation:boundsAnimation forKey:@"animateBounds"];
  
  
  CABasicAnimation *positionAnimation;
  
  NSPoint animationOrigin = NSMakePoint(layer.frame.origin.x - expansion * 0.5, 
                                        layer.frame.origin.y - expansion * 0.5);
  
  positionAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
  positionAnimation.duration=duration;
  positionAnimation.repeatCount=1;
  positionAnimation.autoreverses=YES;
  positionAnimation.fromValue= [NSValue valueWithPoint:convertToNSPoint(layer.frame.origin)];
  positionAnimation.toValue=[NSValue valueWithPoint:animationOrigin];
  [layer addAnimation:positionAnimation forKey:@"animatePosition"]; 
  
}

- (void)moveSelection:(NSInteger)dx {
  [self selectSnapShot: [self selectedIndex] + dx];   
}

- (void)scrollToSelected {
  SFTimeLineLayout* layout = [self layoutManager];
  [self scrollToPoint:[layout scrollPointForSelected:self]];
}

- (NSInteger)selectedIndex {
  NSNumber *number = [self valueForKey:selectedSnapShot];
	return number != nil ? [number integerValue] : 0;
}



#pragma mark -
#pragma mark CAScrollLayer Methods

- (void)scrollToPoint:(CGPoint)thePoint {
  [super scrollToPoint:thePoint];
  [_contentController scrollPositionChanged:thePoint.x];
}


#pragma mark -
#pragma mark SFScrollerContent Protocol Methods


- (CGFloat)contentWidth {
  return [ self.layoutManager preferredSizeOfLayer:self].width;
}

- (CGFloat)visibleWidth {
  return [self visibleRect].size.width;
}

- (void)scrollToPosition:(CGFloat)position {
  CGFloat positionPercentage = position;
  if(position < 0 ) {
    positionPercentage = 0;
  }
  
  if( position > 1 ) {
    positionPercentage = 1;
  }
  
  
  CGFloat newX = [self contentWidth] * positionPercentage;
  if (newX > contentWidth - visibleWidth ) newX = contentWidth - visibleWidth;
  [self scrollToPoint:CGPointMake(newX, 0)];
}

- (void)moveScrollView:(CGFloat)dx {
  CGPoint scrollPoint = CGPointMake(self.visibleRect.origin.x + dx, self.visibleRect.origin.y);
  if (scrollPoint.x < 0 ) scrollPoint.x = 0;
  if (scrollPoint.x > contentWidth - visibleWidth ) scrollPoint.x = contentWidth - visibleWidth;
  
  [CATransaction setValue:[NSNumber numberWithFloat:0.8] forKey:@"animationDuration"];
  [self scrollToPoint:scrollPoint]; 
}

- (CGFloat)stepSize {
  return stepSize;
}

@end
