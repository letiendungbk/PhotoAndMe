//
//  AddCategoryViewController.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/13/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UITextField *displayNameField;
@property (retain, nonatomic) IBOutlet UIImageView *thumbFileImage;

- (IBAction)chooseFileHandler:(id)sender;

- (IBAction)addCategoryHandler:(id)sender;

@end
