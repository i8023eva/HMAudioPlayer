//
//  EVAAudioTool.h
//  01-音频播放
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface EVAAudioTool : NSObject
/**
 *  音效
 */
+(void) playAudioWithFileName:(NSString *) fileName;
+(void) disposeAudioWithFileName: (NSString *)fileName;
// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename;
@end
