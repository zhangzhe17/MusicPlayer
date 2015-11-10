//
//  LyricManager.h
//  MusicPlayerr
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <Foundation/Foundation.h>
// 单例
@interface LyricManager : NSObject

@property (strong, nonatomic) NSMutableArray *lyricArray;

+(instancetype)sharedManager;

-(void)loadLyricWith:(NSString *)lyric;
/**
 *  根据播放时间获取到该播放的歌词的索引
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)indexWith:(NSTimeInterval)time;
@end
