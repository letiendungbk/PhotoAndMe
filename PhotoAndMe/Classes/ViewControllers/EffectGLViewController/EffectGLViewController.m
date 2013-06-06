//
//  EffectGLViewController.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "EffectGLViewController.h"
#import "EffectGLView.h"
#import "OpenGLCommon.h"
#import "ConstantsAndMacros.h"

#define kChooseEffectImageTag 704
#define kChooseBGImageTag 705

typedef struct {
	Vertex2D tl;
	Vertex2D tr;
	Vertex2D bl;
	Vertex2D br;
} Quadrilateral;

static GLint vseg = 10;
static GLint hseg = 10;

static Quadrilateral dCoor = {
    {-1.0,  1.5},
    { 1.0,  1.0},
    {-1.0, -1.0},
    { 1.0, -1.0}
};
//    {-0.8,  1.0},
//    { 1.15,  1.2},
//    {-1.0, -0.7},
//    { 0.93, -1.3}
//};

static Vertex3D vertices[4];
static Vertex2D texCoords[4];

static inline Vertex3D get_line_intersection(float p0_x, float p0_y, float p1_x, float p1_y,
                           float p2_x, float p2_y, float p3_x, float p3_y)
{
    float i_x = 0.0f;
    float i_y = 0.0f;
    
    float s1_x, s1_y, s2_x, s2_y;
    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;
    
//    float s;
    float t;
//    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
//    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
//    {
        // Collision detected
            i_x = p0_x + (t * s1_x);
            i_y = p0_y + (t * s1_y);
//    }
    
    return Vertex3DMake(i_x, i_y, -0.0);
}

static inline Vertex2D getSegmentPoint(Vertex2D vertex0, Vertex2D vertex1, GLfloat segmentPer)
{
    return Vertex2DMake(vertex0.x + (vertex1.x - vertex0.x) * segmentPer, vertex0.y + (vertex1.y - vertex0.y) * segmentPer);
}

static inline Vertex3D convertVertextCoordinate(Vertex2D vertex)
{
    GLfloat gx = vertex.x;
    GLfloat gy = vertex.y;
    
    Vertex2D p0 = getSegmentPoint(dCoor.tl, dCoor.tr, gx);
    Vertex2D p1 = getSegmentPoint(dCoor.bl, dCoor.br, gx);
    Vertex2D p2 = getSegmentPoint(dCoor.tl, dCoor.bl, gy);
    Vertex2D p3 = getSegmentPoint(dCoor.tr, dCoor.br, gy);
    
    Vertex3D result =  get_line_intersection(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    return result;
}

static inline void setupCoordinateForSegment(int hSegIndex, int vSegIndex)
{
    GLfloat hsLen = 1.0 / hseg;
    GLfloat vsLen = 1.0 / vseg;
    
    texCoords[0].x = hSegIndex * hsLen;
    texCoords[0].y = (vSegIndex + 1) * vsLen;
    texCoords[1].x = (hSegIndex + 1) * hsLen;
    texCoords[1].y = (vSegIndex + 1) * vsLen;
    texCoords[2].x = hSegIndex * hsLen;
    texCoords[2].y = vSegIndex * vsLen;
    texCoords[3].x = (hSegIndex + 1) * hsLen;
    texCoords[4].y = vSegIndex * vsLen;
    
    vertices[0]= convertVertextCoordinate(texCoords[0]);
    vertices[1]= convertVertextCoordinate(texCoords[1]);
    vertices[2]= convertVertextCoordinate(texCoords[2]);
    vertices[3]= convertVertextCoordinate(texCoords[3]);
}


@implementation EffectGLViewController

@synthesize effectImage = _effectImage;

- (void)drawView:(GLView*)view
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    glLoadIdentity();
    glTranslatef(0.0, 0.0, -3.0);
//    glScalef(1.0, -1.0, 1.0);
    
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    
    int ix = 0;
    int iy = 0;
    
    for ( ix = 0 ; ix < hseg ; ix++ ){
        for ( iy = 0 ; iy < vseg ; iy++ ){
            setupCoordinateForSegment(ix, iy);
            glVertexPointer(3, GL_FLOAT, 0, vertices);
            glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        }
    }
    
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void)setupView:(UIView *)view
{
    [self changeDCoor];
    
	const GLfloat zNear = 0.01, zFar = 1000.0;
//    const GLfloat fieldOfView = 45.0;
//	GLfloat size;
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
//	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds;
//	CGRect rect = CGRectMake(0, 0, 300, 300);
    glOrthof(-1.0,                                          // Left
             1.0,                                          // Right
             -1.0 / (rect.size.width / rect.size.height),   // Bottom
             1.0 / (rect.size.width / rect.size.height),   // Top
             zNear,                                         // Near
             zFar);
// 	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size /
//			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);
	glMatrixMode(GL_MODELVIEW);
    
    glEnable(GL_MULTISAMPLE);
    
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    //FIXME setEffectImage NEED TO CALLED AFTER SETUPVIEW
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    self.effectImage = image;
    [texData release];
    [image release];
}

- (void)setEffectImage:(UIImage *)effectImage
{
    if (_effectImage != effectImage) {
        [_effectImage release];
        
        UIImage *editedImage = [self editTexttureSizeAndAntiAlias:effectImage];
        _effectImage = [editedImage retain];
        
        
        
        UIImage *image = _effectImage;
        
        if (image == nil)
            NSLog(@"Do real error checking here");
        
        
        GLuint width = CGImageGetWidth(image.CGImage);
        GLuint height = CGImageGetHeight(image.CGImage);
        
        // Turn necessary features on
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_SRC_COLOR);
        
        //glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
        
        // Bind the number of textures we need, in this case one.
        glGenTextures(1, &texture[0]);
        glBindTexture(GL_TEXTURE_2D, texture[0]);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        //FIXME STILL NOT UNBIND TEXTTURE AFTER ASSIGN NEW UIIMAGE
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        void *imageData = malloc( height * width * 4 );
        CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
        
        // Flip the Y-axis
        CGContextTranslateCTM (context, 0, height);
        CGContextScaleCTM (context, 1.0, -1.0);
        
        CGColorSpaceRelease( colorSpace );
        CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
        CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
        
        CGContextRelease(context);
        
        free(imageData);
    }

}

- (UIImage *)editTexttureSizeAndAntiAlias:(UIImage *)originalImage
{
    int antialiasWidth = 4;
    
    int width = CGImageGetWidth(originalImage.CGImage) + 2 * antialiasWidth;
    int height = CGImageGetHeight(originalImage.CGImage) + 2 * antialiasWidth;
    
    int power = 1;
    while (width >= 2 ) {
        width >>= 1;
        power++;
    }
    
    width = pow(2, power);
    
    power = 1;
    while (height >= 2 ) {
        height >>= 1;
        power++;
    }
    
    height = pow(2, power);
    

    CGSize size = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 255.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    CGContextDrawImage(context, CGRectMake(antialiasWidth, antialiasWidth, width - 2 *antialiasWidth, height - 2 *antialiasWidth), originalImage.CGImage);
    
    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.glView.controller = self;
	self.glView.animationInterval = 1.0 / kRenderingFrequency;
	[self.glView startAnimation];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
    [_glView stopAnimation];
    
    [_glView release];
    [_anchorPoints release];
    [_bgImage release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAnchorPoints:nil];
    [self setBgImage:nil];
    [super viewDidUnload];
}

#pragma mark anchor Points
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [self changeDCoor];
}

- (void)changeDCoor
{
    UIView *anchorPoint1 = [self.anchorPoints objectAtIndex:0];
    UIView *anchorPoint2 = [self.anchorPoints objectAtIndex:1];
    UIView *anchorPoint3 = [self.anchorPoints objectAtIndex:2];
    UIView *anchorPoint4 = [self.anchorPoints objectAtIndex:3];
    
    dCoor.tl = [self convertFromScreenCoorToOpenGLCoor:Vertex2DMake(anchorPoint1.frame.origin.x, anchorPoint1.frame.origin.y)];
    dCoor.tr = [self convertFromScreenCoorToOpenGLCoor:Vertex2DMake(anchorPoint2.frame.origin.x, anchorPoint2.frame.origin.y)];
    dCoor.bl = [self convertFromScreenCoorToOpenGLCoor:Vertex2DMake(anchorPoint3.frame.origin.x, anchorPoint3.frame.origin.y)];
    dCoor.br = [self convertFromScreenCoorToOpenGLCoor:Vertex2DMake(anchorPoint4.frame.origin.x, anchorPoint4.frame.origin.y)];
}

- (Vertex2D)convertFromScreenCoorToOpenGLCoor:(Vertex2D)point
{
	CGRect rect = self.glView.bounds;
    return Vertex2DMake((point.x - rect.size.width/2)/(rect.size.width/2), (rect.size.height/2 - point.y)/(rect.size.width/2));
}

#pragma mark change Image

- (IBAction)changeEffectImageHandler:(id)sender {
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.view.tag = kChooseEffectImageTag;
    
    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)changeBGImageHandler:(id)sender {
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.view.tag = kChooseBGImageTag;
    
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //crop
    UIImage *selectedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!selectedImage)
    {
        return;
    }
    
    if (picker.view.tag  == kChooseEffectImageTag) {
        self.effectImage = selectedImage;
    } else {
        self.bgImage.image = selectedImage;
    }
}


@end
