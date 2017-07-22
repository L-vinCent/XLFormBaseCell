//
//  PPFormAddressCell.h
//  amezMall_New
//
//  Created by Liao PanPan on 2017/7/7.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString * const XLFormRowDescriporTypeFormAddressCell;

@interface PPFormAddressCell : XLFormBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;


@end
