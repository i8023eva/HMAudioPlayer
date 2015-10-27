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

@end

@implementation MusicPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) show {
    //设置为主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    self.view.y = window.height;
    [UIView animateWithDuration:1.5 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //动画执行完, 开始播放音乐
        [EVAAudioTool playMusicWithFilename:[EVAMusicPlayTool musicOfPlaying].filename];
        
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
