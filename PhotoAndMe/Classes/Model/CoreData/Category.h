//
//  Category.h
//  PhotoAndMe
//
//  Created by LeTienDung on 6/7/13.
//  Copyright (c) 2013 LeTienDung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoFrame;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSString * thumbFileURL;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *photoFrames;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addPhotoFramesObject:(PhotoFrame *)value;
- (void)removePhotoFramesObject:(PhotoFrame *)value;
- (void)addPhotoFrames:(NSSet *)values;
- (void)removePhotoFrames:(NSSet *)values;

@end
