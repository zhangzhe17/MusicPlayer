//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDataSource>
// 记录当前播放音乐的索引
@property(nonatomic,assign)NSInteger currentIndex;
// 记录当前播放的音乐
@property(nonatomic,strong)MusicModel *currentModel;

@property (strong, nonatomic) IBOutlet UITableView *tableVIew;


#pragma mark---控件
@property (strong, nonatomic) IBOutlet UILabel *songLab;

@property (strong, nonatomic) IBOutlet UILabel *singerLab;
@property (strong, nonatomic) IBOutlet UIImageView *imgVIew;
@property (strong, nonatomic) IBOutlet UILabel *playTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *LastTimeLab;
@property (strong, nonatomic) IBOutlet UISlider *slider4Time;
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;
@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;

@end

static PlayingViewController *playingVC = nil;
static NSString *identifier = @"cellReuse";

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置自己为播放器代理，
    [PlayerManager sharedManager].delegate = self;
    _currentIndex = -1;
    _imgVIew.layer.masksToBounds = YES;
    _imgVIew.layer.cornerRadius = 120;
    [self.tableVIew registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.slider4Volume.value = [[PlayerManager sharedManager] volume];
}
#pragma mark---PlayerManagerDelegate
// 开始播放下一首
-(void)playerDidPlayEnd{
    [self action4Next:nil];
}
//代理方法。播放器每0.1秒会执行该方法
-(void)playerPlayingWithTimer:(NSTimeInterval)time{
    self.slider4Time.value = time;
    self.playTimeLab.text = [self stringWithTimer:time];
    self.LastTimeLab.text = [self stringWithTimer:([self.currentModel.duration integerValue]/1000 - time)];
    // 每0.1秒旋转1度
    self.imgVIew.transform = CGAffineTransformRotate(self.imgVIew.transform, M_PI / 180);
    // 如果没有歌词
    if ([self.currentModel.lyric isEqualToString:@""]) {
        return;
    }
    // 根据 当前播放时间获取到应该播放的那句歌词
    NSInteger index = [[LyricManager sharedManager] indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    // 选中歌词
    [self.tableVIew selectRowAtIndexPath:path animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
//    self.tableVIew scrollToRowAtIndexPath:<#(nonnull NSIndexPath *)#> atScrollPosition:<#(UITableViewScrollPosition)#> animated:<#(BOOL)#>
}
-(NSString *)stringWithTimer:(NSTimeInterval)time{
    NSInteger minutes = time / 60;
    NSInteger second = (int)time % 60;
    return [NSString stringWithFormat:@"%ld:%ld",minutes,second];
}

+(instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        [sb instantiateInitialViewController];
        // 在main sb拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
    });
    return playingVC;
}

-(void)startPlay{
    
    [[PlayerManager sharedManager]playerWithURlString:self.currentModel.mp3Url];
    [self buildUI];
}

-(void)buildUI{
    self.singerLab.text = self.currentModel.singer;
    self.songLab.text = self.currentModel.name;
    [self.imgVIew sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl] placeholderImage:[UIImage imageNamed: @"1"]];
    // 更改btn
    [self.btn4PlayOrPause setTitle:@"暂停" forState:(UIControlStateNormal)];
    // 改变时间进度条的最大值
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue] / 1000;
    // 设置音量进度条的最大值
//    self.slider4Volume.maximumValue = 10;
//    self.slider4Volume.value = 2;
    // 更改旋转的角度,图片归位
    self.imgVIew.transform = CGAffineTransformMakeRotation(0);
    [[LyricManager sharedManager] loadLyricWith:self.currentModel.lyric];
    [self.tableVIew reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 如果要播放的音乐和当前的音乐一样，就什么也不做
    if (_index == _currentIndex) {
        return;
    }
    // 如果不等。就要切换另一首歌。并把当前的音乐设置这个传过来的音乐
    _currentIndex = _index;
    [self startPlay];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark-- 控件
// 上一首
- (IBAction)action4pre:(id)sender {
    _currentIndex--;
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].allMusic.count;
    }
    [self startPlay];
}
- (IBAction)action4PlayOrPause:(id)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying) {
        // 同时要改变button的text
        [[PlayerManager sharedManager] pause];
//        [sender setTitle:@"播放" forState:(UIControlStateNormal)];
        [sender setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
        
    }else{
        [[PlayerManager sharedManager] play];
//        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
        [sender setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
    }
    
    //TODO:
    
    
    
}
// 下一首
- (IBAction)action4Next:(UIButton *)sender {
    // 在播放下一首时先暂停，销毁timer
//    [[PlayerManager sharedManager] pause];
    _currentIndex++;
    // 判断是否是最后一首
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        _currentIndex = 0;
    }
    [self startPlay];
}
// 拖动滑条
- (IBAction)action4ChangeTime:(UISlider *)sender {
    // 调用接
    [[PlayerManager sharedManager] seekToTime:sender.value];
    
}
// 调节音量的滑块
- (IBAction)action4Volume:(UISlider *)sender {
    [[PlayerManager sharedManager] changeVolume:sender.value];
    
}




// 重写get方法，确保当前播放的音乐是最新的
-(MusicModel *)currentModel{
    // 取到要播放的model
    MusicModel *model = [[DataManager sharedManager]musicModelWithIndex:self.currentIndex];
    return model;
}
#pragma mark-uitableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager sharedManager].lyricArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    LyricModel*model = [LyricManager sharedManager].lyricArray[indexPath.row];
    cell.textLabel.text = model.lyricContext;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
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
