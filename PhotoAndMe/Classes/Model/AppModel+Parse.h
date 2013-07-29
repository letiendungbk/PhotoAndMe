//
//  AppModel+Parse.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/4/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AppModel.h"

typedef void (^GalleryCallbackBlock)(NSArray *objects, NSError *error);
typedef void (^PhotoFrameCallbackBlock)(NSArray *objects, NSError *error);
typedef void (^ImageCallbackBlock)(UIImage *image, NSError *error);

typedef void (^AddCategoryCallbackBlock)(BOOL succeeded, NSError *error);

@interface AppModel (Parse)

- (void)loadCategoriesWithCallback:(GalleryCallbackBlock)aCallbackBlock;
- (void)loadCategoriesFrom:(NSDate *)lastUpdateTime WithCallback:(GalleryCallbackBlock)aCallbackBlock;

- (void)loadAllPhotoFramesFrom:(NSDate *)lastUpdateTime WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock;
- (void)loadPhotoFramesForCategory:(NSString *)parseObjectId WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock;
- (void)loadPhotoFramesForCategory:(NSString *)parseObjectId From:(NSDate *)lastUpdateTime WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock;

- (void)addCategoryWithDisplayName:(NSString *)displayName ThumbFile:(UIImage *)thumbImage WithCallback:(AddCategoryCallbackBlock)aCallbackBlock;

@end
