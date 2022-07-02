//
//  ViewController.m
//  ToiletNotAddicted
//
//  Created by Tony on 2022/7/2.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "AudioPlayer.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 10;
    
    __weak typeof(self) weakSelf = self;
    NSTimer * timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf tickAction];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timer.fireDate = [NSDate distantFuture];
    self.timer = timer;
    [self startRotationAnimation];
    [self pauseLayer:self.imageView.layer];
    // Do any additional setup after loading the view.
}


- (void)tickAction {
    self.titleLabel.text = [NSString stringWithFormat:@"%ld", self.count];
    [self startAnimation];
    self.count -= 1;
    if (self.count == 0) {
        self.timer.fireDate = [NSDate distantFuture];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pauseLayer:self.imageView.layer];
            [[AudioPlayer sharePlayer] pause];
        });
    }
}

- (void)startRotationAnimation {
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    //动画持续时间
    rotationAnimation.duration = 4;
    rotationAnimation.repeatCount = MAXFLOAT;
    //动画的时间节奏控制
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //设置动画结束的时候 不回到 起点位置， 一下两个属性要一起设置方可生效。
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.imageView.layer addAnimation:rotationAnimation forKey:nil];
}


// 暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
-(void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval continueTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    layer.beginTime = timePause;
}



- (void)startAnimation {
//    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    basicAnimation.fromValue = @(5);
////    basicAnimation.toValue = @(1);
////    basicAnimation.toValue = CATransform3DMakeScale(1.0, 1.0, 1);
//    //动画持续时间
//    basicAnimation.duration = 0.7;
//   //是否执行逆动画
////    basicAnimation.autoreverses = YES;
//    //动画的执行次数
////    basicAnimation.repeatCount = MAXFLOAT;
//       /*
//        kCAMediaTimingFunctionLinear 匀速
//        kCAMediaTimingFunctionEaseIn 慢进
//        kCAMediaTimingFunctionEaseOut 慢出
//        kCAMediaTimingFunctionEaseInEaseOut 慢进慢出
//        kCAMediaTimingFunctionDefault 默认值（慢进慢出）
//        */
//     //动画的时间节奏控制
//    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    //设置动画结束的时候 不回到 起点位置， 一下两个属性要一起设置方可生效。
//   basicAnimation.fillMode = kCAFillModeForwards;
//   basicAnimation.removedOnCompletion = NO;
//   [self.titleLabel.layer addAnimation:basicAnimation forKey:nil];
    
    
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(10);
    //动画持续时间
    scaleAnimation.duration = 0.7;
     //动画的时间节奏控制
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //设置动画结束的时候 不回到 起点位置， 一下两个属性要一起设置方可生效。
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    [self.titleLabel.layer addAnimation:scaleAnimation forKey:nil];
    
//    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////    rotationAnimation.fromValue = [NSNumber numberWithFloat:-M_PI];
//    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
//    //动画持续时间
//    rotationAnimation.duration = 0.7;
////    rotationAnimation.repeatCount = MAXFLOAT;
//     //动画的时间节奏控制
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    //设置动画结束的时候 不回到 起点位置， 一下两个属性要一起设置方可生效。
//    rotationAnimation.fillMode = kCAFillModeForwards;
//    rotationAnimation.removedOnCompletion = NO;
//    [self.titleLabel.layer addAnimation:rotationAnimation forKey:nil];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startAction];
}



- (void)startAction {
    self.count = 10;
    self.timer.fireDate = [NSDate distantPast];
    [self resumeLayer:self.imageView.layer];
    [[AudioPlayer sharePlayer] play];
}

- (IBAction)NotifiSettingAction:(id)sender {
    
    
    
}


@end
