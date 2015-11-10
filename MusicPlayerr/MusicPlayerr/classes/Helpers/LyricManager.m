//
//  LyricManager.m
//  MusicPlayerr
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()

@property(nonatomic, strong)NSMutableArray *dataArray;

@end



@implementation LyricManager

static LyricManager *manager = nil;
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}

-(void)loadLyricWith:(NSString *)lyric{
    
    // 分行
    NSArray *lyricStringArray = [lyric componentsSeparatedByString:@"\n"];
    // 要将之前的歌词删除
    [self.dataArray removeAllObjects];
    // 如果没有歌词
    if ([lyric isEqualToString:@""]) {
        LyricModel *model = [[LyricModel alloc]initWithTime:(0) lyric:@"暂无歌词"];
        [self.dataArray addObject:model];
        return;
    }
    for (NSString *str in lyricStringArray) {
        NSLog(@"%@",str);
        // 最后一行是@“”
        if ([str isEqualToString:@""]) {
            continue;
        }
        // 分开时间和歌词
        NSArray *timeAndLyric =[str componentsSeparatedByString:@"]"];
        // 去掉时间左边的括号
        NSString *time =[timeAndLyric[0]substringFromIndex:1];
        // time =02:32.080
        // 4.截取时间获取分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        // 分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        // 秒
        double second = [minuteAndSecond[1]doubleValue];
        LyricModel *model = [[LyricModel alloc]initWithTime:(minute * 60 +second) lyric:timeAndLyric[1]];
        // 添加到数组中
        [self.dataArray addObject:model];
        
    }
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}

-(NSMutableArray *)lyricArray{
    return _dataArray;
}

-(NSInteger)indexWith:(NSTimeInterval)time{
    // 遍历数组，找到还没有播放的那句歌词
    NSInteger index = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        LyricModel *model = self.dataArray[i];
        if (model.time > time) {
            // 注意如果是第0个元素，而且元素时间要比播放的时间大，i-1就会小于0，这样tableView就会crash
            index = (i - 1)>0?(i-1):0;
            //
            break;
        }
    }
    
    return index;
}

@end
