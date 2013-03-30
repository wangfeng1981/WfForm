//
//  ViewController.h
//  WfForm
//
//  Created by Wang Feng on 13-3-29.
//  Copyright (c) 2013年 jfwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WfFormController.h"
@interface ViewController : UIViewController
{
    WfFormController* formController ;
}

-(IBAction)onUseForm:(id)sender ;

//
-(void)onPostTimeValueChanged:(id)sender ;
-(void)pickerChanged1:(id)sender ;
@end
