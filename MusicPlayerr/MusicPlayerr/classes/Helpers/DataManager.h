//
//  DataManager.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void (^UpdataUI)();

@interface DataManager : NSObject

@property (copy, nonatomic) UpdataUI myUpdataUI;
@property (strong, nonatomic) NSArray *allMusic;

/**
 *  单例
 *
 *  @return 单例
 */
+(DataManager *)sharedManager;

// 根据cell的索引返回一个model
-(MusicModel *)musicModelWithIndex:(NSInteger)index;
@end
