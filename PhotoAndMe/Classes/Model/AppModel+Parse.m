//
//  AppModel+Parse.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/4/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AppModel+Parse.h"
#import <Parse/Parse.h>

@implementation AppModel (Parse)

#pragma mark Category table

- (void)loadCategoriesWithCallback:(GalleryCallbackBlock)aCallbackBlock
{
    [self loadCategoriesFrom:nil WithCallback:aCallbackBlock];
}

- (void)loadCategoriesFrom:(NSDate *)lastUpdateTime WithCallback:(GalleryCallbackBlock)aCallbackBlock
{
    PFQuery *categoriesQuery = [PFQuery queryWithClassName:@"Category"];
    if (lastUpdateTime != nil) {
        [categoriesQuery whereKey:@"updatedAt" greaterThan:lastUpdateTime];
    }
    
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        aCallbackBlock(objects, error);
    }];
}



#pragma mark PhotoFrame table

- (void)loadAllPhotoFramesFrom:(NSDate *)lastUpdateTime WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock
{
    [self loadPhotoFramesForCategory:nil From:lastUpdateTime WithCallback:aCallbackBlock];
}

- (void)loadPhotoFramesForCategory:(NSString *)parseObjectId WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock
{
    [self loadPhotoFramesForCategory:parseObjectId From:nil WithCallback:aCallbackBlock];
}

- (void)loadPhotoFramesForCategory:(NSString *)parseObjectId From:(NSDate *)lastUpdateTime WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock
{
    PFQuery *photoFramesQuery = [PFQuery queryWithClassName:@"PhotoFrame"];
    
    if (parseObjectId != nil) {
        [photoFramesQuery whereKey:@"belongsToCategories" containsAllObjectsInArray:@[parseObjectId]];
    }
    
    if (lastUpdateTime != nil) {
        [photoFramesQuery whereKey:@"updatedAt" greaterThan:lastUpdateTime];
    }
    
    [photoFramesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        aCallbackBlock(objects, error);
    }];
}

#pragma mark add category
- (void)addCategoryWithDisplayName:(NSString *)displayName ThumbFile:(UIImage *)thumbImage WithCallback:(AddCategoryCallbackBlock)aCallbackBlock
{
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, 0.05f);
    
    PFFile *imageFile = [PFFile fileWithName:@"thumbFile.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *category = [PFObject objectWithClassName:@"Category"];
            [category setObject:imageFile forKey:@"thumbFile"];
            [category setObject:displayName forKey:@"displayName"];
            
            [category saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    aCallbackBlock(succeeded, error);
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    
}


@end
