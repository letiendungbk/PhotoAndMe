//
//  GalleryItemView.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "ViewLoadedFromNib.h"
#import "LazyImageView.h"

@interface GalleryItemView : ViewLoadedFromNib <LazyImageViewDelegate>
{
}

@property (retain, nonatomic) IBOutlet LazyImageView *thumbImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) NSDictionary* data;

@end