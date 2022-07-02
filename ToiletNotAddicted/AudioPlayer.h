//
//  AudioPlayer.h
//  ToiletNotAddicted
//
//  Created by Tony on 2022/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioPlayer : NSObject

+ (AudioPlayer *)sharePlayer;

@property (nonatomic, assign) BOOL canNotification;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
