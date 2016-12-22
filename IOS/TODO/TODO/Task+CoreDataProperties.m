//
//  Task+CoreDataProperties.m
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Task"];
}

@dynamic detail;
@dynamic end;
@dynamic hard;
@dynamic priority;
@dynamic start;
@dynamic status;
@dynamic tag;
@dynamic title;
@dynamic people;

@end
