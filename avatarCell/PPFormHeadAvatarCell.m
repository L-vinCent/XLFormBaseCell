//
//  PPFormHeadAvatarCell.m
//  amezMall_New
//
//  Created by Liao PanPan on 2017/7/7.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import "PPFormHeadAvatarCell.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

NSString * const XLFormRowDescriporTypeFormHeadAvatarCell = @"XLFormRowDescriporTypeFormHeadAvatarCell";

@interface PPFormHeadAvatarCell ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UIImagePickerController *pickerController;

@end
@implementation PPFormHeadAvatarCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([self class]) forKey:XLFormRowDescriporTypeFormHeadAvatarCell];
}


-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    self.headImageView.userInteractionEnabled=YES;
    [self.headImageView addGestureRecognizer:tap];
//    [self.headImageView zy_cornerRadiusRoundingRect];
 

}
-(void)awakeFromNib
{
    [super awakeFromNib];

    self.headImageView.layer.cornerRadius=35/2;
    self.headImageView.layer.masksToBounds=YES;
}

- (void)headClick:(UITapGestureRecognizer *)tap {
    
    if (self.rowDescriptor.isDisabled) return;
    
    [self showSheetAlert];
    
}


- (void)update
{
    [super update];
    
    UIColor *color =  self.rowDescriptor.isDisabled?RGB(130, 130, 130):Door_BGBlack_color;
    
    _headTitleLabel.textColor=color;
    
    if(kObjectIsEmpty(self.rowDescriptor.value)) return;
    
    UIImage *image= (UIImage *)self.rowDescriptor.value;
    
    [self.headImageView setImage:image];
    
    
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 44;
}


-(void)showSheetAlert
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    actionSheet.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH  , SCREEN_HEIGHT);
    actionSheet.actionSheetStyle = UIBarStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}


-(void)configPhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        NSLog(@"没有访问相机权限");
        return;
    }
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author ==PHAuthorizationStatusDenied){
        //无权限
        NSLog(@"没有访问相册的权限");
        return;
    }
    
    
    
    
    
}

- (UIImagePickerController *)pickerController{
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.allowsEditing=YES;
        _pickerController.delegate = self;
    }
    return _pickerController;
}

#pragma mark ================UIActionSheetDelegate========

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"点击了头像要修改呦！");
    
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"支持相机");
            _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.viewController presentViewController:self.pickerController animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else  if (buttonIndex == 1){//图片库
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSLog(@"支持图库");
            _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.viewController presentViewController:self.pickerController animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }
}
#pragma mark =============UIImagePickerControllerDelegate=======
//用户点击取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%@",picker);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
}

//这里是用户选中图片(照相后的使用图片或者图库中选中图片)时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s,info == %@",__func__,info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    

    [picker dismissViewControllerAnimated:YES completion:^{
        
        //上传头像到服务器
        self.rowDescriptor.value=image;
        [self update];
    }];

    
}
@end
