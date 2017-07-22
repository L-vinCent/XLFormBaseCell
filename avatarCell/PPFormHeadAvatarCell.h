//
//  PPFormHeadAvatarCell.h
//  amezMall_New
//
//  Created by Liao PanPan on 2017/7/7.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString * const XLFormRowDescriporTypeFormHeadAvatarCell;

@interface PPFormHeadAvatarCell : XLFormBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;

@end
