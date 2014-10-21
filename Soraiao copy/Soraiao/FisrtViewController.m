//
//  ViewController.m
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    {
        backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FirstViewBackground"]];
        [self.view addSubview:backgroundImageView];

        
        CGRect screenRect = [[UIScreen mainScreen] bounds];

        CGPoint centerPoint = CGPointMake(screenRect.size.width / 2.f ,
                                  (screenRect.size.height + [UIImage imageNamed:@"PickerViewBackgroundTop"].size.height - [UIImage imageNamed:@"PickerViewBackgroundBottom"].size.height) / 2.f);
        
        UIImage *startButtonImage = [UIImage imageNamed:@"FirstViewStartButton"];
        startButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f,
                                                                centerPoint.y - startButtonImage.size.height/2.f, //170.f,
                                                                startButtonImage.size.width, startButtonImage.size.height)];
        [startButton setImage:startButtonImage forState:UIControlStateNormal];
        [startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startButton];
        
        UIImage *link = [UIImage imageNamed:@"FirstViewLinkButton"];
        linkButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f, screenRect.size.height - link.size.height , link.size.width, link.size.height)];
        [linkButton addTarget:self action:@selector(linkButtonPressed) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:linkButton];
        
        
        pickerViewController = [[ColorPickViewController alloc]init];
        pickerViewController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
        pickerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
    }
}

-(void)startButtonPressed
{
    //TODO Switch View
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

-(void)linkButtonPressed
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.soraiao.net"]];
}
@end