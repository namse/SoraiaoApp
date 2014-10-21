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
#define ANI_DUR 3.f
#define ALP_DUR 3.f
@interface ColorPickViewController : UIViewController
{
    
    ColorPickView *pickerView;
    
    PlaySongView* playSongView;
    
    UIView* transColorView;
    
    bool isPickingOn;
}
-(void)transToPlaySongWithColor:(struct Color)color;
-(void)linkButtonPressed;
//-(void)homeButtonPressed;
-(void)backButtonPressed;
//-(void)pickButtonPressed;
-(void)onColorPicked;
-(void)detailButtonPressed;
@end
