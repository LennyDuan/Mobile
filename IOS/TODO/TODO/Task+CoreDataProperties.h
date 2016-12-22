//
//  Task+CoreDataProperties.h
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import ".Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *detail;
@property (nullable, nonatomic, copy) NSString *end;
@property (nullable, nonatomic, copy) NSString *hard;
@property (nullable, nonatomic, copy) NSString *priority;
@property (nullable, nonatomic, copy) NSString *start;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) People *people;

@end

NS_ASSUME_NONNULL_END
