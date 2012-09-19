//
//  FaceView.m
//  Motico
//
//  Created by Rose CW on 8/25/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "FaceView.h"
#import <QuartzCore/QuartzCore.h>

@interface FaceView ()
@property float lowestControlPointY;
@property float highestControlPointY;
@property CGFloat bezierControlPointY;
@property CGFloat bezierControlPointX;
@property CGPoint center;
@property float maxRadius;

@end


@implementation FaceView
@synthesize bezierControlPointY;
@synthesize bezierControlPointX;
@synthesize center;
@synthesize maxRadius;
@synthesize faceColor;

@synthesize lowestControlPointY;
@synthesize highestControlPointY;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        CGRect bounds = self.bounds;
        
        //        self.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);

        
        self.center = CGPointMake(bounds.origin.x + bounds.size.width/2.0, bounds.origin.y + bounds.size.height/2.7);
        self.maxRadius = hypot(bounds.size.width, bounds.size.height)/4.0;
        
        self.bezierControlPointY = center.y + (self.maxRadius / 4.0);
        self.bezierControlPointX = center.x;
        
        self.lowestControlPointY = self.center.y + self.maxRadius * 1.5;
        self.highestControlPointY = self.center.y - self.maxRadius / 2.0;
        self.faceColor = [self calculateColor];
        self.backgroundColor = [self calculateColor];
        
    }
    return self;
}



- (void)drawRect:(CGRect)re
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    // Circle to frame face : without it the mouth doesn't draw right
    CGContextAddArc(ctx, self.center.x, self.center.y, self.maxRadius, 0.0, M_PI*2.0, YES);
    
    // Setup preferences  
    [self.faceColor set];
    CGContextSetLineWidth(ctx, 11.0);
    CGContextFillPath(ctx);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    
    // Two eyes
    [[UIColor blackColor]set];
    CGContextAddArc(ctx, (self.center.x - self.maxRadius/3.0), (self.center.y - self.maxRadius / 3.0), self.maxRadius/6.0, 0.0, M_PI*2.0, YES);
    CGContextAddArc(ctx, (self.center.x + self.maxRadius/3.0), (self.center.y - self.maxRadius / 3.0), self.maxRadius/6.0, 0.0, M_PI*2.0, YES);
    CGContextFillPath(ctx);
    
    
    // Start point for curve
    CGContextMoveToPoint(ctx, (self.center.x - self.maxRadius/1.5), self.center.y + self.maxRadius/4.0);
    
    //draw a curve for the mouth: cp1, cp2, endpt
    
    CGContextAddQuadCurveToPoint(ctx,
                                 self.bezierControlPointX, self.bezierControlPointY,
                                 (self.center.x + self.maxRadius/1.5), self.center.y + self.maxRadius/4.0);
    CGContextStrokePath(ctx);
    
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* currentTouch = [touches anyObject];
    self.touchPoint = [currentTouch locationInView:self];
    self.bezierControlPointX = self.touchPoint.x;
    self.bezierControlPointY = self.touchPoint.y;
    float differenceOnY = [currentTouch locationInView:self].y - [currentTouch previousLocationInView:self].y;
    
    if ( !(self.touchPoint.y+differenceOnY < self.highestControlPointY) && !(self.touchPoint.y+differenceOnY > self.lowestControlPointY)){
        self.bezierControlPointY+= differenceOnY;
        
        [self calculateColor];
        [self setNeedsDisplay];
        
    }
    
}




-(UIColor*)calculateColor{
    // color changes from red (high point on mouth) to green (low point on mouth)
    double hue = (1.0/3.0)-(self.bezierControlPointY-self.lowestControlPointY)/(self.highestControlPointY - self.lowestControlPointY)/3.0;
    self.faceColor = [UIColor colorWithHue:hue saturation:0.4 brightness:0.8 alpha:1.0];
    self.backgroundColor = self.faceColor;
    
    return faceColor;
    //    double hueY = (self.bezierControlPointY - self.lowestControlPointY)/(self.highestControlPointY - self.lowestControlPointY)*(firsthue-secondhue)+secondhue;
}



-(UIImage*)saveFaceImage{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    self.faceImage = viewImage;
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
}

;




@end
