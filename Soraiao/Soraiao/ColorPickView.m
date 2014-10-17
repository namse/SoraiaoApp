//
//  ColorPickView.m
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import "ColorPickView.h"
#import "ColorPickViewController.h"
@implementation ColorPickView
@synthesize CenterColor;
- (id)initWithFrame:(CGRect)frame parent:(id)parent
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        parentViewController = parent;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        backgroundTopImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PickerViewBackgroundTop"]];
        [self addSubview:backgroundTopImageView];
        
        UIImage* home = [UIImage imageNamed:@"home"];
        homeButton = [[UIButton alloc]initWithFrame:CGRectMake(screenRect.size.width - home.size.width - (backgroundTopImageView.frame.size.height - home.size.height)/2.f,
                                                               (backgroundTopImageView.frame.size.height - home.size.height)/2.f,
                                                               home.size.width,
                                                               home.size.height)];
        [homeButton setImage:home forState:UIControlStateNormal];
        [homeButton addTarget:parent action:@selector(homeButtonPressed) forControlEvents:UIControlEventTouchDown];
        [self addSubview:homeButton];
        
        
        UIImage *link = [UIImage imageNamed:@"PickerViewBackgroundBottom"];
        linkButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f, screenRect.size.height - link.size.height , link.size.width, link.size.height)];
        [linkButton addTarget:parent action:@selector(linkButtonPressed) forControlEvents:UIControlEventTouchDown];
        [linkButton setImage:link forState:UIControlStateNormal];
        [self addSubview:linkButton];
        
        
        
        centerPoint = CGPointMake(screenRect.size.width / 2.f ,
                                          (screenRect.size.height + backgroundTopImageView.frame.size.height - linkButton.frame.size.height) / 2.f);
        
        centerPickerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PickerCenter"]];
        CGRect newFrame = centerPickerImageView.frame;
        newFrame.origin = CGPointMake(centerPoint.x - (newFrame.size.width)/ 2.f,
                                      centerPoint.y - (newFrame.size.height)/ 2.f) ;
        [centerPickerImageView setFrame:newFrame];
        [self addSubview:centerPickerImageView];
                
        [self setupCamera];
    }
    return self;
}

- (void)setupCamera
{
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *device in devices)
    {
        if([device position] == AVCaptureDevicePositionBack)//AVCaptureDevicePositionFront)
            self.device = device;
    }
    
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
    output.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString *) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [output setVideoSettings:videoSettings];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    [self.captureSession addOutput:output];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // CHECK FOR YOUR APP
    self.previewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //self.previewLayer.orientation = AVCaptureVideoOrientationPortrait;
    // CHECK FOR YOUR APP
    
    [self.layer insertSublayer:self.previewLayer atIndex:0];   // Comment-out to hide preview layer
    
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    //////
    
    const CGPoint newCenterPoint = CGPointMake(centerPoint.x * height / self.frame.size.width, centerPoint.y * width / self.frame.size.height);
    const int newCenterPointX = (int)newCenterPoint.x;
    const int newCenterPointY = (int)newCenterPoint.y;
//    
//    NSLog(@"[%zu/%zu] %hhu / %hhu / %hhu",width, height,
//          baseAddress[(int)(height/2.f) * bytesPerRow + (int)(width/2.f) * 4 + 2],
//          baseAddress[(int)(height/2.f) * bytesPerRow + (int)(width/2.f) * 4 + 1],
//          baseAddress[(int)(height/2.f) * bytesPerRow + (int)(width/2.f) * 4 + 0]
//          );
//    
//    NSLog(@"[%d/%d] %hhu / %hhu / %hhu",newCenterPointX, newCenterPointY,
//          baseAddress[(int)(newCenterPointX) * bytesPerRow + (int)(newCenterPointY) * 4 + 2],
//          baseAddress[(int)(newCenterPointX) * bytesPerRow + (int)(newCenterPointY) * 4 + 1],
//          baseAddress[(int)(newCenterPointX) * bytesPerRow + (int)(newCenterPointY) * 4 + 0]
//          );
    
    CenterColor.r = baseAddress[(int)(newCenterPointX) * bytesPerRow + (int)(newCenterPointY) * 4 + 2];
    CenterColor.g = baseAddress[(int)(newCenterPointX) * bytesPerRow + (int)(newCenterPointY) * 4 + 1];
    CenterColor.b = baseAddress[(int)(newCenterPointX) * bytesPerRow + (int)(newCenterPointY) * 4 + 0];
    
    [parentViewController performSelectorOnMainThread:@selector(onColorPicked) withObject:nil waitUntilDone:NO];
    
    
    //////
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    self.cameraImage = [UIImage imageWithCGImage:newImage scale:1.0f orientation:UIImageOrientationDown];//UIImageOrientationDownMirrored];
    
    CGImageRelease(newImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}
@end
