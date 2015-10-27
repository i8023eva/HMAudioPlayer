//
//  EVAMusicPlayTool.m
//  HMAudioPlayer
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "EVAMusicPlayTool.h"
#import "MJExtension.h"

@implementation EVAMusicPlayTool

static NSArray *_musicList = nil;
/**
 *  正在播放音乐
 */
static HMMusic *_musicPlay = nil;

+(NSArray *) musicList {
    if (_musicList == nil) {
        _musicList = [HMMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musicList;
}

+(void) setPlayingMusic: (HMMusic *)music {
    /**
     *  歌曲模型为空或者所有音乐中不存在此歌
     */
    if (!music || ![[self musicList] containsObject:music]) {
        return;
    }
    _musicPlay = music;
}

+(HMMusic *) musicOfPlaying {
    return _musicPlay;
}

+(HMMusic *) nextMusic {
    /**
     *  获取当前音乐下标
     */
    NSUInteger currentIndex = [[self musicList] indexOfObject:_musicPlay];
    //
    NSInteger nextIndex = ++currentIndex;
    //越界处理
    if (nextIndex >= [self musicList].count) {
        nextIndex = 0;
    }
    return [self musicList][nextIndex];
}

+(HMMusic *) previouesMusic {
    /**
     *  获取当前音乐下标
     */
    NSUInteger currentIndex = [[self musicList] indexOfObject:_musicPlay];
    //
    NSInteger previouesIndex = --currentIndex;
    //越界处理
    if (previouesIndex < 0) {
        previouesIndex = [self musicList].count - 1;
    }
    return [self musicList][previouesIndex];
}
@end
