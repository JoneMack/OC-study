//
//  SeleceAreaAndCircleView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/27.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SeleceAreaAndCircleView.h"

@implementation SeleceAreaAndCircleView

-(instancetype)init
{
    self = [super init];
    if(self){
        self = [[[NSBundle mainBundle]loadNibNamed:@"SeleceAreaAndCircleView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
        [self setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.7]];
        [self initPickerView];
    }
    return self;
}

-(void) initPickerView{
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
}

-(void) showLastSelected{
    if(self.selectedShangQuan != nil && self.selectedChengQu != nil){
        for(int i=0 ; i<[self.circle getChildren].count ; i++){
            Circle *circle = [self.circle getChildren][i];
            if([self.selectedChengQu isEqualToString:circle.text]){
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                NSArray *subCircles = [circle getChildren];
                for (int j=0; j<subCircles.count; j++) {
                    Circle *subCircle = subCircles[j];
                    if([self.selectedShangQuan isEqualToString:subCircle.text]){
                        [self.pickerView selectRow:j inComponent:1 animated:YES];
                        break;
                    }
                }
                break;
            }
        }
        
    }else{
        
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
    }

}

//=============================  UIPickview ==========================================

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.circle.children.count;
    }
    if(self.currentChengQu != nil){
        for(Circle *circle in [self.circle getChildren]){
            if( [circle.text isEqualToString:self.currentChengQu]){
                return circle.children.count;
            }
        }
    }
    Circle *circle = [self.circle getChildren][0];
    return circle.children.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        Circle *circle = [self.circle getChildren][row];
        return circle.text ;
    }
    for(Circle *circle in [self.circle getChildren]){
        if( [circle.text isEqualToString:self.currentChengQu]){
            Circle *currentCircle = [circle getChildren][row];
            return currentCircle.text;
        }
    }
    Circle *circle = [self.circle getChildren][0];
    Circle *currentCircle = [circle getChildren][row];
    return currentCircle.text;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        Circle *circle = [self.circle getChildren][row];
        self.currentChengQu = circle.text;
        [self.pickerView reloadComponent:1];
    }else if(component == 1){
        for(Circle *circle in [self.circle getChildren]){
            if( [circle.text isEqualToString:self.currentChengQu]){
                Circle *currentCircle = [circle getChildren][row];
                self.currentShangQuan = currentCircle.text;
            }
        }
    }
}

- (IBAction)confirmEvent:(id)sender {
    NSInteger chengquRow = [self.pickerView selectedRowInComponent:0];
    Circle *circle = [self.circle getChildren][chengquRow];
    self.selectedChengQu = circle.text;
    NSInteger shangquanRow = [self.pickerView selectedRowInComponent:1];
    circle = [circle getChildren][shangquanRow];
    self.selectedShangQuan = circle.text;
    
    if([self.delegate respondsToSelector:@selector(selectedAreaAndCircle)]){
        [self.delegate selectedAreaAndCircle];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
    }];
}

-(void) hideSelf{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
    }];
}

- (IBAction)cancelEvent:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
    }];
}
@end
