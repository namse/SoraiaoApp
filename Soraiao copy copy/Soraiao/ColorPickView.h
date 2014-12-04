//
//  ColorPickView.h
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
// Frameworks
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include <dispatch/dispatch.h>
#include "AimView.h"
@interface ColorPickView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIImageView* backgroundTopImageView;
    //UIImageView* backgroundBottomImageView;
    AimView* centerPickerImageView;
    UIImageView* linkButton;
    UIButton* homeButton;
    UIButton* detailButton;
    
    CGPoint centerPoint;
    struct Color CenterColor;
    
    id parentViewController;
}
- (id)initWithFrame:(CGRect)frame parent:(id)parent;
-(void)setPercentage:(double)percent Color:(struct Color)color;
// Camera
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureSession* captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) UIImage* cameraImage;
@property (nonatomic, readwrite) struct Color CenterColor;
@property (nonatomic, readwrite) CGPoint centerPoint;
@end
