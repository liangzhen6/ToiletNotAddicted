//
//  AudioPlayer.m
//  ToiletNotAddicted
//
//  Created by Tony on 2022/7/2.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer ()
@property (nonatomic, strong) AVAudioPlayer *player;
@end
static AudioPlayer *_player = nil;
@implementation AudioPlayer

+ (AudioPlayer *)sharePlayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _player = [[AudioPlayer alloc] init];
        [_player player];
    });
    return _player;
}

- (AVAudioPlayer *)player {
    if (_player == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        _player.volume = 1.0f;
        _player.numberOfLoops = -1;
    }
    return _player;
}


- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}


@end
