//
//  ColorPickViewController.h
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaySongView.h"
#import "ColorPickView.h"
#import <QuartzCore/QuartzCore.h>
#define ANI_DUR 3.f
#define ALP_DUR 3.f
#define PICK_MAX_TIME 1.5f
@interface ColorPickViewController : UIViewController
{
    
    ColorPickView *pickerView;
    
    PlaySongView* playSongView;
    
    UIView* transColorView;
    
    bool isPickingOn;
    
    enum PickState{
        PS_BREAKER = 1,
        PS_HARERUYA = 2,
        PS_INTHERAIN = 3,
        PS_LOOP = 4,
        PS_NONE = 0,
    }pickState;
    float pickedTimeCount;
    
    struct Color lastColor;
    
    AVAudioPlayer *transPlayer;
}
-(void)tick:(NSTimer*)timer;
-(void)transPickState:(enum PickState)state;
-(void)transToPlaySongWithColor:(struct Color)color;
-(void)linkButtonPressed;
-(void)homeButtonPressed;
-(void)backButtonPressed;
-(void)pickButtonPressed;
-(void)onColorPicked;
//-(void)detailButtonPressed;
@end
