//
//  BSTWorkflowControl.h
//  BSTWorkflowView
//
//  Created by Bruce on 15/4/9.
//  Copyright (c) 2015年 Bsito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTWorkflowControl : UIControl

@property (nonatomic, assign) NSInteger currentIndex;     //当前索引，默认0
@property (nonatomic, assign) NSInteger numberOfStep;               //总步骤数，默认为2
@property (nonatomic, strong) UIColor *currentStepColor;            //当前步骤背景色
@property (nonatomic, strong) UIColor *otherStepColor;              //其它步骤背景色
@property (nonatomic, copy) NSString *currentStepTitle;             //当前步骤标题

- (void)next;

@end
