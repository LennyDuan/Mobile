//
//  People+CoreDataProperties.h
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import ".People+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface People (CoreDataProperties)

+ (NSFetchRequest<People *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *close;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *relation;
@property (nullable, nonatomic, retain) NSSet<Task *> *tasks;

@end

@interface People (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet<Task *> *)values;
- (void)removeTasks:(NSSet<Task *> *)values;

@end

NS_ASSUME_NONNULL_END
