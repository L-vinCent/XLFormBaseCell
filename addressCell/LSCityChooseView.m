//
//  LSCityChooseView.m
//  LSCityChoose
//
//  Created by lisonglin on 26/04/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import "LSCityChooseView.h"
#define PICKERHEIGHT 216
#define BGHEIGHT     256

#define KEY_WINDOW_HEIGHT [UIApplication sharedApplication].keyWindow.frame.size.height

@interface LSCityChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@property(nonatomic, strong) NSMutableDictionary *proviceDic;

/**
 pickerView
 */
@property(nonatomic, strong) UIPickerView * pickerView;
/**
 bgView
 */
@property(nonatomic, strong) UIView * bgView;

/**
 toolBar
 */
@property(nonatomic, strong) UIView * toolBar;

/**
 取消按钮
 */
@property(nonatomic, strong) UIButton * cancleBtn;

/**
 确定按钮
 */
@property(nonatomic, strong) UIButton * sureBtn;


/**
 省
 */
@property(nonatomic, strong) NSArray * provinceArray;

/**
 市
 */
@property(nonatomic, strong) NSArray * cityArray;

/**
 区
 */
@property(nonatomic, strong) NSArray * areaArray;
/**
 所有数据
 */
@property(nonatomic, strong) NSArray * dataSource;

/**
 记录省选中的位置
 */
@property(nonatomic, assign) NSInteger selected;


/**
 记录城市选中的位置
 */
@property(nonatomic, assign) NSInteger selected_city;

@property(nonatomic, assign) NSInteger selected_area;
///**
// 选中的省
// */
@property(nonatomic, copy) NSString * provinceStr;

/**
 选中的市
 */
@property(nonatomic, copy) NSString * cityStr;

/**
 选中的区
 */
@property(nonatomic, copy) NSString * areaStr;

@end

@implementation LSCityChooseView

#pragma mark -- lazy

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(10, 5, 50, BGHEIGHT - PICKERHEIGHT - 10);
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancleBtn.layer.borderColor = Door_BGBlack_color.CGColor;
        _cancleBtn.layer.borderWidth = 0.5;
        _cancleBtn.layer.cornerRadius = 5;
        _cancleBtn.backgroundColor = Door_BGBlack_color;
        [_cancleBtn setTitleColor:Door_Global_title forState:UIControlStateNormal];

        [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(self.frame.size.width - 60, 5, 50, BGHEIGHT - PICKERHEIGHT - 10);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.layer.borderColor = Door_BGBlack_color.CGColor;
        _sureBtn.layer.borderWidth = 0.5;
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.backgroundColor = Door_BGBlack_color;
        [_sureBtn setTitleColor:Door_Global_title forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, BGHEIGHT - PICKERHEIGHT)];
        _toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _toolBar;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, BGHEIGHT)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, BGHEIGHT - PICKERHEIGHT, self.frame.size.width, PICKERHEIGHT)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (NSArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSArray array];
    }
    return _provinceArray;
}

- (NSArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSArray array];
    }
    return _cityArray;
}

- (NSArray *)areaArray
{
    if (!_areaArray) {
        _areaArray = [NSArray array];
    }
    return _areaArray;
}

#pragma mark -- init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.proviceDic = @{}.mutableCopy;
        self.selected = 0;
        self.selected_city=0;
        self.selected_area=0;
        [self initSuViews];
        [self loadDatas];
    }
    return self;
}

#pragma mark -- 从plist里面读数据
- (void)loadDatas
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"cityCode" ofType:@"plist"];
    self.dataSource = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary * tempDic in self.dataSource) {
        
//        for (int i = 0; i < tempDic.allKeys.count; i ++) {
//            [tempArray addObject:tempDic.allKeys[i]];
//        }
        NSString *provice  = tempDic[@"provinceName"];
        
        [tempArray addObject:provice];
        
    }
    //省
    self.provinceArray = [tempArray copy];
    //市
    self.cityArray = [self getCityNamesFromProvince:0];
    //区
    self.areaArray = [self getAreaNamesFromCity:0];
    
    

    NSString *proviceId = [self id_getProviceId:0];
    NSString *cityId=[self id_getCityId:0];
    NSString *areaId=[self id_getAreaId:0];
//
    [self.proviceDic setObject:proviceId forKey:@"provinceId"];
    [self.proviceDic setObject:cityId forKey:@"cityId"];
    [self.proviceDic setObject:areaId forKey:@"areaId"];
    
    [self.proviceDic setObject:self.provinceArray[0] forKey:@"province"];
    [self.proviceDic setObject:self.cityArray[0] forKey:@"city"];
    [self.proviceDic setObject:self.areaArray[0] forKey:@"area"];
    
    self.provinceStr = self.provinceArray[0];
    self.cityStr = self.cityArray[0];
    self.areaStr = self.areaArray[0];
    
    
    
    
}

- (NSString *)id_getProviceId:(NSInteger)row
{    
    NSDictionary * tempDic =  self.dataSource[self.selected];
        
    NSString *provice  = tempDic[@"provinceId"];
    
//    NSLog(@"省----id--%@",provice);

    return provice.copy;

}

- (NSString *)id_getCityId:(NSInteger)row
{
    
    NSArray * listCity =self.dataSource[self.selected][@"listCity"];
    
    NSDictionary *cityDic = listCity[self.selected_city];
        
    NSString *cityName = cityDic[@"cityId"];
    
    
//    NSLog(@"城市----id--%@",cityName);

    return cityName.copy;
    
}

- (NSString *)id_getAreaId:(NSInteger)row
{
    
    NSArray * listCity =self.dataSource[self.selected][@"listCity"];
    
    NSDictionary *cityDic = listCity[self.selected_city];
    
   NSArray *listArea = cityDic[@"listArea"];
    
    
    NSDictionary *areaDic = listArea[self.selected_area];
    
    NSString *areaId = areaDic[@"areaId"];
//    NSLog(@"区域----id--%@",areaId);

    return areaId.copy;
    
}


- (NSArray *)getAreaNamesFromCity:(NSInteger)row
{

    NSMutableArray * tempArray = [NSMutableArray array];
    
    NSArray * listCity =self.dataSource[self.selected][@"listCity"];
    
    NSDictionary *cityDic =listCity[row];
    
    NSArray *listArea = cityDic[@"listArea"];
        
    for (NSDictionary *areaDic in listArea) {
            
            NSString *AreaName = areaDic[@"areaName"];
            [tempArray addObject:AreaName];
    }
    
    return [tempArray copy];

}

- (NSArray *)getCityNamesFromProvince:(NSInteger)row
{
    NSMutableArray * tempArray = [NSMutableArray array];

    NSArray * listCity =self.dataSource[row][@"listCity"];
    
    for (NSDictionary *cityDic in listCity) {
        
        NSString *cityName = cityDic[@"cityName"];
        [tempArray addObject:cityName];
    }

    return [tempArray copy];
}


#pragma mark -- loadSubViews
- (void)initSuViews
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.toolBar];
    [self.bgView addSubview:self.pickerView];
    [self.toolBar addSubview:self.cancleBtn];
    [self.toolBar addSubview:self.sureBtn];
    
    [self showPickerView];
}

#pragma mark -- showPickerView
- (void)showPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bgView.frame = CGRectMake(0, self.frame.size.height - BGHEIGHT, self.frame.size.width, BGHEIGHT);
    }];
}


- (void)hidePickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, self.frame.size.height , self.frame.size.width, BGHEIGHT);

        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -- UIPickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1){
        return self.cityArray.count;
    }else if (component == 2){
        return self.areaArray.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 30)];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        label.text = self.provinceArray[row];
    }else if (component == 1){
        label.text = self.cityArray[row];
    }else if (component == 2){
        label.text = self.areaArray[row];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {//选择省
        self.selected = row;
        self.selected_city=0;
        self.selected_area=0;
        
        
        self.cityArray = [self getCityNamesFromProvince:row];
        self.areaArray = [self getAreaNamesFromCity:0];
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
        
        self.provinceStr = self.provinceArray[row];
        self.cityStr = self.cityArray[0];
        self.areaStr = self.areaArray[0];
        
    }else if (component == 1){//选择市
        
        self.selected_city=row;
        self.selected_area=0;
        
        
        self.areaArray = [self getAreaNamesFromCity:row];
        
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.cityStr = self.cityArray[row];
        self.areaStr = self.areaArray[0];

        
    }else if (component == 2){//选择区
        self.selected_area=row;
        self.areaStr = self.areaArray[row];
        
    }
    
    [self setPositionIDInfo:row];

}

-(void)setPositionIDInfo:(NSInteger)row
{

    
    NSString *proviceId = [self id_getProviceId:row];
    NSString *cityId=[self id_getCityId:row];
    NSString *areaId=[self id_getAreaId:row];
    //
    [self.proviceDic setObject:proviceId forKey:@"provinceId"];
    [self.proviceDic setObject:cityId forKey:@"cityId"];
    [self.proviceDic setObject:areaId forKey:@"areaId"];
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


#pragma mark -- Button
- (void)cancleBtnClick
{
    [self hidePickerView];
}

- (void)sureBtnClick
{
    [self hidePickerView];

    if (self.selectedBlock != nil) {
        
        [self.proviceDic setObject:self.provinceStr forKey:@"province"];
        [self.proviceDic setObject:self.cityStr forKey:@"city"];
        [self.proviceDic setObject:self.areaStr forKey:@"area"];
        NSString *result=[NSString stringWithFormat:@"%@-%@-%@",self.provinceStr,self.cityStr,self.areaStr];
        
        [self.proviceDic setObject:result forKey:@"province_city_area"];
        PPProviceInfoModel *model = [PPProviceInfoModel mj_objectWithKeyValues:self.proviceDic];
        self.selectedBlock(model);
        
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        [self hidePickerView];
    }
}

@end
