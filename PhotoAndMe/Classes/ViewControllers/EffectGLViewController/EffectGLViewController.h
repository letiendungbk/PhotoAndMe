//
//  EffectGLViewController.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "EffectGLView.h"


// Set this value to 1 to use PVRTC compressed texture, 0 to use a PNG
//#define USE_PVRTC_TEXTURE   1

@class GLView;
@interface EffectGLViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    GLuint		texture[1];
}

- (void)drawView:(EffectGLView*)view;
- (void)setupView:(EffectGLView*)view;

@property (retain, nonatomic) IBOutlet EffectGLView *glView;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *anchorPoints;
@property (retain, nonatomic) UIImage *effectImage;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)changeEffectImageHandler:(id)sender;
- (IBAction)changeBGImageHandler:(id)sender;

@end
