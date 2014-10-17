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

@interface ColorPickViewController : UIViewController
{
    
    ColorPickView *pickerView;
    
    PlaySongView* playSongView;
}
-(void)linkButtonPressed;
-(void)homeButtonPressed;
-(void)pickButtonPressed;
-(void)onColorPicked;
@end
