//
//  AppModel.m
//  PhotoAndMe
//
//  Created by LeTienDung on 6/1/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import "AppModel.h"

static AppModel *sharedInstance = nil;

@implementation AppModel

@synthesize syncInProgress = _syncInProgress;   

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




@end
