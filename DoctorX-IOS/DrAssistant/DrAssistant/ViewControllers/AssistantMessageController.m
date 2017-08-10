//
//  AssistantMessageController.m
//  DrAssistant
//
//  Created by 刘湘 on 15/9/14.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AssistantMessageController.h"

@interface AssistantMessageController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *edu;
@property (weak, nonatomic) IBOutlet UILabel *Professional;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation AssistantMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _baseView.layer.cornerRadius=8.0;
    _baseView.layer.masksToBounds=YES;
    // Do any additional setup after loading the view.
    
    
    
    self.name.text = self.asstantInfo.REAL_NAME;
    
    if (self.asstantInfo) {
       self.sex.text = self.asstantInfo.SEX ? @"男":@"女";
    }else{
        self.sex.text = nil;
    }
    
    
    self.age.text = self.asstantInfo.age;
    self.edu.text = self.asstantInfo.education;
    self.phoneNum.text = self.asstantInfo.PHONE;
    self.Professional.text = self.asstantInfo.SPECIALITY;
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
