//
//  BSTWorkflowControl.m
//  BSTWorkflowView
//
//  Created by Bruce on 15/4/9.
//  Copyright (c) 2015年 Bsito. All rights reserved.
//

#import "BSTWorkflowControl.h"

#define Arrow_W     15
#define Border_W    1

@implementation BSTWorkflowControl
{
   NSMutableArray *titleArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //set default values
        _currentIndex = 0;
        _numberOfStep = 2;
        _currentStepColor = [UIColor blueColor];
        _otherStepColor = [UIColor grayColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        titleArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _numberOfStep; i++) {
            [titleArray addObject:@""];
        }
        
        _currentStepTitle = [titleArray firstObject];
        
        [self setNeedsDisplay];
    }
    
    return self;
}

- (void)setCurrentStepColor:(UIColor *)currentStepColor
{
    if (_currentStepColor != currentStepColor) {
        _currentStepColor = currentStepColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex >= _numberOfStep) {
        
        currentIndex = _numberOfStep - 1;
        return;
    }
    
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        
        [self setNeedsDisplay];
    }
}

- (void)setNumberOfStep:(NSInteger)numberOfStep
{
    if (_numberOfStep != numberOfStep) {
        _numberOfStep = numberOfStep;
        
        [titleArray removeAllObjects];
        for (int i = 0; i < _numberOfStep; i++) {
            [titleArray addObject:@""];
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setCurrentStepTitle:(NSString *)currentStepTitle
{
    _currentStepTitle = currentStepTitle;
    
    CAShapeLayer *currentLayer = [self.layer.sublayers objectAtIndex:_currentIndex];
    CATextLayer *textLayer = [currentLayer.sublayers firstObject];
    
    textLayer.string = _currentStepTitle;
    [textLayer setNeedsDisplay];
    
    [titleArray replaceObjectAtIndex:_currentIndex withObject:_currentStepTitle];
}

- (void)next
{
    if (_currentIndex < _numberOfStep - 1) {
        _currentIndex ++;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat currentLayer_W = 136;
    CGFloat layer_X = 0;
    CGFloat layer_W = (CGRectGetWidth(self.bounds) - currentLayer_W - Border_W * (_numberOfStep - 1)) / (_numberOfStep - 1) + Arrow_W;
    
    NSLog(@"number is %ld layer_W  is %.2f", _numberOfStep, layer_W);
    
    CGFloat layer_H = CGRectGetHeight(self.bounds);
    
    CGFloat textLayer_X = Arrow_W;
    CGFloat textLayer_H = 21;
    CGFloat textLayer_Y = (layer_H - textLayer_H) / 2.0;

    for (int i = 0; i < _numberOfStep; i++) {
        
        //current step is much wider
        CGFloat finalLayer_W = _currentIndex == i ? currentLayer_W : layer_W;

        UIColor *fillColor = _currentIndex == i ? _currentStepColor : _otherStepColor;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(layer_X, 0, finalLayer_W, layer_H);
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = fillColor.CGColor;
        layer.lineCap = kCALineCapSquare;
        layer.path = [self bezierPathWithSize:layer.frame.size index:i].CGPath;
        layer.lineWidth = Border_W;
        layer.strokeStart = 0.0f;
        layer.strokeEnd = 0.0f;
        
        //config textlayer
        CATextLayer *textLayer = [CATextLayer layer];
        
        CGFloat textLayer_W = finalLayer_W - textLayer_X;
        
        //
        CGFloat finalText_X = i == 0 ? textLayer_X : (textLayer_X * 2);
        CGFloat finalText_W = i == 0 ? textLayer_W - 5 : (finalLayer_W - finalText_X);
        
        UIColor *textColor = _currentIndex == i ? [UIColor whiteColor] : [UIColor blackColor];
        
        NSString *title = [titleArray objectAtIndex:i];
        
        //if it is the current step, show the whole title
        NSString *finalTitle = (title.length >= 2 && _currentIndex!= i) ? [title substringToIndex:2] : title;
        
        textLayer.frame = CGRectMake(finalText_X, textLayer_Y, finalText_W, textLayer_H);
        textLayer.string = finalTitle;
        textLayer.foregroundColor = textColor.CGColor;
        textLayer.fontSize = 17;
        textLayer.contentsScale = 3;
        textLayer.truncationMode = @"end";
//        textLayer.alignmentMode = @"center";
//        textLayer.position = CGPointMake(15, 15);
        
        [layer addSublayer:textLayer];
        
        [self.layer addSublayer:layer];
        
        //important
        layer_X += (finalLayer_W - Arrow_W + Border_W);
    }
}

- (UIBezierPath *)bezierPathWithSize:(CGSize)size index:(int)index
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    //point 1 start point
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    
    //if the second point is belong to last step, set x as the whole width
    CGFloat secondPoint_X = index == _numberOfStep - 1 ? size.width : size.width - Arrow_W;
    
    //point 2
    [bezierPath addLineToPoint:CGPointMake(secondPoint_X, 0)];
    
    if (index != _numberOfStep - 1) {
        //point 3
        [bezierPath addLineToPoint:CGPointMake(size.width, size.height / 2.0)];
    }
    
    //if the forth point is belong to last step, set x as the whole width
    CGFloat forthPoint_X = secondPoint_X;
    
    //point 4
    [bezierPath addLineToPoint:CGPointMake(forthPoint_X, size.height)];
    
    //point 5
    [bezierPath addLineToPoint:CGPointMake(0, size.height)];
    
    //if it is not the first step, set sixth point
    if (index != 0) {
        //point 6
        [bezierPath addLineToPoint:CGPointMake(Arrow_W, size.height / 2.0)];
    }
    
    //connect to the start point
    [bezierPath closePath];
    
    return bezierPath;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        
        CAShapeLayer *subLayer = [self.layer.sublayers objectAtIndex:i];
        
        if (CGRectContainsPoint(subLayer.frame, touchPoint)) {
            _currentIndex = i;
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        }
    }
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
