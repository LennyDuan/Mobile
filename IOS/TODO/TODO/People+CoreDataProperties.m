//
//  People+CoreDataProperties.m
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "People+CoreDataProperties.h"

@implementation People (CoreDataProperties)

+ (NSFetchRequest<People *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"People"];
}

@dynamic address;
@dynamic close;
@dynamic email;
@dynamic mobile;
@dynamic name;
@dynamic relation;
@dynamic tasks;

@end
