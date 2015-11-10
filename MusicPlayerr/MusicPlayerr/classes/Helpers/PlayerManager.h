//
//  PlayerManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerManagerDelegate <NSObject>

// 当播放一首歌结束后，让代理去做的事情
-(void)playerDidPlayEnd;
// 播放中间一直在重复执行的一个方法
-(void)playerPlayingWithTimer:(NSTimeInterval)time;

@end



@interface PlayerManager : NSObject
// 是否正在播放
@property (assign, nonatomic) BOOL isPlaying;
// 设置代理
@property (assign, nonatomic) id<PlayerManagerDelegate> delegate;

+(instancetype)sharedManager;
// 给一个链接,让player播放
-(void)playerWithURlString:(NSString *)urlStr;
// 暂停
-(void)pause;
// 播放
-(void)play;
// 改变进度
-(void)seekToTime:(NSTimeInterval)time;
// 改变音量
-(void)changeVolume:(float)volume;
//
-(float)volume;


@end
