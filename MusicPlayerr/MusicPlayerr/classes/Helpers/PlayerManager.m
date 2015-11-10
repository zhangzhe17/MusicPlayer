//
//  PlayerManager.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager ()

// 播放器，全局唯一，因为如果两个avplayer就会同时播放俩个音乐
@property(nonatomic, strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation PlayerManager

static PlayerManager *playerManager = nil;
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerManager = [PlayerManager new];
    });
    return playerManager;
}

-(void)playerWithURlString:(NSString *)urlStr{
    // 如果是切换，先把观察者移除
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    // 创建一个item
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    // 替换当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    [playerItem addObserver:self forKeyPath:@"status"options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    // 正在播放
//    [self.player play];
}

#pragma mark--懒加载
-(AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}
#pragma mark---观察响应
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"加载完成");
            // 暂停，就是销毁timer。然后再播放，创建timer
            [self pause];
            [self play];
            break;
        default:
            break;
    }
    
}

-(instancetype)init{
    if (self = [super init]) {
        // 添加通知中心，当self发出AVPlayerItemDidPlayToEndTimeNotification时触发playerDidPlayEnd:事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

-(void)playerDidPlayEnd:(NSNotificationCenter *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        // 接收到item播放结束后，让代理去干一件事，啥事都行（上一首，随机啊）
        [_delegate playerDidPlayEnd];
    }
}
-(void)pause{
    [self.player pause];
    _isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)play{
    // 如果正在播放，就不播放了
    if (_isPlaying) {
        return;
    }
    [self.player play];
    _isPlaying = YES;
    //
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
    
}

-(void)playingWithSeconds{
    NSLog(@"%lld",self.player.currentTime.value / self.player.currentTime.timescale);
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTimer:)]) {
        // 计算播放器现在播放的秒数
        NSInteger time = self.player.currentTime.value / self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTimer:time];
        
    }
}
// time:5s
-(void)seekToTime:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    // CMTime结构体用到两个  timescale 和 value
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            // 拖拽后再播放
            [self play];
        }
    }];
}

-(void)changeVolume:(float)volume{
    self.player.volume = volume;
}

-(float)volume{
    return self.player.volume;
}

@end
