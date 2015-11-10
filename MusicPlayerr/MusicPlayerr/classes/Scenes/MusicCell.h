//
//  MusicCell.h
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UILabel *singerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgVIew;


@property (strong, nonatomic) MusicModel *musicModel;

@end
