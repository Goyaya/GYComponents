//
//  GYAVPlayController.m
//  GYComponents
//
//  Created by gaoyang on 2019/10/18.
//

#import "GYAVPlayController.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(int, GYAVPlayControllerPrepareStatus) {
    GYAVPlayControllerPrepareStatusNone,
    GYAVPlayControllerPrepareStatusPreparing,
    GYAVPlayControllerPrepareStatusPrepared
};

@interface GYAVPlayController ()

/// player
@property (nonatomic, readwrite, strong) AVPlayer *player;

/// 播放器是否准备好了播放
@property (nonatomic, readwrite, assign) GYAVPlayControllerPrepareStatus prepareStatus;
/// 是否处于播放状态
@property (nonatomic, readwrite, assign, getter=isPlaying) BOOL playing;
/// 当前item的状态, 记录该状态，可以避免由 ReadyToPlay->ReadyToPlay 的不正常表现
@property (nonatomic, readwrite, assign) AVPlayerItemStatus statusForCurrentItem;

/// 进度观察
@property (nonatomic, readonly, strong) id periodicTimeObserver;

@end

@implementation GYAVPlayController

- (void)setUrl:(NSURL *)url {
    if ([_url isEqual:url]) {
        return;
    }
    [self stop];
    _url = url;
}

- (void)setAsset:(AVAsset *)asset {
    if ([_asset isEqual:asset]) {
        return;
    }
    [self stop];
    _asset = asset;
}

- (void)setItem:(AVPlayerItem *)item {
    if ([_item isEqual:item]) {
        return;
    }
    [self stop];
    _item = item;
}

- (void)prepare {
    if (_prepareStatus == GYAVPlayControllerPrepareStatusPreparing || _prepareStatus == GYAVPlayControllerPrepareStatusPrepared) {
        return;
    }
    _prepareStatus = GYAVPlayControllerPrepareStatusPreparing;
    
    [self checkItemIfNeedsBuild];
    
    if (_player == nil) {
        _player = [AVPlayer playerWithPlayerItem:_item];
    } else {
        [_player replaceCurrentItemWithPlayerItem:_item];
    }
    
    [self notifyDelegatePlayerWillPlaying];
    [self addObserverForCurrentItem];
}

- (void)play {
    if (self.prepareStatus == GYAVPlayControllerPrepareStatusPrepared && self.isPlaying == NO) {
        [self.player play];
        self.playing = YES;
    }
}

- (void)pause {
    if (self.prepareStatus == GYAVPlayControllerPrepareStatusPrepared && self.isPlaying) {
        [self.player pause];
        self.playing = NO;
    }
}

/// 停止播放，释放资源
- (void)stop {
    [self pause];
    
    [self removeObserverForCurrentItem];
    
    _item = nil;
    [_player replaceCurrentItemWithPlayerItem:nil];
    _statusForCurrentItem = AVPlayerItemStatusUnknown;
    self.playing = NO;
    self.prepareStatus = GYAVPlayControllerPrepareStatusNone;
}

- (void)seekToTime:(double)time {
    if (self.prepareStatus == GYAVPlayControllerPrepareStatusPrepared) {
        [self.player seekToTime:CMTimeMake(time, 1)];
    }
}

#pragma mark -

/// 默认设置
- (void)attachConfigurations {
    [self addSystemNotifications];
    self.progressReportInterval = 1.0;
}

/// 清除工作
- (void)detachConfigurations {
    [self removeSystemNotifications];
}

#pragma mark -

- (void)checkItemIfNeedsBuild {
    if (_item) {
        return;
    }
    if (_url) {
        _item = [AVPlayerItem playerItemWithURL:_url];
    } else if (_asset) {
        _item = [AVPlayerItem playerItemWithAsset:_asset];
    }
}

- (void)addObserverForCurrentItem {
    if (_item == nil) {
        return;
    }
    
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    typeof(self) __weak weakself = self;
    _periodicTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(self.progressReportInterval, 10) queue:NULL usingBlock:^(CMTime time) {
        // 进度更新
        double total = CMTimeGetSeconds(weakself.item.duration);
        double progress = CMTimeGetSeconds(time);
        [weakself notifyDelegateProgressUpdate:progress total:total];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_item];
}

- (void)removeObserverForCurrentItem {
    if (_item == nil) {
        return;
    }
    [_item removeObserver:self forKeyPath:@"status" context:nil];
    if (_periodicTimeObserver) {
        [_player removeTimeObserver:_periodicTimeObserver];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown: {
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                if (self.statusForCurrentItem != AVPlayerItemStatusReadyToPlay) {
                    self.prepareStatus = GYAVPlayControllerPrepareStatusPrepared;
                    BOOL needsPlay = YES;
                    [self notifyDelegatePlayerReadyPlayAndGetValue:&needsPlay];
                    if (needsPlay) {
                        [self.player play];
                        self.playing = YES;
                    }
                }
                break;
            }
            case AVPlayerItemStatusFailed: {
                self.prepareStatus = GYAVPlayControllerPrepareStatusPrepared;
                [self notifyDelegatePlayFailed];
                self.playing = NO;
                break;
            }
        }
        self.statusForCurrentItem = status;
    }
}

- (void)addSystemNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChanged:)   name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)removeSystemNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark -

- (void)applicationWillResignActive:(NSNotification *)notification {
    if (self.isPlaying) {
        [self.player pause];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (self.isPlaying) {
        [self.player play];
    }
}

- (void)audioRouteChanged:(NSNotification*)notification {
    void (^checkIfNeedsPlay)(void) = ^{
        if (self.isPlaying) {
            [self.player play];
        }
    };
    AVAudioSessionRouteChangeReason routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonUnknown:
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        case AVAudioSessionRouteChangeReasonCategoryChange:
        case AVAudioSessionRouteChangeReasonOverride:
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange:
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            checkIfNeedsPlay();
            break;
        }
        case AVAudioSessionRouteChangeReasonWakeFromSleep: {
            checkIfNeedsPlay();
            break;
        }
    }
}

- (void)itemPlayToEnd:(NSNotification *)notification {
    self.playing = NO;
    [self notifyDelegatePlayEnd];
}

- (void)notifyDelegatePlayerWillPlaying {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayController:willPlayItem:)]) {
        [self.delegate AVPlayController:self willPlayItem:_item];
    }
}

- (void)notifyDelegatePlayerReadyPlayAndGetValue:(BOOL *)value {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayController:readyPlayItem:)]) {
        BOOL v = [self.delegate AVPlayController:self readyPlayItem:_item];
        if (value) {
            *value = v;
        }
    }
}

- (void)notifyDelegateProgressUpdate:(float)progress total:(float)total {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayController:item:progressUpdatedTo:inTotal:)]) {
        [self.delegate AVPlayController:self item:_item progressUpdatedTo:progress inTotal:total];
    }
}

- (void)notifyDelegatePlayFailed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayController:failedPlayingItem:withError:)]) {
        [self.delegate AVPlayController:self failedPlayingItem:_item withError:_item.error];
    }
}

- (void)notifyDelegatePlayEnd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVPlayController:finishedPlayingItem:)]) {
        [self.delegate AVPlayController:self finishedPlayingItem:_item];
    }
}

#pragma mark - override

- (instancetype)init {
    self = [super init];
    if (self) {
        [self attachConfigurations];
    }
    return self;
}

- (void)dealloc {
    [self detachConfigurations];
    [self stop];
}

@end
