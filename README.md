# XLForm_几个比较常用自定义的formBaseCell
## 自定义的formBaseCell
* 上传头像
* 地址选择器，包括省市区ID

[放在这儿]()

-----

一般自定义一个formBaseCell有固定的写法，这里拿地址选择器为例

PPFormAddressCell.h



```bash

#import <XLForm/XLForm.h>
extern NSString * const XLFormRowDescriporTypeFormAddressCell;
//需要一个全局字符串常量，作为rowType，唯一标识
@interface PPFormAddressCell : XLFormBaseCell

@end

```

PPFormAddressCell.m文件

```bash
#import "PPFormAddressCell.h"

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
//所有按钮的事件通过这里传出去，通过tag区分

self.rowDescriptor.action.formBlock(sender);

//用的时候这样
//                row.action.formBlock = ^(XLFormRowDescriptor * sender){
//                    
//                    UIButton *btn=(UIButton *)sender;
//                    NSLog(@"%d",sender.tag);
//                    
//                };
}

- (void)update
{
[super update];

}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
return 44;
}


```
### formRow的相关设置


* 右指示Icon

```bash
[row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
```


* 文字居右 

```bash
[row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
```



* 设置placeHolder

```bash
[row.cellConfigAtConfigure setObject:@"填写详细地址" forKey:@"textField.placeholder"];
```

* 设置颜色

```bash
[row.cellConfig setObject:RGB(130, 130, 130) forKey:@"textField.textColor"];
```


* 设置左边Label不同区域不同颜色 比如 姓名* 星号红色

```bash
-(NSMutableAttributedString *)setAttribut:(NSString *)str
{
//创建NSMutableAttributedString
NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];

//    //设置字体和设置字体的范围
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(0, 3)];
//添加文字颜色
[attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length-1, 1)];


return attrStr;
}
[row.cellConfig setObject:[self setAttribut:row.title] forKey:@"textLabel.attributedText"];

```

### XLForm 数据更新
在row.Value值更新的，需要调用 [self updateForm] 相当于tableView的ReloadData

这里有个代理方法

```bash
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
[super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
}
//在rowValue更新的时候会走这个方法
这里有个小坑，就是之前我在个代理方法里面直接加了这个方法[self updateFormRow:formRow]，然后测试的时候发现RowType为 text 的Row输入会数据错乱,
比如 第一次输入了A，第二次输入B的时候会输出AB。
后面发现是因为[self updateFormRow:formRow]的原因，这里一般只在有需要手动刷新value值得时候才调用该方法，比如

如果现在在A界面，要修改姓名，需要跳转到B界面，修改成功后在B的回调block{}则需要调用[self updateFormRow:formRow]，实时更新界面，在之前可以通过[formRow.tag isEqualToString:@""]判断，只刷新对应tag的row； 

```


### 顺便举个动态添加行的🌰

```bash
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
[super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
if ([formRow.tag isEqualToString:@"isMetering"]){

if ([formRow.value boolValue]) {

row = [XLFormRowDescriptor formRowDescriptorWithTag:@"meteringCompany" rowType:XLFormRowDescriptorTypeSelectorPickerView title:@"计量单位"];
row.selectorOptions = @[
[XLFormOptionsObject formOptionsObjectWithValue:@"克" displayText:@"克"],
[XLFormOptionsObject formOptionsObjectWithValue:@"倆" displayText:@"倆"],
[XLFormOptionsObject formOptionsObjectWithValue:@"斤" displayText:@"斤"],
];

NSString *meterStr =kObjectIsEmpty(self.jsModel.meteringCompany)?@"克":self.jsModel.meteringCompany;

row.value = [XLFormOptionsObject formOptionsObjectWithValue:meterStr displayText:meterStr];
[row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];

[self.form addFormRow:row afterRow:formRow];
[self updateFormRow:formRow];


}else
{
[self.form removeFormRowWithTag:@"meteringCompany"];
[self updateFormRow:formRow];

}

}
//这里是有一个 tag为 isMetering ， type为switch的row，在打开开关的时候新增一行row，关闭的时候在移除。

里面有用到 updateFormRow ， 必须要放到对应的row方法，不能更新到所有的row

}
```

### 获取表单数据，为空验证
* 获取表单数据

```bash
NSDictionary *formDic=[self httpParameters];
//字典里的key值就是初始化cell的那个tag值，我一般都是以要上传的字段为tag值，这样一般情况下不用处理可以直接Post到Serivce

```

* 在设置的时候，可以控制是否为必选，必选情况下为空弹出对应的字符串,比如

```bash
row = [XLFormRowDescriptor formRowDescriptorWithTag:@"goodsPrice" rowType:XLFormRowDescriptorTypeDecimal];
row.required=@YES;
row.requireMsg=@"请输入零售价";
[sectionForm addFormRow:row];

```
验证

```bash
NSLog(@"%@",validationErrors);
if (validationErrors.count>0) {
NSDictionary *dic=[[validationErrors firstObject] userInfo];
[PPHUDHelp showMessage:dic[@"NSLocalizedDescription"]];
return ;
}
//如果为空的时候弹出 @"请输入零售价"

```
* rowValue不同值类型
* 
row.value 有俩种赋值方式，一种是直接显示，row.value = id;
另外一种场景就是， 我要显示的比如是 男， 但是我要传到服务器的值是1，这个时候赋值  

```bash
row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"1" displayText:@"男"];
```




