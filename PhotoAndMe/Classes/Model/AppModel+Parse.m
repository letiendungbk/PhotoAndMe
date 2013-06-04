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

#pragma mark Categories table

- (void)loadCategoriesWithCallback:(GalleryCallbackBlock)aCallbackBlock
{
    [self loadCategoriesFrom:nil WithCallback:aCallbackBlock];
}

- (void)loadCategoriesFrom:(NSDate *)lastUpdateTime WithCallback:(GalleryCallbackBlock)aCallbackBlock
{
    PFQuery *categoriesQuery = [PFQuery queryWithClassName:@"Categories"];
    if (lastUpdateTime != nil) {
        [categoriesQuery whereKey:@"updatedAt" greaterThanOrEqualTo:lastUpdateTime];
    }
    
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        aCallbackBlock(objects, error);
    }];
}

#pragma mark PhotoFrames table

- (void)loadPhotoFrameForCategory:(NSString *)parseObjectId WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock
{
    [self loadPhotoFrameForCategory:parseObjectId From:nil WithCallback:aCallbackBlock];
}

- (void)loadPhotoFrameForCategory:(NSString *)parseObjectId From:(NSDate *)lastUpdateTime WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock
{
    PFQuery *photoFramesQuery = [PFQuery queryWithClassName:@"PhotoFrames"];
    
    [photoFramesQuery whereKey:@"belongsToCategories" containsAllObjectsInArray:@[parseObjectId]];
    if (lastUpdateTime != nil) {
        [photoFramesQuery whereKey:@"updatedAt" greaterThanOrEqualTo:lastUpdateTime];
    }
    
    [photoFramesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        aCallbackBlock(objects, error);
    }];
}

@end
