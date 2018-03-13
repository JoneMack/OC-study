//
//  KVCViewController.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/5.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "KVCViewController.h"
#import "BankAccount.h"
#import "Person.h"
#import "User.h"
#import "Address.h"
@interface KVCViewController ()

@end

@implementation KVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BankAccount *myAccount1 = [BankAccount new];
    Person *person = [Person new];
    Address *address = [Address new];
    myAccount1.owner = person;
    myAccount1.owner.address = address;
//   通过kvc 直接将属性当做key，来对属性进行赋值
    [myAccount1 setValue:@(100.0) forKeyPath:@"currentBalance"];
    
    [myAccount1 setValue:@"海淀" forKeyPath:@"owner.address.street"];
    
    BankAccount *myAccount2 = [[BankAccount alloc] init];
    //   通过kvc 直接将属性当做key，来对属性进行赋值
    [myAccount2 setValue:@(200.0) forKeyPath:@"currentBalance"];
    
    BankAccount *myAccount3 = [[BankAccount alloc] init];
    //   通过kvc 直接将属性当做key，来对属性进行赋值
    [myAccount3 setValue:@(300.0) forKeyPath:@"currentBalance"];
    
    NSArray *array = [NSArray arrayWithObjects:myAccount1,myAccount2,myAccount3, nil];
    
    NSLog(@"-------------%@",myAccount1.owner.address.street);
    NSArray *accountArray = [array valueForKeyPath:@"currentBalance"];
    NSLog(@"-------------%@",accountArray);
    
    
    
    NSDictionary *dict = @{
                           @"username": @"joy",
                           @"age": @(20),
                           @"id": @(10)
                           };
    
    
    User *user = [[User alloc] init];
    [user setValuesForKeysWithDictionary:dict];
    
    NSLog(@"---------------%@-------%@----%d---%ld",user,user.name,user.age,(long)user.userId);
    
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
