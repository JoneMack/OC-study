//
//  NextViewController.m
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/24.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "NextViewController.h"
int const COUNT = 6;
@interface NextViewController ()
{
    NSMutableArray *values;
    dispatch_group_t group;
    dispatch_queue_t queue;
}
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(30, 400, 50, 50);
//    btn.backgroundColor = [UIColor cyanColor];
//    [btn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    values = [NSMutableArray new];
    
//    GCD测试
    
//    group = dispatch_group_create();
//    queue = dispatch_queue_create("com.yibao.RuntimeTest", DISPATCH_QUEUE_CONCURRENT);
//    [self removeChars:@"abcdefghicladedgdsfs" target:@"ace"];
//    dispatch_group_notify(group, queue, ^{
//        NSString *str = [values componentsJoinedByString:@""];
//        NSLog(@"---结果---%@",str);
//    });
    
    
    
    group = dispatch_group_create();
    queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(3);
        NSLog(@"%@-----------block1结束",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    NSLog(@"%@---------1---- 结束",[NSThread currentThread]);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        sleep(3);
        NSLog(@"%@-----------block2结束",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    NSLog(@"%@---------2---- 结束",[NSThread currentThread]);
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"%@----------全部结束",[NSThread currentThread]);
    });
    
    
    
//    dispatch_group_notify(group, queue, ^{
//        NSString *str = [values componentsJoinedByString:@""];
//        NSLog(@"---结果---%@",str);
//    });
    
}

- (void) removeChars:(NSString *)pBuffer target:(NSString *)target {
    for (int i = 0; i < target.length; i ++){
        if (i==COUNT-1) {
            NSString *str = [pBuffer substringWithRange:NSMakeRange(pBuffer.length/(COUNT-1)*i,pBuffer.length-pBuffer.length/(COUNT-1)*i)];
            [values addObject:str];
        }else{
            NSString *str = [pBuffer substringWithRange:NSMakeRange(pBuffer.length/(COUNT-1)*i, pBuffer.length/(COUNT-1))];
            [values addObject:str];
        }
        
    }
    for (int i = 0; i < target.length; i++){
        [self handlerString:values[i] target:target index:i];
    }
}
- (void)handlerString:(NSString *)string target:(NSString *)target index:(int)index{
    dispatch_group_async(group, queue, ^{
        values[index] = [self replace:string target:target];
    });
}

- (NSString *)replace:(NSString *)string target:(NSString *)target{
    for (int i = 0; i < string.length; i++){
        char temp = [target characterAtIndex:i];
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", temp] withString:@""];
    }
    return string;
}


//- (void)popBtnClick{
//    if (self.popdate) {
//        self.popdate(@"回传数据");
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}



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
