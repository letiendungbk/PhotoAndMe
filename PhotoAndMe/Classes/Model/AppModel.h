//
//  AppModel.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

typedef void (^GalleryCallbackBlock)(NSArray *objects, NSError *error);
typedef void (^PhotoFrameCallbackBlock)(NSArray *objects, NSError *error);

@interface AppModel : NSObject
{
    
}

+ (AppModel *)getInstance;

- (void)loadGalleryWithCallback:(GalleryCallbackBlock)aCallbackBlock;
- (void)loadPhotoFrameForCategory:(NSString *)categoryCode WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock;

@end
