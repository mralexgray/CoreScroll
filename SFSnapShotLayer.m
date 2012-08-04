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
#import "SFSnapShotLayer.h"

#define SFBlackColor  CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor  CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)


#define YMARGIN 10.0 //20.0
#define XMARGIN 10.0 //30.0

@implementation SFSnapShotLayer

static NSInteger snapshotNumber;


@synthesize isSelected=_isSelected;
@synthesize labelLayer=_labelLayer;

// TODO -- rename method
+ (SFSnapShotLayer*)rootSnapshot {
  SFSnapShotLayer* contentLayer = [[[self class] alloc] init];
  
  contentLayer.bounds = CGRectMake(00, 00, 60, 30);
  contentLayer.anchorPoint = CGPointMake(0.0, 0.0);
  
  contentLayer.borderWidth = 2.0;
  contentLayer.borderColor = SFWhiteColor;
  contentLayer.backgroundColor = SFBlackColor;
  contentLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
  
  snapshotNumber++;
  
  CATextLayer* labelLayer = [CATextLayer layer];
  labelLayer.string = [NSString stringWithFormat:@"%ld", snapshotNumber];
  labelLayer.fontSize = 24;
  labelLayer.foregroundColor = SFWhiteColor;
  labelLayer.font = CFBridgingRetain(@"Lucida Grande");
  [labelLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
	[labelLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];

  
  [contentLayer addSublayer:labelLayer];
  [contentLayer setLabelLayer:labelLayer];
  
  
//  [contentLayer autorelease];
  return contentLayer;
}


- (void) setIsSeleczted:(BOOL)isSelected {
  _isSelected = isSelected;
  if(_isSelected) {
    self.backgroundColor = SFWhiteColor;
    _labelLayer.foregroundColor = SFBlackColor;
  } else {
    self.backgroundColor = SFBlackColor;    
    _labelLayer.foregroundColor = SFWhiteColor;
  }
}




@end
