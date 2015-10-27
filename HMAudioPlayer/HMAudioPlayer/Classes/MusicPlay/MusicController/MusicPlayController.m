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
//歌曲背景
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//歌曲时长
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
//蓝色的进度条
@property (weak, nonatomic) IBOutlet UIView *progressView;
//滑块
@property (weak, nonatomic) IBOutlet UIButton *slider;

//获取播放器
@property (nonatomic, strong) AVAudioPlayer *player;
//设置进度定时器
@property (nonatomic, strong) NSTimer *progressTimer;


@property (nonatomic, strong) HMMusic *playingMusic;

@end

@implementation MusicPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 点击隐藏播放页面
- (IBAction)didClickForExit:(UIButton *)sender {
    [self removeProgressTimer];
    
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

#pragma mark - 点击 cell 时显示播放页面
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
    [self removeProgressTimer];
    
    self.iconImageView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    
    [EVAAudioTool stopMusicWithFilename:self.playingMusic.filename];//这里传入的是文件名, 不是歌曲名
}

-(void) startPlayMusic {
    HMMusic *music = [EVAMusicPlayTool musicOfPlaying];
    /**
     *  音乐播放时创建播放器
     */
    self.player = [EVAAudioTool playMusicWithFilename:music.filename];
    [self addProgressTimer];
    //保存当前正在播放的音乐
    self.playingMusic = [EVAMusicPlayTool musicOfPlaying];
    
    self.iconImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:music.icon ofType:nil]];
    self.singerLabel.text = music.singer;
    self.songLabel.text = music.name;
    /**
     *  duration得到的时间是秒, 需要格式化
     */
    self.durationLabel.text = [self stringWithTimeInterval:self.player.duration];
}

-(NSString *) stringWithTimeInterval: (NSTimeInterval) interval {
    int m = interval / 60;
    int s = (int)interval % 60;
    
    return [NSString stringWithFormat:@"%02d: %02d", m, s];
}

#pragma mark - 进度条监听
-(void) addProgressTimer {
    if (self.player.playing == NO) {
        return;
    }
    [self updataProgressTimer];
    /**
     *  开始定时器
     */
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updataProgressTimer) userInfo:nil repeats:YES];
    //加入公共运行循环  ---不会因其它操作而暂停
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

-(void) updataProgressTimer {
    CGFloat progress = self.player.currentTime / self.player.duration;
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x = sliderMaxX * progress;
    
    self.progressView.width = self.slider.center.x;
    
    [self.slider setTitle:[self stringWithTimeInterval:self.player.currentTime] forState:UIControlStateNormal];
}

- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    //获取当前点击的位置
    CGPoint point = [sender locationInView:sender.view];
    self.slider.x = point.x;
    /**
     *  实现点击进度条更改音乐进度
     */
    CGFloat progress = point.x / sender.view.width;
    self.player.currentTime = progress * self.player.duration;
}

-(void) removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
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
