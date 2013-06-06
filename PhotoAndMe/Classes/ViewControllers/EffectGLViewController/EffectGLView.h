//
//  EffectGLView.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
@class EffectGLViewController;
@interface EffectGLView : UIView
{
	@private
	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	GLuint viewRenderbuffer, viewFramebuffer;
	GLuint depthRenderbuffer;
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;

	EffectGLViewController *controller;
	BOOL controllerSetup;
}

@property(nonatomic, assign) EffectGLViewController *controller;
@property NSTimeInterval animationInterval;

-(void)startAnimation;
-(void)stopAnimation;
-(void)drawView;

@end
