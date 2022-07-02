//
//  SceneDelegate.m
//  ToiletNotAddicted
//
//  Created by Tony on 2022/7/2.
//

#import "SceneDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "AudioPlayer.h"

@interface SceneDelegate ()
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"变成活跃状态");
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"将要挂起");
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"进入开后台");
    [[AudioPlayer sharePlayer] pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addlocalNotificationForNewVersion];
    });
    
    if (self.backgroundTaskIdentifier == UIBackgroundTaskInvalid) {
        [self beginBackgroundTask];
    }
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


- (void)beginBackgroundTask {
    self.backgroundTaskIdentifier = [UIApplication.sharedApplication beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];
}

- (void)endBackgroundTask {
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [UIApplication.sharedApplication endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}


- (void)addlocalNotificationForNewVersion {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"危危危!!!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"请立即远离马桶🚽🚽🚽" arguments:nil];
    content.sound = [UNNotificationSound soundNamed:@"alert.mp3"];
    
//    UNTimeIntervalNotificationTrigger * tirgger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"OXNotification" content:content trigger:nil];
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        NSLog(@"成功添加推送");
    }];
}



@end
