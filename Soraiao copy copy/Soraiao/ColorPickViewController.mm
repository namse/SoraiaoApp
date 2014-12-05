//
//  ColorPickViewController.m
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import "ColorPickViewController.h"
#import "list"
struct HsvColor{
    double h;       // angle in degrees
    double s;       // percent
    double v;       // percent
};
#define MIN3(x,y,z) MIN(MIN(x,y),z)
#define MAX3(x,y,z) MAX(MAX(x,y),z)

HsvColor RgbToHsv(Color rgbColor)
{
    typedef struct {
        double r;       // percent
        double g;       // percent
        double b;       // percent
    } rgb;
    rgb in;
    in.r = rgbColor.r / 255.f;
    in.g = rgbColor.g / 255.f;
    in.b = rgbColor.b / 255.f;
    
    HsvColor         out;
    double      min, max, delta;
    
    min = in.r < in.g ? in.r : in.g;
    min = min  < in.b ? min  : in.b;
    
    max = in.r > in.g ? in.r : in.g;
    max = max  > in.b ? max  : in.b;
    
    out.v = max;                                // v
    delta = max - min;
    if( max > 0.0 ) { // NOTE: if Max is == 0, this divide would cause a crash
        out.s = (delta / max);                  // s
    } else {
        // if max is 0, then r = g = b = 0
        // s = 0, v is undefined
        out.s = 0.0;
        out.h = NAN;                            // its now undefined
        return out;
    }
    if( in.r >= max )                           // > is bogus, just keeps compilor happy
        out.h = ( in.g - in.b ) / delta;        // between yellow & magenta
    else
        if( in.g >= max )
            out.h = 2.0 + ( in.b - in.r ) / delta;  // between cyan & yellow
        else
            out.h = 4.0 + ( in.r - in.g ) / delta;  // between magenta & cyan
    
    out.h *= 60.0;                              // degrees
    
    if( out.h < 0.0 )
        out.h += 360.0;
    
    return out;
}
@interface ColorPickViewController ()
{
    ColorPickView *pickerView;
    
    PlaySongView* playSongView;
    
    UIView* transColorView;
    
    bool isPickingOn;
    
    PickState pickState;
    
    
    struct Color lastColor;
    struct Color lastPickColor;
    
    AVAudioPlayer *transPlayer;
    
    double lastTime;
    double accTime;
    struct ColorWithTime{
        enum PickState state;
        double time;
        struct Color color;
    };
    std::list<ColorWithTime> queue;
}

@end

@implementation ColorPickViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        pickerView = [[ColorPickView alloc]initWithFrame:screenRect parent:self];
        [self.view addSubview:pickerView];
        [self.view sendSubviewToBack:pickerView];
        
        
        transColorView = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:transColorView];
        [transColorView setHidden:YES];
        
        playSongView = [[PlaySongView alloc]initWithFrame:self.view.frame parent:self];
        [self.view addSubview:playSongView];
        [playSongView setHidden:YES];
        [playSongView setUserInteractionEnabled:NO];
        isPickingOn = YES;
        
        transPlayer = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"decision3" ofType:@"mp3"]] error:nil];
        
        lastTime = [[NSDate date]timeIntervalSinceReferenceDate];
        
        
        [self.view.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
        [self.view setNeedsDisplay];
    }
}

-(void)linkButtonPressed
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.soraiao.net"]];
}
-(void)onColorPicked
{
    if(isPickingOn)
    {
        struct Color color = pickerView.CenterColor;
        lastColor = color;
        HsvColor hsv = RgbToHsv(color);
        //NSLog(@"%3f, %3f, %3f",hsv.h, hsv.s, hsv.v);
        if(hsv.h > 165.f && hsv.h <= 185
           && hsv.s >= 0.5f
           && hsv.v >= 0.5f)
        {
            [self transPickState:PS_BREAKER];
        }
        else if(hsv.h > 185.f && hsv.h <= 205
                && hsv.s >= 0.5f
                && hsv.v >= 0.5f)
        {
            [self transPickState:PS_HARERUYA];
        }
        else if(hsv.h > 205.f && hsv.h <= 225.f
                && hsv.s >= 0.5f
                && hsv.v >= 0.5f)
        {
            [self transPickState:PS_INTHERAIN];
        }
        else if(hsv.h > 225.f && hsv.h <= 265
                && hsv.s >= 0.5f
                && hsv.v >= 0.5f)
        {
            [self transPickState:PS_LOOP];
        }
        else
        {
            [self transPickState:PS_NONE];
        }
        
        //        double dt = [[NSDate date]timeIntervalSinceReferenceDate] - lastTime;
        //
        //        NSLog(@"[%d] : %f",pickState,accTime);
        //        accTime += dt;
        //
        //        if(pickState != PS_NONE && accTime >= PICK_MAX_TIME)
        //        {
        //            SongType type = (SongType)pickState;
        //            [playSongView loadSong:type];
        //            [self transToPlaySongWithColor:lastColor];
        //            accTime = 0;
        //        }
        //
        //
        //        lastTime = [[NSDate date]timeIntervalSinceReferenceDate];
        
        ColorWithTime nowData;
        
        nowData.time = [[NSDate date]timeIntervalSinceReferenceDate];
        nowData.state = pickState;
        nowData.color = lastColor;
        
        queue.push_back(nowData);
        
        auto nowTime = nowData.time;
        while(queue.size() > 0)
        {
            auto front = queue.front();
            
            auto dt = nowTime - front.time;
            if(dt > QUEUE_MAX_DELTA_TIME)
                queue.pop_front();
            else
                break;
        }
        
        bool isFirst = true;
        auto prevData = queue.front();
        double pickTime = 0;
        for( auto data : queue )
        {
            if(isFirst == true)
            {
                isFirst = false;
                continue;
            }
            auto dt = data.time - prevData.time;
            if( prevData.state != PS_NONE )
                pickTime += dt;
            prevData = data;
        }
        NSLog(@"[%d] %f",queue.size(), pickTime);
        
        if(pickTime > PICK_MAX_TIME)
        {
            if(pickState != PS_NONE)
            {
                SongType type = (SongType)pickState;
                [playSongView loadSong:type];
                [self transToPlaySongWithColor:lastColor];
                accTime = 0;
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"action"     // Event category (required)
                                                                      action:@"TransToPlay"  // Event action (required)
                                                                       label:nil          // Event label
                                                                       value:[NSNumber numberWithInt:(int)type]] build]];    // Event value
            }
        }
        
        if(pickState != PS_NONE)
            lastPickColor = lastColor;
        [pickerView setPercentage:pickTime/PICK_MAX_TIME Color:lastPickColor];
        
    }
    
}
-(void)transPickState:(PickState)state
{
    if(state != pickState && pickState == PS_NONE)
    {
        accTime = 0;
    }
    
    pickState = state;
}
-(void)transToPlaySong
{
    isPickingOn = NO;
    
}


-(void)homeButtonPressed
{
    [playSongView stopSong];
    isPickingOn = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        [playSongView setHidden:YES];
        [playSongView setUserInteractionEnabled:NO];
        [pickerView setUserInteractionEnabled:YES];
        [pickerView setHidden:NO];
    }];
    
}

-(void)pickButtonPressed
{
    [playSongView stopSong];
    [self.view setUserInteractionEnabled:YES];
    [playSongView setHidden:YES];
    [playSongView setUserInteractionEnabled:NO];
    [pickerView setUserInteractionEnabled:YES];
    [pickerView setHidden:NO];
    isPickingOn = YES;
}
-(void)backButtonPressed
{
    [playSongView stopSong];
    [self.view setUserInteractionEnabled:YES];
    [playSongView setHidden:YES];
    [playSongView setUserInteractionEnabled:NO];
    [pickerView setUserInteractionEnabled:YES];
    [pickerView setHidden:NO];
    isPickingOn = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"MeasureAndPlay Screen";
}
-(void)transToPlaySongWithColor:(struct Color)color
{
    
    
    
    isPickingOn = NO;
    
    transColorView.transform = CGAffineTransformIdentity;
    [transColorView setFrame:CGRectMake(pickerView.centerPoint.x, pickerView.centerPoint.y, 2.f, 2.f)];
    [transColorView setBackgroundColor:[UIColor colorWithRed:color.r/255.f green:color.g/255.f blue:color.b/255.f alpha:1.f]];
    transColorView.layer.cornerRadius = 1.f;
    transColorView.center = CGPointMake(pickerView.centerPoint.x, pickerView.centerPoint.y);
    //    [transColorView setFrame:CGRectMake(pickerView.centerPoint.x, pickerView.centerPoint.y, 1.f, 1.f)];
    [playSongView setBackgroundColor:[UIColor colorWithRed:color.r/255.f green:color.g/255.f blue:color.b/255.f alpha:1.f]];
    [playSongView.layer setBackgroundColor:[UIColor colorWithRed:color.r/255.f green:color.g/255.f blue:color.b/255.f alpha:1.f].CGColor];
    [transColorView setHidden:NO];
    [transPlayer stop];
    [transPlayer setCurrentTime:0.f];
    [transPlayer play];
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:ANI_DUR animations:^{
        float radius = sqrt(powf(self.view.frame.size.width/2.f, 2.f) + powf(self.view.frame.size.height/2.f, 2.f));
        transColorView.transform = CGAffineTransformScale(CGAffineTransformTranslate(transColorView.transform,
                                                                                     self.view.frame.size.width/2.f - pickerView.centerPoint.x,                                                                                                                                                   self.view.frame.size.height/2.f - pickerView.centerPoint.y),
                                                          radius, radius);
        //        transColorView.transform = CGAffineTransformScale(CGAffineTransformTranslate(transColorView.transform,
        //                                                              self.view.frame.size.width/2.f - pickerView.centerPoint.x,
        //                                                              self.view.frame.size.height/2.f - pickerView.centerPoint.y),
        //        self.view.frame.size.width,
        //        self.view.frame.size.height);
    }completion:^(BOOL){
        [playSongView setHidden:NO];
        [playSongView setAlpha:0.f];
        [playSongView setUserInteractionEnabled:YES];
        [self.view setUserInteractionEnabled:YES];
        [UIView animateWithDuration:ALP_DUR animations:^{
            [playSongView setAlpha:1.f];
        }completion:^(BOOL){
            [transColorView setHidden:YES];
        }];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
