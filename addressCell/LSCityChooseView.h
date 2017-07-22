//
//  LSCityChooseView.h
//  LSCityChoose
//
//  Created by lisonglin on 26/04/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPProviceInfoModel.h"

typedef void(^SelectedHandle)(PPProviceInfoModel *model);

@interface LSCityChooseView : UIView

@property(nonatomic, copy) SelectedHandle selectedBlock;

@end
