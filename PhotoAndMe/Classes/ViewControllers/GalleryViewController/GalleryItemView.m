//
//  GalleryItemView.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "GalleryItemView.h"

@implementation GalleryItemView

@synthesize data = _data;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.thumbImage = nil;
    self.nameLabel = nil;
    
    self.data = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Setup Data

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    if(_data == (id)[NSNull null])return;
    
    NSString *userUrl = [_data objectForKey:@"thumbURL"];
    self.thumbImage.imageView.image = nil;
    [self.thumbImage loadImageFromUrlString: userUrl];
    
    self.nameLabel.text = [_data objectForKey:@"displayName"];
}

#pragma mark -
#pragma mark lazy image delegate

- (void) lazyImageDidFailToLoadImageFromUrl:(NSString *)imageUrl
{
    // always retry loading
}



@end
