//
//  KVOViewController.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/7.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "KVOViewController.h"
#import "Person.h"
#import "Address.h"
#import "People.h"
#import "Student.h"
@interface KVOViewController ()

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    Person *person = [Person new];
//    Address *add = [Address new];
//    [person addObserver:add forKeyPath:@"sex" options:NSKeyValueObservingOptionNew context:nil];
//    [person addObserver:add forKeyPath:@"gender" options:NSKeyValueObservingOptionNew context:nil];
//    person.sex = 1;
//    person.gender = 0;
//    [person removeObserver:add forKeyPath:@"sex"];
//    [person removeObserver:add forKeyPath:@"gender"];
    
    People *people = [[People alloc] init];
    Student *student   = [[Student alloc] init];
    
    if ([people isKindOfClass:[People class]]) {
        NSLog(@"people iskinofclass People");
    }
    
    if ([people isMemberOfClass:[People class]]) {
        NSLog(@"people isMemberOfClass People");
    }
    
    if ([people isKindOfClass:[NSObject class]]) {
        NSLog(@"people iskinofclass NSObject");
    }
    
    if ([people isMemberOfClass:[NSObject class]]) {
        NSLog(@"people isMemberOfClass NSObject");
    }
    
    if ([student isMemberOfClass:[Student class]]) {
        NSLog(@"student ismemberOfClass Student");
    }
    
    if ([student isMemberOfClass:[People class]]) {
        NSLog(@"student ismemberOfClass People");
    }
    
    if (![student isMemberOfClass:[NSObject class]]) {
        NSLog(@"student isbelog NSObject");
    }
    
    
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
