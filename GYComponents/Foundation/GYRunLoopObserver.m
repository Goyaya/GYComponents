//
//  GYRunLoopObserver.m
//  
//
//  Created by 高洋 on 2019/5/31.
//  Copyright © 2019 Zhibai. All rights reserved.
//

#import "GYRunLoopObserver.h"

@interface GYRunLoopObserver ()

@property (nonatomic, readwrite, copy) GYRunLoopObserverCallback callback;

@property (nonatomic, readwrite, assign) CFRunLoopRef rl;
@property (nonatomic, readwrite, assign) CFRunLoopObserverRef cfObserver;

@end

@implementation GYRunLoopObserver

- (instancetype)initWithMode:(CFRunLoopMode)mode
                    activity:(CFRunLoopActivity)activity
                     repeats:(BOOL)repeats
                       order:(CFIndex)order
                       queue:(NSOperationQueue *)queue
                  usingBlock:(GYRunLoopObserverCallback)callback {
    
    self = [super init];
    
    if (self) {
        _mode = mode;
        _activity = activity;
        _repeats = repeats;
        _order = order;
        _queue = queue;
        _callback = [callback copy];
        
        [self start];
    }
    
    return self;
}

- (instancetype)start {
    if (!_cfObserver) {
        CFRunLoopRef ref = CFRunLoopGetCurrent();
        _rl = ref;
        
        CFRunLoopObserverContext ctx = { 0, (__bridge void *)(self), NULL, NULL, NULL};
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, _activity, _repeats, _order, &runLoopObserverCallback, &ctx);
        if (observer) {
            CFRunLoopAddObserver(ref, observer, _mode);
            _cfObserver = observer;
        }
    }
    
    return self;
}

- (instancetype)stop {
    
    if (_cfObserver) {
        CFRunLoopRemoveObserver(_rl, _cfObserver, _mode);
    }
    
    return self;
}

- (void)dealloc {
    [self stop];
}

void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    GYRunLoopObserver *o = (__bridge GYRunLoopObserver *)info;
    if (o.callback) {
        if (o.queue) {
            [o.queue addOperationWithBlock:^{
                o.callback(o, activity);
            }];
        } else {
            o.callback(o, activity);
        }
    }
}

@end
