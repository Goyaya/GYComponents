//
//  NSTimer+GYComponent.h
//  
//
//  Created by 高洋 on 2018/5/12.
//  Copyright © 2018年 gaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GYTimerBlock) (void);

/// timer--strong-->middleRole--weak-->target
/// ensure your target be weakreference
@interface NSTimer (GYComponent)

+ (NSTimer *)gy_scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                          block:(GYTimerBlock)block
                                        repeats:(BOOL)yesOrNo;

+ (NSTimer *)gy_scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                          block:(GYTimerBlock)block
                                       userInfo:(id _Nullable)userInfo
                                        repeats:(BOOL)yesOrNo;

+ (NSTimer *)gy_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(GYTimerBlock)block
                              repeats:(BOOL)yesOrNo;

+ (NSTimer *)gy_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(GYTimerBlock)block
                             userInfo:(nullable id)userInfo
                              repeats:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END
