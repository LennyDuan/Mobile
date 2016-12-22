//
//  Image+CoreDataProperties.m
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Image+CoreDataProperties.h"

@implementation Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Image"];
}

@dynamic imageData;
@dynamic title;

@end
