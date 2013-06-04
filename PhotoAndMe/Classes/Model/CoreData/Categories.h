//
//  Categories.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/4/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoFrames;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * thumbFileURL;
@property (nonatomic, retain) NSSet *photoFrames;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addPhotoFramesObject:(PhotoFrames *)value;
- (void)removePhotoFramesObject:(PhotoFrames *)value;
- (void)addPhotoFrames:(NSSet *)values;
- (void)removePhotoFrames:(NSSet *)values;

@end
