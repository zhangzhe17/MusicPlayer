//
//  PlayingViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

+(instancetype)sharedPlayingPVC;
//  要播放的第几首歌曲
@property(nonatomic,assign)NSInteger index;

@end
