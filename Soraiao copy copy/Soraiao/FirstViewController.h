//
//  ViewController.h
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickViewController.h"
#import "GAITrackedViewController.h"
@interface FirstViewController : GAITrackedViewController
{
    UIImageView* backgroundImageView;
    UIButton* startButton;
    UIButton* linkButton;
    ColorPickViewController* pickerViewController;
}
-(void)startButtonPressed;
-(void)linkButtonPressed;
@end
