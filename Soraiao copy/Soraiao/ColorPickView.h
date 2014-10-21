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
@interface ColorPickView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIImageView* backgroundTopImageView;
    //UIImageView* backgroundBottomImageView;
    UIImageView* centerPickerImageView;
    UIButton* linkButton;
    //UIButton* homeButton;
    UIButton* detailButton;
    
    CGPoint centerPoint;
    struct Color{
        int r, g, b;
    } CenterColor;
    
    id parentViewController;
}
- (id)initWithFrame:(CGRect)frame parent:(id)parent;
// Camera
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureSession* captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) UIImage* cameraImage;
@property (nonatomic, readwrite) struct Color CenterColor;
@property (nonatomic, readwrite) CGPoint centerPoint;
@end
