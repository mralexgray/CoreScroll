@protocol SFScrollerContentController
- (BOOL)isRepositioning;
- (void)scrollPositionChanged:(CGFloat)position;
- (void)scrollContentResized;
@end

@protocol SFScrollerContent
- (CGFloat)contentWidth;
- (CGFloat)visibleWidth;
- (CGFloat)stepSize;
- (void)moveScrollView:(CGFloat)dx;
// where position is a number between 0.0 and 1.0 representing the 
// posible positions the visible rect can be at
- (void)scrollToPosition:(CGFloat)position;
@end

