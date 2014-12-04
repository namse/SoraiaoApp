//
//  AimView.h
//  Soraiao3
//
//  Created by echo on 2014. 11. 12..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AimView : UIView
{
    CAShapeLayer *pathLayer;
}
struct Color{
    int r, g, b;
};
@property (atomic, readonly) struct Color aimColor;
@property (strong, atomic) UIImage* aimImage;
@property (atomic, readonly)  double aimPercentage;
-(id)initWithImage:(UIImage *)image;
- (void)drawRect:(CGRect)rect;
- (void)setNeedsDisplay;
-(void)setPercentage:(double)percent Color:(struct Color)color;
@end
