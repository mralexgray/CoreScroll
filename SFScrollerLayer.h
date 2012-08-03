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
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "SFScrollerProtocols.h"

#define SCROLLER_HEIGHT 16.0 // The default height

typedef enum {
	SFNoInput = (1 << 1),
	SFLeftArrowInput = (1 << 2),
	SFRightArrowInput = (1 << 3),
  SFSliderInput = (1 << 4),
  SFTrayInputLeft = (1 << 5),
  SFTrayInputRight = (1 << 6),  
} SFScrollerMouseDownInput;



@interface SFScrollerLayer : CALayer < SFScrollerContentController > {

  CALayer* leftArrow;
  CALayer* leftArrowHighlight;
  
  CALayer* rightArrow;
  CALayer* rightArrowHighlight;
  
  CALayer* tray;
  CALayer* slider;
  
  id <SFScrollerContent> _scrollerContent;

  // -------- Event variables --------------
  SFScrollerMouseDownInput _inputMode;
  CGPoint _mouseDownPointForCurrentEvent;
  BOOL _mouseOverSelectedInput;
  NSTimer* mouseDownTimer;
}

@property(assign) id <SFScrollerContent> scrollerContent;

// returns YES if the scroller should be notified of mouse 
// dragged and mouse up notifications
- (BOOL)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint;
- (void)mouseDragged:(CGPoint)inputPoint;
- (void)mouseUp:(CGPoint)inputPoint;

- (void)moveSlider:(CGFloat)dx;
@end
