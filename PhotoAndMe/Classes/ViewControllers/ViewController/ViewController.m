//
//  ViewController.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView.image = [self imageWithBorderFromImage:[UIImage imageNamed:@"invaderzim_smal.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageView release];
    [_anchorPoints release];
    [_imageViewResult release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setAnchorPoints:nil];
    [self setImageViewResult:nil];
    [super viewDidUnload];
}

- (IBAction)startEffectHandler:(id)sender {
    struct CRTriangle triangle;
    triangle.point1 = ((UIView *)[self.anchorPoints objectAtIndex:0]).frame.origin;
    triangle.point2 = ((UIView *)[self.anchorPoints objectAtIndex:1]).frame.origin;
    triangle.point3 = ((UIView *)[self.anchorPoints objectAtIndex:2]).frame.origin;
    
    self.imageView.image = [self clipImage:[UIImage imageNamed:@"invaderzim.jpg"] withTriangle:triangle];
}

- (IBAction)skewEffectHandler:(id)sender {
    struct CRTriangle triangle;
    triangle.point1 = ((UIView *)[self.anchorPoints objectAtIndex:3]).frame.origin;
    triangle.point2 = ((UIView *)[self.anchorPoints objectAtIndex:4]).frame.origin;
    triangle.point3 = ((UIView *)[self.anchorPoints objectAtIndex:5]).frame.origin;
    
    self.imageViewResult.image = [self skewImage:self.imageView.image ToTriangle:triangle];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}


#pragma mark Image Processing

struct CRTriangle {
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
};
typedef struct CRTriangle CRTriangle;

- (UIImage*)clipImage:(UIImage*)source withTriangle:(CRTriangle)triangle
{
    CGSize size = CGSizeMake(triangle.point2.x - triangle.point1.x, triangle.point3.y - triangle.point1.y);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context =  UIGraphicsGetCurrentContext();

    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    CGContextTranslateCTM(context, -triangle.point1.x, -triangle.point1.y);
    CGContextRotateCTM(context, atan2f(triangle.point3.x - triangle.point1.x, triangle.point3.y - triangle.point1.y));
    
    CGContextSaveGState(context);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGContextBeginPath (context);
    CGContextMoveToPoint(context, triangle.point1.x, triangle.point1.y);
    CGContextAddLineToPoint(context, triangle.point2.x, triangle.point2.y);
    CGContextAddLineToPoint(context, triangle.point3.x, triangle.point3.y);
    CGContextClosePath(context);
    
    CGContextAddPath(context, path);
    
    CGContextClip(context);
    CGPathRelease(path);
    
    CGContextDrawImage(context, CGRectMake(0, 0, source.size.width, source.size.height), source.CGImage);
    
    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage*)skewImage:(UIImage*)source ToTriangle:(CRTriangle)triangle
{
    CGSize size = CGSizeMake(triangle.point2.x - triangle.point1.x, triangle.point3.y - triangle.point1.y);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    CGContextSaveGState(context);
    
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0.5, -0.15, 1, 50, 0));
    
    CGContextDrawImage(context, CGRectMake(0, 0, source.size.width, source.size.height), source.CGImage);
    
    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return result;
}



- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = CGSizeMake(400, 400);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGContextGetCTM(context);
    
//    CGContextConcatCTM(context, CGAffineTransformInvert(transform));
//    
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0.5, -0.15, 1, 50, 0));
    
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)] fill];
    
    
    CGRect rect = CGRectMake(0, 0, 200, 300);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return testImg;
}



@end
