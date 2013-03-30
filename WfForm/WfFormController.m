//
//  WfFormController.m
//  xinglifang
//
//  Created by Wang Feng on 13-1-30.
//  Copyright (c) 2013年 jfwf. All rights reserved.
//

#import "WfFormController.h"
#import "UIGlossyButton.h"
#import "MyTool.h"

#define WFFORM_TEXTBOXCELL_TEXTWIDTH 280
#define WFFORM_RELEASE(p) if(p){[p release];p=nil;}

@implementation WfFormCell
@synthesize orderTag,actionTarget,valueChangedAction,inputType,switcherValue;//assign
@synthesize keyboardType,useSecurity,textBoxCellHeight ;//assign

@synthesize  placeHolder,pickerDataSource,labelText,buttonColor,textValue,textValueFont;//retain

-(void)dealloc
{
    actionTarget = nil ;
    WFFORM_RELEASE(buttonColor);
    WFFORM_RELEASE(labelText);
    WFFORM_RELEASE(pickerDataSource) ;
    WFFORM_RELEASE(textValue) ;
    WFFORM_RELEASE(placeHolder) ;
    WFFORM_RELEASE(textValueFont) ;
    [super dealloc] ;
}

-(id)init
{
    self = [super init] ;
    if( self )
    {
        self.keyboardType = UIKeyboardTypeDefault ;
        self.useSecurity = NO ;
        self.textBoxCellHeight = 44.f ;
    }
    return self ;
}

#pragma mark - Table view cell
+(WfFormCell*)textFieldCell:(NSString*)labeltext value:(NSString*)val target:(id)target valueChanged:(SEL)action
{
    WfFormCell* cell = [[[WfFormCell alloc] init] autorelease] ;
    cell.inputType = WfFormCellTypeTextField ;
    cell.labelText = labeltext ;
    cell.textValue = val ;
    cell.actionTarget = target ;
    cell.valueChangedAction = action ;
    return cell ;
}
+(WfFormCell*)pickerCell:(NSString*)labeltext value:(NSString*)val datasrc:(NSArray*)array target:(id)target valueChanged:(SEL)action
{
    WfFormCell* cell = [[[WfFormCell alloc] init] autorelease] ;
    cell.inputType = WfFormCellTypePicker ;
    cell.labelText = labeltext ;
    cell.textValue = val ;
    cell.actionTarget = target ;
    cell.valueChangedAction = action ;
    cell.pickerDataSource = array ;
    return cell ;
}
+(WfFormCell*)switcherCell:(NSString*)labeltext value:(BOOL)val target:(id)target valueChanged:(SEL)action
{
    WfFormCell* cell = [[[WfFormCell alloc] init] autorelease] ;
    cell.inputType = WfFormCellTypeSwitcher ;
    cell.labelText = labeltext ;
    cell.switcherValue = val ;
    cell.actionTarget = target ;
    cell.valueChangedAction = action ;
    return cell ;
}
+(WfFormCell*)buttonCell:(NSString*)labeltext target:(id)tar tapAction:(SEL)act btnColor:(UIColor*)bcolor
{
    WfFormCell* cell = [[[WfFormCell alloc] init] autorelease] ;
    cell.inputType = WfFormCellTypeButton ;
    cell.labelText = labeltext ;
    cell.actionTarget = tar ;
    cell.valueChangedAction = act ;
    cell.buttonColor = bcolor ;
    return cell ;
}
+(WfFormCell*)textBoxCell:(NSString*)val
{
    WfFormCell* cell = [[[WfFormCell alloc] init] autorelease] ;
    cell.inputType = WfFormCellTypeTextBox ;
    cell.textValue = val ;
    
    UIFont* tfont = [UIFont fontWithName:@"STHeitiTC-Medium" size:15] ;
    cell.textBoxCellHeight = [cell.textValue sizeWithFont:tfont constrainedToSize:CGSizeMake(WFFORM_TEXTBOXCELL_TEXTWIDTH, 999)].height;
    return cell ;
}


@end




//________________________________________________________
#pragma mark - WfFormSection
@implementation WfFormSection
@synthesize cellArray,title ;
-(void)dealloc
{
    WFFORM_RELEASE(cellArray) ;
    WFFORM_RELEASE(title) ;
    [super dealloc] ;
}
+(WfFormSection*)sectionTitle:(NSString*)tlt cells:(NSArray*)array
{
    WfFormSection* sec = [[[WfFormSection alloc] init] autorelease] ;
    sec.title = tlt ;
    sec.cellArray = array ;
    return sec ;
}

@end



//________________________________________________________
#pragma mark - WfFormController
@interface WfFormController ()

@end

@implementation WfFormController
-(void)dealloc
{
    WFFORM_RELEASE(block_completion) ;
    WFFORM_RELEASE(sectionArray) ;
    WFFORM_RELEASE(textFieldTableCellArray) ;

    [super dealloc] ;
}

- (id)initWithStyle:(UITableViewStyle)style andSectionArray:(NSArray*)array willComplete:(BOOL(^)(void))completionblock
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        sectionArray = [array retain] ;
        NSMutableArray* mTFCellArray = [[[NSMutableArray alloc] init] autorelease] ;
        int order = 1 ;
        for (WfFormSection* sec in sectionArray) {
            for (WfFormCell* cell in sec.cellArray) {
                cell.orderTag = order++ ;
                if( cell.inputType == WfFormCellTypePicker )
                {
                    [mTFCellArray addObject:[self tableView:self.tableView pickerCell:cell]] ;
                }else if(  cell.inputType==WfFormCellTypeTextField  )
                {
                    [mTFCellArray addObject:[self tableView:self.tableView textFieldCell:cell]] ;
                }
            }
        }
        //quick text field cell array
        textFieldTableCellArray = [[NSArray alloc] initWithArray:mTFCellArray] ;

        //copy block_completion
        block_completion = [completionblock copy] ;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //..
    UIBarButtonItem* formDone = [[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onFormDone)] autorelease] ;
    self.navigationItem.rightBarButtonItem = formDone ;
    
    //inset space.
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    WfFormSection* sec = (WfFormSection*)[sectionArray objectAtIndex:section] ;
    return [sec.cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    WfFormSection* section = (WfFormSection*)[sectionArray objectAtIndex:indexPath.section];
    WfFormCell* fcell = (WfFormCell*)[section.cellArray objectAtIndex:indexPath.row] ;
    if( fcell.inputType == WfFormCellTypeButton )
    {
        return [self tableView:tableView buttonCell:fcell] ;
    }else if( fcell.inputType==WfFormCellTypeTextField )
    {
        return [self textFieldTableCellByTag:fcell.orderTag] ; // textfield
    }else if( fcell.inputType == WfFormCellTypePicker )
    {
        return [self textFieldTableCellByTag:fcell.orderTag] ; //textfiled
    }else if( fcell.inputType == WfFormCellTypeSwitcher )
    {
        return [self tableView:tableView switcherCell:fcell] ;
    }else if( fcell.inputType==WfFormCellTypeTextBox )
    {
        return [self tableView:tableView textBoxCell:fcell] ;
    }else
        return nil ;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WfFormSection* sec = (WfFormSection*)[sectionArray objectAtIndex:section];
    return sec.title ;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WfFormSection* sec = (WfFormSection*)[sectionArray objectAtIndex:indexPath.section] ;
    WfFormCell* fcell = [sec.cellArray objectAtIndex:indexPath.row] ;
    if( fcell.inputType==WfFormCellTypeButton )
    {
        
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WfFormSection* section = (WfFormSection*)[sectionArray objectAtIndex:indexPath.section];
    WfFormCell* fcell = (WfFormCell*)[section.cellArray objectAtIndex:indexPath.row] ;
    if( fcell.inputType==WfFormCellTypeTextBox )
    {
        
        return 20+fcell.textBoxCellHeight ;
    }else return 44.f ;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}




//Private methods.................................
#pragma mark - Form Cell Builders.
-(UITableViewCell*)tableView:(UITableView*)tableView textFieldCell:(WfFormCell*)fcell
{
    UITableViewCell *cell = nil ;//[tableView dequeueReusableCellWithIdentifier:@"PCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15] ;
    }
    cell.tag = fcell.orderTag ;
    cell.textLabel.text = fcell.labelText ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    //..
    
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 200, 24)]  ;
    tf.center = CGPointMake(tf.center.x, 22) ;
    tf.textAlignment = NSTextAlignmentRight ;
    tf.delegate = self ;
    [cell.contentView addSubview:tf] ;
    tf.tag = fcell.orderTag ;
    tf.keyboardType = fcell.keyboardType ;
    tf.secureTextEntry = fcell.useSecurity ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo ;
    tf.placeholder = fcell.placeHolder ;
    
    
    if( fcell.textValue )
        tf.text = fcell.textValue ;
    [MyTool addDonePreNextButtonTo:tf andTarget:self doneAct:@selector(onEditDone:) prevNextAct:@selector(onPrevNext:)] ;
    [tf release] ;
    tf = nil ;
    return cell ;
}


-(UITableViewCell*)tableView:(UITableView*)tableView pickerCell:(WfFormCell*)fcell
{
    UITableViewCell *cell = nil ;//[tableView dequeueReusableCellWithIdentifier:@"PCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15] ;
    }
    cell.tag = fcell.orderTag ;
    cell.textLabel.text = fcell.labelText ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    //..
    
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 200, 24)]  ;
    tf.center = CGPointMake(tf.center.x, 22) ;
    tf.textAlignment = NSTextAlignmentRight ;
    tf.delegate = self ;
    [cell.contentView addSubview:tf] ;
    tf.tag = fcell.orderTag ;
    
    UIPickerView* picker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)] autorelease] ;
    picker.showsSelectionIndicator = YES ;
    picker.delegate = self ;
    tf.inputView = picker ;
    tf.text = fcell.textValue ;
    picker.tag = fcell.orderTag ;
    
    [MyTool addDonePreNextButtonTo:tf andTarget:self doneAct:@selector(onEditDone:) prevNextAct:@selector(onPrevNext:)] ;
    [tf release] ;
    tf = nil ;
    return cell ;
}


-(UITableViewCell*)tableView:(UITableView*)tableView switcherCell:(WfFormCell*)fcell
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PCell"] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15] ;
    }
    cell.textLabel.text = fcell.labelText ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    //..
    
    UISwitch* swi = [[[UISwitch alloc] initWithFrame:CGRectMake(320-115, 0, 95, 27)] autorelease] ;
    swi.center = CGPointMake(swi.center.x, 22) ;
    [swi setOn:fcell.switcherValue] ;
    [swi addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged] ;
    [cell.contentView addSubview:swi] ;
    swi.tag = fcell.orderTag ;
    return cell ;
}
-(UITableViewCell*)tableView:(UITableView*)tableView buttonCell:(WfFormCell*)fcell
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PCell"] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    UIGlossyButton* gloss = [[[UIGlossyButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)] autorelease] ;
    [gloss setNavigationButtonWithColor:fcell.buttonColor];
    [gloss useWhiteLabel:YES] ;
    [gloss setTitle:fcell.labelText forState:UIControlStateNormal] ;
    gloss.tag = fcell.orderTag ;
    cell.backgroundColor = [UIColor clearColor] ;

    //..
    [cell.contentView addSubview:gloss] ;
    
    return cell ;
}
-(UITableViewCell*)tableView:(UITableView*)tableView textBoxCell:(WfFormCell*)fcell 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BCell"] autorelease];
    }
    //..
    //cell.textLabel.backgroundColor = [UIColor clearColor] ;
    //cell.backgroundColor = [UIColor clearColor] ;
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, WFFORM_TEXTBOXCELL_TEXTWIDTH, fcell.textBoxCellHeight)] autorelease] ;
    label.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15] ; 
    label.numberOfLines = 0 ;
    label.text = fcell.textValue ;
    [cell.contentView addSubview:label] ;
    return cell ;
}

-(WfFormCell*)formCellByTag:(int)tag
{
    for (WfFormSection* sec in sectionArray) {
        for (WfFormCell* cell in sec.cellArray) {
            if(cell.orderTag==tag) return cell ;
        }
    }
    return nil ;
}
-(UITableViewCell*)textFieldTableCellByTag:(int)tag
{
    for (UITableViewCell* tcell in textFieldTableCellArray) {
        if( tcell.tag == tag)
            return tcell ;
    }
    return nil ;
}
-(UITextField*)textFieldByTag:(int)tag 
{
    UITableViewCell* tcell = [self textFieldTableCellByTag:tag] ;
    for (UIView* v1 in tcell.contentView.subviews) {
        if(v1.tag==tag && [v1 isKindOfClass:[UITextField class]] )
        {
            return (UITextField*)v1 ;
        }
    }
    return nil ;
}
#pragma mark - custom event listeners.
-(void)onFormDone
{
    // do block codes
    if( block_completion )
        if( block_completion()==NO ) return ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

-(void)onEditDone:(id)sender
{
    UIView* view1 = (UIView*)sender ;
    int tag = view1.tag ;
    UITextField* textField = [self textFieldByTag:tag  ] ;
    [textField resignFirstResponder] ;
}
-(void)onPrevNext:(id)sender
{
    UISegmentedControl* s = (UISegmentedControl*)sender ;
    int iseg = s.selectedSegmentIndex ;
    int tag = s.tag ;

    UITextField* currentTF = [self textFieldByTag:tag  ] ;
    if( currentTF && currentTF.isFirstResponder )
    {
        //[currentTF endEditing:YES] ;
        [currentTF resignFirstResponder] ;
        NSLog(@"cur %d resign ++++",currentTF.tag);
    }
    
    for (int i = 0; i<[textFieldTableCellArray count]; i++) {
        UITableViewCell* tcell = (UITableViewCell*)[textFieldTableCellArray objectAtIndex:i] ;
        if( tcell.tag == tag )
        {
            NSLog(@"cur tag in quick");
            int newQuickIndex = i-1 ;
            if( iseg == 1) newQuickIndex = i+1 ;
            if( newQuickIndex>=0 && newQuickIndex<[textFieldTableCellArray count] )
            {
                NSLog(@"new index in quick %d",newQuickIndex) ;
                UITableViewCell* newTCell = (UITableViewCell*)[textFieldTableCellArray objectAtIndex:newQuickIndex] ;
                UITextField* newTF = [self textFieldByTag:newTCell.tag  ] ;
                if( newTF )
                {
                    [newTF becomeFirstResponder] ;
                    NSLog(@"new %d do first",newTF.tag) ;
                }else NSLog(@"newTF nil,newTag %d",newTCell.tag);
            }
            NSLog(@"for out");
            break ;
        }
    }
    
}



//@protocol UIPickerViewDataSource<NSObject>------------------
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    WfFormCell* fcell = [self formCellByTag:pickerView.tag] ;
    return [fcell.pickerDataSource count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    WfFormCell* fcell = [self formCellByTag:pickerView.tag] ;
    NSArray* subarray = (NSArray*)[fcell.pickerDataSource objectAtIndex:component] ;
    return [subarray count];
}
//@protocol UIPickerViewDelegate<NSObject>-------------------

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    WfFormCell* fcell = [self formCellByTag:pickerView.tag] ;
    NSArray* subarray = (NSArray*)[fcell.pickerDataSource objectAtIndex:component] ;
    return (NSString*)[subarray objectAtIndex:row] ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    WfFormCell* fcell = [self formCellByTag:pickerView.tag] ;
    UITextField* tf = [self textFieldByTag:pickerView.tag  ] ;
    NSMutableString* mstr = [[NSMutableString alloc] init] ;
    for (int i = 0 ; i<[fcell.pickerDataSource count] ; i++) {
        NSArray* arr = (NSArray*)[fcell.pickerDataSource objectAtIndex:i] ;
        [mstr appendString:(NSString*)[arr objectAtIndex:[pickerView selectedRowInComponent:i]]] ;
    }
    tf.text = mstr ;
    fcell.textValue = mstr ;
    [tf reloadInputViews] ;
    [mstr release] ;
    mstr=nil ;
    NSLog(@"picker changed.%@",tf.text) ;
    if( fcell.actionTarget )
        [fcell.actionTarget performSelector:fcell.valueChangedAction withObject:pickerView] ;
}


#pragma mark - UITextFieldDelegate methods.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.tableView.userInteractionEnabled = NO ;
    //textField.backgroundColor = [UIColor colorWithRed:0.90f green:1.f blue:0.92f alpha:1.f] ;
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    WfFormCell* fcell = [self formCellByTag:textField.tag] ;
    if( fcell )
    {
        if (fcell.inputType==WfFormCellTypePicker) {
            //UIPickerView* picker = (UIPickerView*)textField.inputView ;
            //[picker selectRow:fcell.pickerValue inComponent:0 animated:YES] ;
        }
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    WfFormCell* fcell = [self formCellByTag:textField.tag] ;
    fcell.textValue = textField.text ;
    self.tableView.userInteractionEnabled = YES ;
}
@end
