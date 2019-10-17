//
//  GYAVPlayerView.h
//  Qianyin
//
//  Created by 高洋 on 2019/7/25.
//  Copyright © 2019 Zhibai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVAsset, AVPlayerItem, GYAVPlayerView;

@protocol GYAVPlayerViewDelegate <NSObject>
@optional

/// before play
- (void)AVPlayerView:(GYAVPlayerView *)playerView willPlayItem:(AVPlayerItem *)item;

/**
 ready play

 @return YES, player will play the item; NO, adverse;
 */
- (BOOL)AVPlayerView:(GYAVPlayerView *)playerView readyPlayItem:(AVPlayerItem *)item;

/// progress updated
- (void)AVPlayerView:(GYAVPlayerView *)playerView item:(AVPlayerItem *)item progressUpdatedTo:(double)progress inTotal:(double)total;

/// play finished
- (void)AVPlayerView:(GYAVPlayerView *)playerView finishedPlayingItem:(AVPlayerItem *)item;

/// failed
- (void)AVPlayerView:(GYAVPlayerView *)playerView failedPlayingItem:(AVPlayerItem *)item withError:(NSError *)error;

@end

@interface GYAVPlayerView : UIView

/// delegate
@property (nonatomic, readwrite, weak) id<GYAVPlayerViewDelegate> delegate;

/// url
@property (nonatomic, readwrite, strong) NSURL *url;
/// asset
@property (nonatomic, readwrite, strong) AVAsset *asset;
/// item
@property (nonatomic, readwrite, strong) AVPlayerItem *item;

/// playing or not
@property (nonatomic, readonly, assign, getter=isPlaying) BOOL playing;

/// make the view is ready.
/// when the resource is ready, it play by default.
/// you can override by implement delegate method `-AVPlayerView:readyPlayItem:`
- (void)prepare;

/// you should call `prepare` precede this method
- (void)play;

/// pause, can play later
- (void)pause;

/// pause & release resources
/// if you want play again, do prepare -> play
- (void)stop;

/// moves the playback cursor if conditions fit
- (void)seekToTime:(double)time;

@end

NS_ASSUME_NONNULL_END
