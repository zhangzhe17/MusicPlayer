//
//  MusicCell.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "MusicCell.h"
#import "UIImageView+WebCache.h"

@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMusicModel:(MusicModel *)musicModel{
#warning 获取cell的值，用po可在控制台打印
    // 给cell绑定值
    _musicModel = musicModel;
    _songLabel.text = musicModel.name;
    _singerLabel.text = musicModel.singer;
    [_imgVIew sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl] placeholderImage:[UIImage imageNamed:@"1"]];
}

@end
