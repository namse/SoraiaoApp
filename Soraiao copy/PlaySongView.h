//
//  PlaySongView.h
//  Soraiao
//
//  Created by echo on 2014. 10. 16..
//  Copyright (c) 2014년 echo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@interface PlaySongView : UIView
{
    UIImageView* backgroundTopImageView;
    UIButton* backgroundBottomButton;
    UIImageView* backgroundImageView;
    UIButton* playToggleButton;
    UIButton* homeButton;
    UIButton* pickButton;
    UIButton* backButton;
    UIImageView* songTitleView;
    
    AVAudioPlayer *player_Breaker;
    AVAudioPlayer *player_Hareruya;
    AVAudioPlayer *player_InTheRain;
    AVAudioPlayer *player_Loop;
    
    AVAudioPlayer *nowPlayer;
    
    bool isPlaying;
}
enum SongType{
    BREAKER,
    HARERUYA,
    INTHERAIN,
    LOOP,
};

@property (nonatomic) AVAudioPlayer *player_Breaker;
@property (nonatomic) AVAudioPlayer *player_Hareruya;
@property (nonatomic) AVAudioPlayer *player_InTheRain;
@property (nonatomic) AVAudioPlayer *player_Loop;
-(void)stopSong;
-(void)linkButtonPressed;
- (id)initWithFrame:(CGRect)frame parent:(id)parent;
-(void)loadSong:(enum SongType)songType;
-(void)onPlayToggleButtonPressed;
@end

//ブレイカー
//ハレルヤ
//インザレイン
//ループ
