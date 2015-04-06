//
//  CSTaskRevisionRealmModel.m
//  HubSync
//
//  Created by CommSync on 4/6/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "CSTaskRevisionRealmModel.h"

@implementation CSTaskRevisionRealmModel : RLMObject

+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary* defaults = [NSMutableDictionary new];
    
//    @property NSString* revisionID;
//    @property NSDate* revisionDate;
//    @property NSData* changesDictionary;
    
    NSMutableDictionary* empty = [NSMutableDictionary new];
    NSData* emptyData = [NSKeyedArchiver archivedDataWithRootObject:empty];
    
    [defaults setObject:[NSNull null] forKey:@"revisionID"];
    [defaults setObject:[NSNull null] forKey:@"revisionDate"];
    [defaults setObject:emptyData forKey:@"changesDictionary"];
    
    return defaults;
}

+ (NSString*)primaryKey {
    return @"revisionID";
}

@end
