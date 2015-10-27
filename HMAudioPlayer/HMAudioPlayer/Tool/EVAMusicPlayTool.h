//
//  EVAMusicPlayTool.h
//  HMAudioPlayer
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMMusic.h"

@interface EVAMusicPlayTool : NSObject
/**
 *  获取音乐列表
 */
+(NSArray *) musicList;
/**
 *  设置当前正在播放音乐
 */
+(void) setPlayingMusic: (HMMusic *)music;
/**
 *  返回当前正在播放的音乐
 */
+(HMMusic *) musicOfPlaying;
/**
 *  获取下一首
 */
+(HMMusic *) nextMusic;
/**
 *  获取上一首
 */
+(HMMusic *) previouesMusic;

@end
