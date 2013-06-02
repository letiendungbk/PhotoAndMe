//
//  ViewController.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
{
    
}


@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewResult;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *anchorPoints;


- (IBAction)startEffectHandler:(id)sender;
- (IBAction)skewEffectHandler:(id)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

@end
