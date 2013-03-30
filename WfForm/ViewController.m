//
//  ViewController.m
//  WfForm
//
//  Created by Wang Feng on 13-3-29.
//  Copyright (c) 2013年 jfwf. All rights reserved.
//

#import "ViewController.h"
#import "WfFormController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onUseForm:(id)sender
{
    WfFormCell* textCell0 = [WfFormCell textFieldCell:@"User Name" value:@"" target:nil valueChanged:nil] ;
    textCell0.keyboardType = UIKeyboardTypeEmailAddress ;
    textCell0.placeHolder = @"please input your name." ;
    WfFormCell* textCell1 = [WfFormCell textFieldCell:@"Password" value:@"" target:nil valueChanged:nil] ;
    textCell1.useSecurity = YES ;
    
    NSArray* cellArray0 = [NSArray arrayWithObjects:textCell0,textCell1, nil] ;
    WfFormSection* section0 = [WfFormSection sectionTitle:nil cells:cellArray0] ;
    
    
    NSArray* ds0 = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"工作日",@"节假日",@"任何时间",nil],nil] ;
    WfFormCell* picker0 = [WfFormCell pickerCell:@"配送时间" value:@"工作日" datasrc:ds0 target:self valueChanged:@selector(onPostTimeValueChanged:)] ;
    
    NSArray* shengArray = [NSArray arrayWithObjects:@"北京市",@"辽宁省",@"山西省", nil] ;
    NSArray* cityArray = [NSArray arrayWithObjects:@"朝阳区",@"海淀区",@"丰台区",@"昌平区", nil];
    NSArray* ds1 = [NSArray arrayWithObjects:shengArray,cityArray, nil] ;
    WfFormCell* picker1 = [WfFormCell pickerCell:@"区域" value:@"北京市 朝阳区" datasrc:ds1 target:self valueChanged:@selector(pickerChanged1:)] ;
    WfFormSection* section1 = [WfFormSection sectionTitle:@"配送方式" cells:[NSArray arrayWithObjects:picker0,picker1,nil]];
    
    WfFormCell* boxCell = [WfFormCell textBoxCell:@"拿到试玩版本。我一直觉得创意虽然重要，但游戏精品拼的是细节的把握。小魔女做得很棒，特别是那条扫描线提示下落的时间很贴心。继续挑战去了，各位尽情羡慕我吧。"] ;
    WfFormSection* section2 = [WfFormSection sectionTitle:@"长文本" cells:[NSArray arrayWithObjects:boxCell,nil]] ;
    
    
    NSArray* sectionArray = [NSArray arrayWithObjects:section0,section1,section2, nil] ;
    WfFormController* formControl = [[WfFormController alloc] initWithStyle:UITableViewStyleGrouped andSectionArray:sectionArray willComplete:^(void){
        NSLog(@"User Name: %@",textCell0.textValue) ;
        NSLog(@"Password: %@",textCell1.textValue) ;
        return YES ;
    }] ;
    formController = formControl ;
    [formControl autorelease] ;
    [self.navigationController pushViewController:formControl animated:YES] ;
}

-(void)onPostTimeValueChanged:(id)sender
{
    UIPickerView* picker = (UIPickerView*)sender ;
    int n = picker.numberOfComponents ;
    for (int i = 0; i<n; i++) {
        NSLog(@"Picker component sel changed %d",[picker selectedRowInComponent:i]) ;
    }
}
-(void)pickerChanged1:(id)sender
{
    NSArray* shengArray = [NSArray arrayWithObjects:@"北京市",@"辽宁省",@"山西省", nil] ;
    NSArray* cityArray0 = [NSArray arrayWithObjects:@"朝阳区",@"海淀区",@"丰台区",@"昌平区", nil];
    NSArray* cityArray1 = [NSArray arrayWithObjects:@"沈阳市",@"大连市",@"鞍山市",@"抚顺市",@"辽阳市",@"营口市", nil];
    NSArray* cityArray2 = [NSArray arrayWithObjects:@"大同市",@"太原市",@"阳泉市",@"吕梁市",@"临汾市",@"运城市",@"晋城市",@"朔州市", nil];
    NSArray* cityArrayArray = [NSArray arrayWithObjects:cityArray0,cityArray1,cityArray2, nil] ;
    UIPickerView* picker = (UIPickerView*)sender ;
    WfFormCell* fcell = [formController formCellByTag:picker.tag] ;
    int isheng = [picker selectedRowInComponent:0] ;
    //int icity = [picker selectedRowInComponent:1] ;
    fcell.pickerDataSource = [NSArray arrayWithObjects:shengArray,[cityArrayArray objectAtIndex:isheng], nil] ;
    [picker reloadAllComponents] ;
    
    UITextField* tf = [formController textFieldByTag:picker.tag ] ;
    NSMutableString* mstr = [[NSMutableString alloc] init] ;
    for (int i = 0 ; i<[fcell.pickerDataSource count] ; i++) {
        NSArray* arr = (NSArray*)[fcell.pickerDataSource objectAtIndex:i] ;
        [mstr appendString:(NSString*)[arr objectAtIndex:[picker selectedRowInComponent:i]]] ;
    }
    tf.text = mstr ;
    [mstr release] ;
}
@end
