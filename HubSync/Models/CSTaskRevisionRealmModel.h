//
//  CSTaskRevisionRealmModel.h
//  HubSync
//
//  Created by CommSync on 4/6/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Realm/Realm.h>

@interface CSTaskRevisionRealmModel : RLMObject

@property NSString* revisionID;
@property NSDate* revisionDate;

@property NSData* changesDictionary;

@end

RLM_ARRAY_TYPE(CSTaskRevisionRealmModel)