#import <ABI50_0_0RNReanimated/ABI50_0_0REAFrame.h>

@implementation ABI50_0_0REAFrame

- (instancetype)initWithX:(float)x y:(float)y width:(float)width height:(float)height
{
  self = [super init];
  _x = x;
  _y = y;
  _width = width;
  _height = height;
  return self;
}

@end
