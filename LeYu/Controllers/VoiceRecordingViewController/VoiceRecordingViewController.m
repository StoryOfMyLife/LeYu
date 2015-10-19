//
//  VoiceRecordingViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/10/13.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "VoiceRecordingViewController.h"
#import <AFSoundManager/AFSoundManager.h>

@interface VoiceRecordingViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) RACSignal *timeSignal;
@property (nonatomic, strong) RACDisposable *timeDisposable;

@end

@implementation VoiceRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //AVAudioSessionCategoryPlayAndRecord用于录音和播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else {
        [session setActive:YES error:nil];
    }
    
    self.duration = self.player.duration;
    if (self.duration == 0) {
        self.playButton.enabled = NO;
        self.resetButton.enabled = NO;
    }
    
    [RACObserve(self, duration) subscribeNext:^(NSNumber *duration) {
        NSTimeInterval inteval = [duration doubleValue];
        int minute = inteval / 60;
        NSTimeInterval second = inteval - minute * 60;
        
        NSString *timeString = @"";
        if (second >= 10) {
            if (minute >= 10) {
                timeString = [NSString stringWithFormat:@"%d:%.2f", minute, second];
            } else {
                timeString = [NSString stringWithFormat:@"0%d:%.2f", minute, second];
            }
        } else {
            if (minute >= 10) {
                timeString = [NSString stringWithFormat:@"%d:%.2f", minute, second];
            } else {
                timeString = [NSString stringWithFormat:@"0%d:0%.2f", minute, second];
            }
        }
        self.timeLabel.text = timeString;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupNavigationItems
{
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton sizeToFit];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (RACSignal *)timeSignal
{
    if (!_timeSignal) {
        _timeSignal = [[RACSignal interval:0.01f onScheduler:[RACScheduler mainThreadScheduler]] startWith:@(0)];
    }
    return _timeSignal;
}

- (AVAudioRecorder *)recorder
{
    if (!_recorder) {
        //配置Recorder
        NSDictionary *recordSetting = @{ 
                                         AVEncoderAudioQualityKey: @(AVAudioQualityMin),
                                         AVEncoderBitRateKey: @(8),
                                         AVNumberOfChannelsKey: @(2),
                                         AVSampleRateKey: @(44100.0)
                                         };
        
        //录音文件保存地址的URL
        NSURL *url = [NSURL fileURLWithPath:[self newFilePath]];
        
        NSError *error = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
        _recorder.meteringEnabled = YES;
        _recorder.delegate = self;
        [_recorder prepareToRecord];
    }
    return _recorder;
}

- (AVAudioPlayer *)player
{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[self finalFilePath]] error:nil];
        _player.delegate = self;
        [_player prepareToPlay];
    }
    return _player;
}

- (IBAction)record:(id)sender
{
    if (!self.recorder.isRecording && [self.recorder prepareToRecord]) {
        [self.recorder record];
        self.resetButton.enabled = NO;
        [self.recordButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [self.recordButton setImage:[UIImage imageNamed:@"stop_selected"] forState:UIControlStateHighlighted];

        NSDate *currentDate = [NSDate date];
        @weakify(self);
        NSTimeInterval lastInterval = self.duration;
        self.timeDisposable = [self.timeSignal subscribeNext:^(NSDate *date) {
            @strongify(self);
            if ([date isKindOfClass:[NSDate class]]) {
                self.duration = lastInterval + [date timeIntervalSinceDate:currentDate];
            } else if ([date isKindOfClass:[NSNumber class]]) {
                NSNumber *dateNum = (NSNumber *)date;
                self.duration = lastInterval + [dateNum doubleValue];
            }
        }];
    } else {
        [self.timeDisposable dispose];
        [self.recorder stop];
        [self compositAudio];
        self.resetButton.enabled = YES;
        self.playButton.enabled = YES;
        [self.recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [self.recordButton setImage:[UIImage imageNamed:@"record_selected"] forState:UIControlStateHighlighted];
    }
}

- (NSString *)newFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [(NSString *)paths[0] stringByAppendingPathComponent:@"new_record.caf"];
}

- (NSString *)finalFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [(NSString *)paths[0] stringByAppendingPathComponent:@"final_record.m4a"];
}

- (IBAction)reset:(id)sender
{
    [self.recorder stop];
    [self.player stop];
    self.player = nil;
    [self.recorder deleteRecording];
    self.playButton.enabled = NO;
    self.resetButton.enabled = NO;
    [self setPlayButtonStatusNormal:YES];
    self.duration = 0;
    [[NSFileManager defaultManager] removeItemAtPath:[self finalFilePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self newFilePath] error:nil];
}

- (IBAction)play:(id)sender
{
    if (!self.player.isPlaying) {
        [self.player play];
        [self setPlayButtonStatusNormal:NO];
    } else {
        [self.player pause];
        [self setPlayButtonStatusNormal:YES];
    }
}

- (void)save:(id)sender
{
    AVFile *audioFile = [AVFile fileWithName:@"voice.m4a" contentsAtPath:[self finalFilePath]];
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"upload audio fail : %@", error);
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)setPlayButtonStatusNormal:(BOOL)normal
{
    if (normal) {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"play_selected"] forState:UIControlStateHighlighted];
    } else {
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"pause_selected"] forState:UIControlStateHighlighted];
    }
}

- (void)compositAudio
{
    // Generate a composition of the two audio assets that will be combined into
    // a single track
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                     preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // grab the two audio assets as AVURLAssets according to the file paths
    
    AVURLAsset *tmpAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[self finalFilePath]] options:nil];
    AVURLAsset *newAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[self newFilePath]] options:nil];
    
    NSError *error = nil;
    
    // grab the portion of interest from the master asset
    NSArray *tracks = [tmpAsset tracksWithMediaType:AVMediaTypeAudio];
    if ([tracks count] > 0) {
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, tmpAsset.duration)
                            ofTrack:[tmpAsset tracksWithMediaType:AVMediaTypeAudio][0]
                             atTime:kCMTimeZero
                              error:&error];
        if (error)
        {
            // report the error
            return;
        }
    }
    
    // append the entirety of the active recording
    tracks = [newAsset tracksWithMediaType:AVMediaTypeAudio];
    if ([tracks count] > 0) {
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, newAsset.duration)
                            ofTrack:tracks[0]
                             atTime:tmpAsset.duration
                              error:&error];
        
        if (error)
        {
            // report the error
            return;
        }
    }
    
    // now export the two files
    // create the export session
    // no need for a retain here, the session will be retained by the
    // completion handler since it is referenced there
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition
                                                                            presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession)
    {
        // report the error
        return;
    }
    
    
    NSString *combined = [self finalFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:combined]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:combined error:&err];
        if (err) {
            NSLog(@"remove fail : %@", err);
        }
    }
    
    // configure export session  output with all our parameters
    exportSession.outputURL = [NSURL fileURLWithPath:combined]; // output path
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        // export status changed, check to see if it's done, errored, waiting, etc
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCompleted:
                self.player = nil;
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            default:
                break;
        }
        // your code for dealing with the now combined file
    }];
}

#pragma mark -
#pragma mark record delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}

#pragma mark -
#pragma mark player delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self setPlayButtonStatusNormal:YES];
    }
}

@end
