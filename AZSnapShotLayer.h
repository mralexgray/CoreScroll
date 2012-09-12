
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <AtoZ/AtoZ.h>

@interface AZSnapShotLayer : CALayer

+ (AZSnapShotLayer*)rootSnapshot;

//@property (nonatomic, retain) CALayer* rootLayer;
@property (nonatomic, retain) CATransformLayer* trannyLayer;
@property (nonatomic, retain) CAConstraintLayoutManager* constrainLayer;

@property (nonatomic, retain) CALayer* contentLayer;
@property (nonatomic, retain) CATextLayer* labelLayer;
@property (nonatomic, retain) CALayer* gradLayer;
@property (nonatomic, retain) CALayer* imageLayer;
@property (nonatomic, assign) BOOL selected;


@property (nonatomic, retain) id objectRep;

@end