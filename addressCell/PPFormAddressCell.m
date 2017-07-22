
//
//  PPFormAddressCell.m
//  amezMall_New
//
//  Created by Liao PanPan on 2017/7/7.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import "PPFormAddressCell.h"
#import "LSCityChooseView.h"

NSString * const XLFormRowDescriporTypeFormAddressCell = @"XLFormRowDescriporTypeFormAddressCell";

@implementation PPFormAddressCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([self class]) forKey:XLFormRowDescriporTypeFormAddressCell];
}


-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (IBAction)exportClick:(id)sender {
//     [[UIApplicationsharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
    
        
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (self.rowDescriptor.isDisabled) return;

    UIButton *btn = (UIButton *)sender;
    
    LSCityChooseView * view = [[LSCityChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    
    WEAK
    view.selectedBlock = ^(PPProviceInfoModel *model){
        STRONG
        NSString *result=[NSString stringWithFormat:@"%@-%@-%@",model.province,model.city,model.area];
        [btn setTitle:result forState:UIControlStateNormal];
        [btn setTitleColor:Door_BGBlack_color forState:UIControlStateNormal];
        self.rowDescriptor.value=model;
    };
    
    [kKeyWindow addSubview:view];

}

- (void)update
{
    [super update];
    
    UIColor *color =  self.rowDescriptor.isDisabled?RGB(130, 130, 130):Door_BGBlack_color;
    
    UIColor *btnColor =  self.rowDescriptor.isDisabled?RGB(130, 130, 130):RGB(130, 130,130);
    
    
    self.titleLabel.textColor=color;
    
    
    if (kObjectIsEmpty(self.rowDescriptor.value)) return;
    
    PPProviceInfoModel *model = self.rowDescriptor.value;
    [_addressBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.addressBtn setTitle:model.province_city_area forState:UIControlStateNormal];
    
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 44;
}

@end
