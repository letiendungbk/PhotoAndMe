//
//  AppModel.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//


@interface AppModel : NSObject
{
    
}

+ (AppModel *)getInstance;

@property (atomic, readwrite) BOOL syncInProgress;


@end
