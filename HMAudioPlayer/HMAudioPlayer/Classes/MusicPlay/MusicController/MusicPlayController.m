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

@interface MusicPlayController ()<AVAudioPlayerDelegate>
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
//显示拖拽进度
@property (weak, nonatomic) IBOutlet UIButton *currentTimeView;
//控制播放暂停
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;

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
    self.currentTimeView.layer.cornerRadius = 9.0;
}

#pragma mark - 三个按钮的点击监听
- (IBAction)previous {
    //重置页面
    [self resetPlayingMusic];
    //当前播放音乐
    [EVAMusicPlayTool setPlayingMusic:[EVAMusicPlayTool previouesMusic]];
    //播放
    [self startPlayMusic];
}

- (IBAction)next {
    //重置页面
    [self resetPlayingMusic];
    //当前播放音乐
    [EVAMusicPlayTool setPlayingMusic:[EVAMusicPlayTool nextMusic]];
    //播放
    [self startPlayMusic];
}

- (IBAction)playOrPause {
    if (self.playOrPauseButton.selected) {//选中状态就是在播放, 显示的是暂停 点击之后显示播放, 暂停音乐
        self.playOrPauseButton.selected = NO;
        
        [EVAAudioTool pauseMusicWithFilename:self.playingMusic.filename];
    }else {
        self.playOrPauseButton.selected = YES;
        
//        [EVAAudioTool playMusicWithFilename:self.playingMusic.filename];
//        /**
//         *  开启定时器
//         */
//        [self addProgressTimer];
        [self startPlayMusic];
    }
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
    
    self.playOrPauseButton.selected = YES;
    
    HMMusic *music = [EVAMusicPlayTool musicOfPlaying];
    /**
     *  音乐播放时创建播放器
     */
    self.player = [EVAAudioTool playMusicWithFilename:music.filename];
    self.player.delegate = self;
    /**
     *  ,暂停之后, 点击播放判断当前音乐
     */
    if (self.playingMusic == [EVAMusicPlayTool musicOfPlaying]) {
        [self addProgressTimer];
        return;
    }

    //保存当前正在播放的音乐
    self.playingMusic = [EVAMusicPlayTool musicOfPlaying];
    
    self.iconImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:music.icon ofType:nil]];
    self.singerLabel.text = music.singer;
    self.songLabel.text = music.name;
    /**
     *  duration得到的时间是秒, 需要格式化
     */
    self.durationLabel.text = [self stringWithTimeInterval:self.player.duration];
    
    [self addProgressTimer];

}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    /**
     *  播放完, 自动播放下一首歌
     */
    [self next];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    /**
     *  播放器被打断时调用 [电话]
     *///暂停
    if (self.player.playing) {
        [EVAAudioTool pauseMusicWithFilename:self.playingMusic.filename];
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    /**
     *  播放器打断结束
     *///继续
    if (self.player.playing) {
        [self startPlayMusic];
    }
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

#pragma mark - 单击进度条
- (IBAction) onProgressViewByTap: (UITapGestureRecognizer *)sender {
    //获取当前点击的位置
    CGPoint point = [sender locationInView:sender.view];
    
//    self.slider.x = point.x;
//    self.progressView.width = self.slider.center.x;
    /**
     *  实现点击进度条更改音乐进度
     */
    CGFloat progress = point.x / sender.view.width;
    self.player.currentTime = progress * self.player.duration;
    
    [self updataProgressTimer];
}

#pragma mark - 拖拽滑块
- (IBAction) onSliderByPan: (UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view];
    /**
     *  使滑动到的当前位置为初始位置, 不累加
     */
    [sender setTranslation:CGPointZero inView:sender.view];
    self.slider.x += point.x;

#warning 
    /**
     *  位置矫正, 滑块移出边界蓝色进度条会出错
     */
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    if (self.slider.x < 0) {
        self.slider.x = 0;
    } else if (self.slider.x > sliderMaxX) {
        self.slider.x = sliderMaxX;
    }
    //这句一定要在矫正之后
    self.progressView.width = self.slider.x;
    
    //更新音乐进度, point已经清0, 所以使用当前 slider 的位置
    CGFloat progress = self.slider.x / self.slider.superview.width;
    NSTimeInterval time = progress * self.player.duration;
    
    [self.slider setTitle:[self stringWithTimeInterval:time] forState:UIControlStateNormal];
    
    [self.currentTimeView setTitle:[self stringWithTimeInterval:time] forState:UIControlStateNormal];
    self.currentTimeView.centerX = self.slider.centerX;
    self.currentTimeView.y = self.currentTimeView.superview.height - self.currentTimeView.height - 10;
    
    /**
     *  判断监听的状态
     */
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentTimeView.hidden = NO;
        
        [self removeProgressTimer];
    } else if (sender.state == UIGestureRecognizerStateEnded){
        self.currentTimeView.hidden = YES;
        
        self.player.currentTime = time;

        if (self.player.playing) {
            /**
             *  如果是暂停状态, 不需要开启定时器, 但是需要在再次开始时启动定时器
             */
            [self addProgressTimer];
        }
    }

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
