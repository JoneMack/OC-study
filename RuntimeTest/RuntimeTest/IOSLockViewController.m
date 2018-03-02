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
#import <pthread.h>
@interface IOSLockViewController ()

@end

@implementation IOSLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self OSSPinLockTest];
//    信号量锁
//    [self dispatch_semaphore_test];
//    互斥锁
//    [self pthread_mutex_test];
//    递归
//    [self pthread_mutex_recursive];
    
//    [self nslock_test];
    
//    [self condition_test];
    [self NSConditionLock_test];
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


//pthread_mutex 互斥锁
- (void)pthread_mutex_test{
    static pthread_mutex_t pLock;
    pthread_mutex_init(&pLock, NULL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        pthread_mutex_lock(&pLock);
        sleep(3);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
        NSLog(@"线程1 解锁成功");
        NSLog(@"----------------------");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
    });
    
}


- (void)pthread_mutex_recursive{
    static pthread_mutex_t pLock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
    pthread_mutex_init(&pLock, NULL);
    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
    
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                NSLog(@"value: %d", value);
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&pLock);
        };
        RecursiveBlock(5);
    });
}


- (void)nslock_test {
    NSLock *myLock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [myLock lock];
        sleep(5);
        NSLog(@"线程1");
        [myLock unlock];
//        if ([myLock tryLock]) {
//            NSLog(@"可以获得锁");
//        }else {
//            NSLog(@"不可以获得所");
//        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        if ([myLock tryLock]) {
//            NSLog(@"---可以获得锁");
//        }else {
//            NSLog(@"----不可以获得所");
//        }
        [myLock lock];
        NSLog(@"线程2");
        [myLock unlock];
    });
}

- (void)condition_test{
//    NSCondition *cLock = [NSCondition new];
//    //线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"准备加锁");
//        [cLock lock];
//        [cLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
//        NSLog(@"线程1");
//        [cLock unlock];
//    });
    NSCondition *cLock = [NSCondition new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程1加锁成功");
        [cLock wait];
        NSLog(@"线程1");
        [cLock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程2加锁成功");
        [cLock wait];
        NSLog(@"线程2");
        [cLock unlock];
    });
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(2);
//        NSLog(@"唤醒一个等待的线程");
//        [cLock signal];
//    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"唤醒所有等待的线程");
        [cLock broadcast];
    });
}

- (void)NSConditionLock_test{
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
            [cLock unlockWithCondition:1];
        }else{
            NSLog(@"失败");
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"线程2");
        [cLock unlockWithCondition:2];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程3");
        [cLock unlockWithCondition:3];
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
