//
//  MusicPlayController.m
//  HMAudioPlayer
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "MusicPlayController.h"
#import "UIView+Extension.h"
#import "EVAAudioTool.h"
#import "EVAMusicPlayTool.h"

@interface MusicPlayController ()
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) HMMusic *playingMusic;

@end

@implementation MusicPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) show {
    /**
     *  切换歌曲时, 重置播放页面信息
     */
    if (self.playingMusic != [EVAMusicPlayTool musicOfPlaying]) {
        [self resetPlayingMusic];
    }
    
    //设置为主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    
    self.view.hidden = NO;
    window.userInteractionEnabled = NO;//禁用交互, 防止用户多次点击, 造成此方法重复执行
    
    self.view.y = window.height;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        
        //动画执行完, 开始播放音乐
        [self startPlayMusic];
    }];
}

-(void) resetPlayingMusic {
    self.iconImageView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    
    [EVAAudioTool stopMusicWithFilename:self.playingMusic.filename];//这里传入的是文件名, 不是歌曲名
}

-(void) startPlayMusic {
    HMMusic *music = [EVAMusicPlayTool musicOfPlaying];
    
    self.iconImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:music.icon ofType:nil]];
    self.singerLabel.text = music.singer;
    self.songLabel.text = music.name;
    
    [EVAAudioTool playMusicWithFilename:music.filename];
    //保存当前正在播放的音乐
    self.playingMusic = [EVAMusicPlayTool musicOfPlaying];
}

- (IBAction)didClickForExit:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = window.height;
    } completion:^(BOOL finished) {
        //视图隐藏之后系统不会在进行其他操作
        self.view.hidden = YES;
        
        window.userInteractionEnabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
