//
//  FaceView.h
//  Motic
//
//  Created by Rose CW on 9/9/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceView : UIView

@property (strong) UIColor* faceColor;
@property CGPoint touchPoint;
//@property UIImage* faceImage;
-(UIImage*)saveFaceImage;
@end
