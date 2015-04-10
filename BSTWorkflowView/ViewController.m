//
//  ViewController.m
//  BSTWorkflowView
//
//  Created by Bruce on 15/4/9.
//  Copyright (c) 2015年 Bsito. All rights reserved.
//

#import "ViewController.h"
#import "BSTWorkflowControl.h"

@interface ViewController ()
{
    BSTWorkflowControl *workflowControl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"screen w is %.2f", [UIScreen mainScreen].bounds.size.width);
    
    CGRect workflowControlFrame = CGRectMake(0, 50, CGRectGetWidth([UIScreen mainScreen].bounds), 50);
    workflowControl = [[BSTWorkflowControl alloc] initWithFrame:workflowControlFrame];
    workflowControl.currentStepColor = [UIColor orangeColor];
    workflowControl.otherStepColor = [UIColor grayColor];
//    workflowControl.backgroundColor = [UIColor orangeColor];
    workflowControl.numberOfStep = 6;
    workflowControl.currentIndex = 3;
    [workflowControl addTarget:self action:@selector(workflowControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:workflowControl];
    
    
    
}


- (void)workflowControlValueChanged:(BSTWorkflowControl *)control
{
    NSLog(@"current index is %ld", control.currentIndex);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    workflowControl.currentStepTitle = [NSString stringWithFormat:@"0%ld XXXYYYYYY", workflowControl.currentIndex];
    
    [workflowControl next];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
