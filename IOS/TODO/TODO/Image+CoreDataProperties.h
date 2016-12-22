//
//  Image+CoreDataProperties.h
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import ".Image+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
