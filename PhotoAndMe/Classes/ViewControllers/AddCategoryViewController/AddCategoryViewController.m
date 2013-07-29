//
//  AddCategoryViewController.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/13/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "AppModel.h"
#import "AppModel+Parse.h"
#import "AppModel+CoreData.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title
{
    return @"Add Category";
}

- (IBAction)chooseFileHandler:(id)sender {
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)addCategoryHandler:(id)sender {
    [[AppModel getInstance] addCategoryWithDisplayName:self.displayNameField.text ThumbFile:self.thumbFileImage.image WithCallback:^(BOOL succeeded, NSError *error) {
        [[AppModel getInstance] startSync];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    
    self.thumbFileImage.image = selectedImage;
}

- (void)dealloc {
    [_displayNameField release];
    [_thumbFileImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDisplayNameField:nil];
    [self setThumbFileImage:nil];
    [super viewDidUnload];
}
@end
