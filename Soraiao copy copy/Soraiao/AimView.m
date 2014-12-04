//
//  AimView.m
//  Soraiao3
//
//  Created by echo on 2014. 11. 12..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import "AimView.h"
#import "ColorPickViewController.h"

@implementation AimView
@synthesize aimColor;
@synthesize aimImage;
@synthesize aimPercentage;


-(id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if(self)
    {
        pathLayer = [CAShapeLayer layer];
        [self.layer addSublayer:pathLayer];
        
        [self setClearsContextBeforeDrawing:YES];
        aimImage = [UIImage imageWithCGImage:[image CGImage]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


-(void)setPercentage:(double)percent Color:(struct Color)color
{
    aimPercentage = percent;
    aimColor = color;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
    
    
    if(aimPercentage >= 1)
    {
        [UIView animateWithDuration:ANI_DUR animations:^{
            float radius = 10.f;
            self.transform = CGAffineTransformScale(self.transform,radius, radius);
            //        transColorView.transform = CGAffineTransformScale(CGAffineTransformTranslate(transColorView.transform,
            //                                                              self.view.frame.size.width/2.f - pickerView.centerPoint.x,
            //                                                              self.view.frame.size.height/2.f - pickerView.centerPoint.y),
            //        self.view.frame.size.width,
            //        self.view.frame.size.height);
        }completion:^(BOOL a){
            self.transform = CGAffineTransformIdentity;
        }];
    }
    [[UIColor clearColor] setFill];
    
        CGContextFillRect(context, bounds);
        
        CGContextClipToMask(context, bounds, [aimImage CGImage]);
        
        if(aimPercentage != 0)
        {
            if(aimPercentage > 1)
                aimPercentage = 1;
            
            
            UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                 radius:self.frame.size.width/2.f
                                                             startAngle:-M_PI_2
                                                               endAngle:-M_PI_2 + 2.f * M_PI * aimPercentage
                                                              clockwise:NO];
            [aPath addLineToPoint:center];
            [aPath closePath];
            [[UIColor blackColor] setFill];
            [aPath fill];
            
            
            
            UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                 radius:self.frame.size.width/2.f
                                                             startAngle:-M_PI_2
                                                               endAngle:-M_PI_2 + 2.f * M_PI * aimPercentage
                                                              clockwise:YES];
            [bPath addLineToPoint:center];
            [bPath closePath];
            
            [[UIColor colorWithRed:aimColor.r/255.f green:aimColor.g/255.f blue:aimColor.b/255.f alpha:1.f] setFill];
            [bPath fill];
            
            
            UIBezierPath *centerPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                      radius:self.frame.size.width/5.f
                                                                  startAngle:0
                                                                    endAngle:M_PI * 2.f
                                                                   clockwise:NO];
            [centerPath addLineToPoint:center];
            [centerPath closePath];
            [[UIColor blackColor] setFill];
            [centerPath fill];
            
            
        }
        else
        {
            [[UIColor blackColor] setFill];
            
            CGContextFillRect(context, bounds);
        }
    
    
}
- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self setNeedsDisplayInRect:self.frame];
}


@end
