//
//  LyricModel.h
//  MusicPlayerr
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
// 歌词播放时间
@property (assign, nonatomic) NSTimeInterval time;
// 歌词
@property (strong, nonatomic) NSString *lyricContext;

-(instancetype)initWithTime:(NSTimeInterval)time
              lyric:(NSString *)lyric;
@end
