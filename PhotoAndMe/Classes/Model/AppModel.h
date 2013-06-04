//
//  AppModel.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

typedef void (^GalleryCallbackBlock)(NSArray *objects, NSError *error);
typedef void (^PhotoFrameCallbackBlock)(NSArray *objects, NSError *error);
typedef void (^ImageCallbackBlock)(UIImage *image, NSError *error);

@interface AppModel : NSObject
{
    
}

+ (AppModel *)getInstance;

- (void)loadCategoriesWithCallback:(GalleryCallbackBlock)aCallbackBlock;
- (void)loadCategoriesFrom:(NSDate *)lastUpdateTime WithCallback:(GalleryCallbackBlock)aCallbackBlock;

- (void)loadPhotoFrameForCategory:(NSString *)parseObjectId WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock;
- (void)loadPhotoFrameForCategory:(NSString *)parseObjectId From:(NSDate *)lastUpdateTime WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock;

@end
