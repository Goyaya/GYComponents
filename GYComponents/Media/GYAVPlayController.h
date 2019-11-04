//
//  GYAVPlayController.h
//  GYComponents
//
//  Created by gaoyang on 2019/10/18.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>

NS_ASSUME_NONNULL_BEGIN

@class GYAVPlayController, AVPlayerItem, AVAsset;

@protocol GYAVPlayControllerDelegate <NSObject>
@optional

/// before play
- (void)AVPlayController:(GYAVPlayController *)playController willPlayItem:(AVPlayerItem *)item;

/**
 ready play
 
 @return YES, player will play the item; NO, adverse;
 */
- (BOOL)AVPlayController:(GYAVPlayController *)playController readyPlayItem:(AVPlayerItem *)item;

/// progress updated
- (void)AVPlayController:(GYAVPlayController *)playController item:(AVPlayerItem *)item progressUpdatedTo:(double)progress inTotal:(double)total;

/// play finished
- (void)AVPlayController:(GYAVPlayController *)playController finishedPlayingItem:(AVPlayerItem *)item;

/// failed
- (void)AVPlayController:(GYAVPlayController *)playController failedPlayingItem:(AVPlayerItem *)item withError:(NSError *)error;

@end

@interface GYAVPlayController : NSObject

/// context
@property (nonatomic, readwrite, strong) id context;
/// delegate
@property (nonatomic, readwrite, weak) id<GYAVPlayControllerDelegate> delegate;
/// url
@property (nonatomic, readwrite, strong) NSURL *url;
/// asset
@property (nonatomic, readwrite, strong) AVAsset *asset;
/// item
@property (nonatomic, readwrite, strong) AVPlayerItem *item;
/// playing or not
@property (nonatomic, readonly, assign, getter=isPlaying) BOOL playing;
/// progress report interval. default is once per second
@property (nonatomic, readwrite, assign) CMTime progressReportInterval;

/// make the view is ready.
/// when the resource is ready, it play by default.
/// you can override by implement delegate method `-AVPlayConPtroller:readyPlayItem:`
- (void)prepare;

/// you should call `prepare` precede this method
- (void)play;

/// pause, can play later
- (void)pause;

/// pause & release resources
/// if you want play again, do prepare -> play
- (void)stop;

/// moves the playback cursor if conditions fit
- (void)seekToTime:(CMTime)time;

@end

NS_ASSUME_NONNULL_END
