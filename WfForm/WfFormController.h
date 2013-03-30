//
//  WfFormController.h
//  xinglifang
//
//  Created by Wang Feng on 13-1-30.
//  Copyright (c) 2013年 jfwf. All rights reserved.
//

#import <UIKit/UIKit.h>

enum WfFormCellType
{
    WfFormCellTypeTextField ,
    WfFormCellTypePicker,
    WfFormCellTypeSwitcher,
    WfFormCellTypeButton,
    WfFormCellTypeTextBox
};
typedef enum WfFormCellType WfFormCellType;

@interface WfFormCell : NSObject
{
    int orderTag ;
    NSString* labelText ;
    WfFormCellType inputType ;
    NSString* textValue ;
    BOOL switcherValue ;
    id actionTarget ;
    SEL valueChangedAction ;//for button as tappedAction.
    NSArray* pickerDataSource ;
    UIColor* buttonColor ;
    UIKeyboardType keyboardType ;
    BOOL useSecurity ;
    NSString* placeHolder ;
    float textBoxCellHeight ;
    UIFont* textValueFont ;
}
@property(assign,nonatomic)int orderTag ;
@property(retain,nonatomic)NSString* labelText ;
@property(assign,nonatomic)WfFormCellType inputType ;
@property(retain,nonatomic)NSString* textValue ;
@property(assign,nonatomic)BOOL switcherValue ;
@property(assign,nonatomic)id actionTarget ;
@property(assign,nonatomic)SEL valueChangedAction ;
@property(retain,nonatomic)NSArray* pickerDataSource ;
@property(retain,nonatomic)UIColor* buttonColor ;
@property(assign,nonatomic)UIKeyboardType keyboardType ;
@property(assign,nonatomic)BOOL useSecurity ;
@property(retain,nonatomic)NSString* placeHolder ;
@property(assign,nonatomic)float textBoxCellHeight ;
@property(retain,nonatomic)UIFont* textValueFont ;

+(WfFormCell*)textFieldCell:(NSString*)labeltext value:(NSString*)val target:(id)target valueChanged:(SEL)action ;
+(WfFormCell*)pickerCell:(NSString*)labeltext value:(NSString*)val datasrc:(NSArray*)array target:(id)target valueChanged:(SEL)action;
+(WfFormCell*)switcherCell:(NSString*)labeltext value:(BOOL)val target:(id)target valueChanged:(SEL)action;
+(WfFormCell*)buttonCell:(NSString*)labeltext target:(id)tar tapAction:(SEL)act btnColor:(UIColor*)bcolor ;
+(WfFormCell*)textBoxCell:(NSString*)val ;


@end



@interface WfFormSection:NSObject
{
    NSString* title ;
    NSArray* cellArray ;
}
@property(retain,nonatomic)NSString* title  ;
@property(retain,nonatomic)NSArray* cellArray  ;
+(WfFormSection*)sectionTitle:(NSString*)tlt cells:(NSArray*)array ;
@end






@interface WfFormController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSArray* sectionArray ;
    NSArray* textFieldTableCellArray ;

    BOOL (^block_completion)(void) ;// return YES for completion.
}

- (id)initWithStyle:(UITableViewStyle)style andSectionArray:(NSArray*)array willComplete:(BOOL(^)(void))completionblock ;

//private
-(UITableViewCell*)tableView:(UITableView*)tableView pickerCell:(WfFormCell*)fcell ;
-(UITableViewCell*)tableView:(UITableView*)tableView textFieldCell:(WfFormCell*)fcell ;
-(UITableViewCell*)tableView:(UITableView*)tableView switcherCell:(WfFormCell*)fcell ;
-(UITableViewCell*)tableView:(UITableView*)tableView buttonCell:(WfFormCell*)fcell ;
-(UITableViewCell*)tableView:(UITableView*)tableView textBoxCell:(WfFormCell*)fcell ;

-(void)onEditDone:(id)sender ;
-(void)onPrevNext:(id)sender ;
//-(UITextField*)prevOrNextTextField:(int)currentTFtag prev:(BOOL)prev ;


-(void)onFormDone ;
-(WfFormCell*)formCellByTag:(int)tag ;
-(UITableViewCell*)textFieldTableCellByTag:(int)tag ;
-(UITextField*)textFieldByTag:(int)tag ;
@end
