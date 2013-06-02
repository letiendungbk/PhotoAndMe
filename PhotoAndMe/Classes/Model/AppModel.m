//
//  AppModel.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AppModel.h"
#import <Parse/Parse.h>

static AppModel *sharedInstance = nil;

@implementation AppModel

- (void)dealloc
{
    [super dealloc];
}

+ (AppModel *)getInstance
{
    if (!sharedInstance) {
        sharedInstance = [[AppModel alloc] init];
    }
    
    return sharedInstance;
}


- (void)loadGalleryWithCallback:(GalleryCallbackBlock)aCallbackBlock
{
    PFQuery *categoriesQuery = [PFQuery queryWithClassName:@"Categories"];
    
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        aCallbackBlock(objects, error);
    }];

}

- (void)loadPhotoFrameForCategory:(NSString *)categoryCode WithCallback:(PhotoFrameCallbackBlock)aCallbackBlock
{
    PFQuery *photoFramesQuery = [PFQuery queryWithClassName:@"PhotoFrames"];
    
    [photoFramesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        aCallbackBlock(objects, error);
    }];
}



@end
