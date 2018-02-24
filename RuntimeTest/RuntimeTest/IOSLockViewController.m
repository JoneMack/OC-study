//
//  IOSLockViewController.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/2/24.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "IOSLockViewController.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
@interface IOSLockViewController ()

@end

@implementation IOSLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self OSSPinLockTest];
//    信号量锁
    [self dispatch_semaphore_test];
}
//OSSPinLock

- (void)OSSPinLockTest{
    
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_t oslock = &(OS_UNFAIR_LOCK_INIT);
        NSLog(@"线程准备上锁 %zd",oslock);
        os_unfair_lock_lock(oslock);
        NSLog(@"线程%zd",oslock);
        os_unfair_lock_unlock(oslock);
        NSLog(@"解锁成功 %zd", oslock);
        NSLog(@"-------------------");


        //    线程2
//        NSLog(@"线程 2 准备上锁 %zd",oslock);
//        os_unfair_lock_lock(oslock);
//        NSLog(@"线程2 %zd",oslock);
//        os_unfair_lock_unlock(oslock);
//        NSLog(@"线程2 解锁成功 %zd", oslock);
    } else {
        // Fallback on earlier versions
    }
    
    __block OSSpinLock pinLock = OS_SPINLOCK_INIT;
//    //    线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程 1 准备上锁 %d",pinLock);
        OSSpinLockLock(&pinLock);
//        sleep(4);
        NSLog(@"线程1 %zd",pinLock);
        OSSpinLockUnlock(&pinLock);
        NSLog(@"线程1 解锁成功 %zd", pinLock);
        NSLog(@"-------------------");
    });
//
//    //    线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁 %zd",pinLock);
        OSSpinLockLock(&pinLock);
        NSLog(@"线程2 %zd",pinLock);
        OSSpinLockUnlock(&pinLock);
        NSLog(@"线程2 解锁成功 %zd",pinLock);
    });
    
}


//dispatch_semaphore 信号量
- (void)dispatch_semaphore_test{
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);//传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句
    dispatch_time_t overtime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程等待1----%@",signal);
        dispatch_semaphore_wait(signal, overtime);//signal 值 -1
        NSLog(@"线程1");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程发送信号1");
        NSLog(@"--------------1----------------------");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程等待2----%@",signal);
        dispatch_semaphore_wait(signal, overtime);//signal 值 -1
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程发送信号2");
        NSLog(@"----------2--------------------------");
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
