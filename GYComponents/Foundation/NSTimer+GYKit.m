//
//  NSTimer+GYComponent.m
//  
//
//  Created by 高洋 on 2018/5/12.
//  Copyright © 2018年 gaoyang. All rights reserved.
//

#import "NSTimer+GYKit.h"
#import <objc/runtime.h>
#import "GYComponentsHeader.h"

GYSYNTH_DUMMY_CLASS(NSTimer_GYComponent)

static const char* kTimerBlockKey = "kTimerBlockKey";
@implementation NSTimer (GYComponent)

+ (NSTimer *)gy_scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                          block:(GYTimerBlock)block
                                        repeats:(BOOL)yesOrNo {
    
    return [self gy_scheduledTimerWithTimerInterval:interval block:block userInfo:nil
                                            repeats:yesOrNo];
}
+ (NSTimer *)gy_scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                          block:(GYTimerBlock)block
                                       userInfo:(id)userInfo
                                        repeats:(BOOL)yesOrNo {
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                   target:self // 类对象, 单例
                                                 selector:@selector(gy_invokeBlock:)
                                                 userInfo:userInfo
                                                  repeats:yesOrNo];
    objc_setAssociatedObject(timer, kTimerBlockKey, [block copy], OBJC_ASSOCIATION_COPY);
    return timer;
}

+ (NSTimer *)gy_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(GYTimerBlock)block
                              repeats:(BOOL)yesOrNo {
    return [self gy_timerWithTimeInterval:interval block:block userInfo:nil repeats:yesOrNo];
}

+ (NSTimer *)gy_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(GYTimerBlock)block
                             userInfo:(nullable id)userInfo
                              repeats:(BOOL)yesOrNo {
    NSTimer *timer = [self timerWithTimeInterval:interval
                                          target:self  // 类对象, 单例
                                        selector:@selector(gy_invokeBlock:)
                                        userInfo:userInfo
                                         repeats:yesOrNo];
    objc_setAssociatedObject(timer, kTimerBlockKey, [block copy], OBJC_ASSOCIATION_COPY);
    return timer;
}


+ (void)gy_invokeBlock:(NSTimer *)timer {
    GYTimerBlock block = objc_getAssociatedObject(timer, kTimerBlockKey);
    if (block) {
        block();
    }
}

@end
