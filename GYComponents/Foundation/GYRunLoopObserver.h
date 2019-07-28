//
//  GYRunLoopObserver.h
//
//
//  Created by 高洋 on 2019/5/31.
//  Copyright © 2019 Zhibai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYRunLoopObserver;

typedef void(^GYRunLoopObserverCallback)(GYRunLoopObserver *observer, CFRunLoopActivity activity);

@interface GYRunLoopObserver : NSObject

/// mode
@property (nonatomic, readonly, assign) CFRunLoopMode mode;
/// activity
@property (nonatomic, readonly, assign) CFRunLoopActivity activity;
/// repeats
@property (nonatomic, readonly, assign) BOOL repeats;
/// order
@property (nonatomic, readonly, assign) CFIndex order;
/// queue
@property (nonatomic, readonly, strong, nullable) NSOperationQueue *queue;
/// callback
@property (nonatomic, readonly, copy) GYRunLoopObserverCallback callback;

/**
 create and return an observer of the runloop which thread the method called.

 @param mode the mode of runloop to be observed
 @param activity the activity of runloop to be observed
 @param repeats once or repeats
 @param order the priority of observer
 @param queue the queue of callback invoke. nil means callback invoked in the queue it init
 @param callback callback
 @return observer instance
 */
- (instancetype)initWithMode:(CFRunLoopMode)mode
                    activity:(CFRunLoopActivity)activity
                     repeats:(BOOL)repeats
                       order:(CFIndex)order
                       queue:(NSOperationQueue * _Nullable)queue
                  usingBlock:(GYRunLoopObserverCallback)callback NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
