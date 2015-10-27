//
//  EVAAudioTool.m
//  01-音频播放
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "EVAAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation EVAAudioTool

static NSMutableDictionary *_soundIDict = nil;

static NSMutableDictionary *_players;

+(NSMutableDictionary *) soundIDict {
    if (_soundIDict == nil) {
        _soundIDict = [NSMutableDictionary dictionary];
    }
    return _soundIDict;
}

+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

+(void) playAudioWithFileName:(NSString *) fileName {
    if (fileName == nil) {
        return;
    }
    
    SystemSoundID soundID = [[self soundIDict][fileName] unsignedIntValue];
    /**
     *  如果字典中没有存储此文件名
     */
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        //文件名是否存在
        if (url == nil) {
            return;
        }
        
        CFURLRef cfURL = (__bridge CFURLRef _Nonnull)(url);
        AudioServicesCreateSystemSoundID(cfURL, &soundID);
        CFRelease(cfURL);
        
        [self soundIDict][fileName] = @(soundID);
    }
    AudioServicesPlaySystemSound(soundID);
}
/**
 *  内存警告时调用此方法
 */
+(void) disposeAudioWithFileName: (NSString *)fileName {
    if (fileName == nil) {
        return;
    }
    
    SystemSoundID soundID = [[self soundIDict][fileName] unsignedIntValue];
    
    if (soundID) {
        //销毁音效 ID
        AudioServicesDisposeSystemSoundID(soundID);
        
        [[self soundIDict] removeObjectForKey:fileName];
    }
}

// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return nil;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (!player) {
        NSLog(@"创建新的播放器");
        
        // 2.1根据文件名称加载音效URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 2.2判断url是否为nil
        if (!url) {
            return nil;
        }
        
        // 2.3创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.4准备播放
        if(![player prepareToPlay])
        {
            return nil;
        }
#warning 
        // 允许快进
        player.enableRate = YES;
        player.rate = 3;
        
        // 2.5将播放器添加到字典中
        [self players][filename] = player;
        
    }
    // 3.播放音乐
    if (!player.playing)
    {
        [player play];
    }
    
    return player;
}

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否存在
    if(player)
    {
        // 2.1判断是否正在播放
        if (player.playing)
        {
            // 暂停
            [player pause];
        }
    }
    
}

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (player) {
        // 2.1停止播放
        [player stop];
        // 2.2清空播放器
        //        player = nil;
        // 2.3从字典中移除播放器
        [[self players] removeObjectForKey:filename];
    }
}


@end
