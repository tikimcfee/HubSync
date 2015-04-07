//
//  HSRevisionViewerController.h
//  HubSync
//
//  Created by Ivan Lugo on 4/7/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSTaskRealmModel.h"
#import "CSTaskRevisionRealmModel.h"

#define kPropertyNameViewIdentifier @"kPropertyNameViewIdentifier"
#define kChangedFromViewIdentifier @"kChangedFromViewIdentifier"
#define kChangedToViewIdentifier @"kChangedToViewIdentifier"
#define kChangeActionViewIdentifier @"kChangeActionViewIdentifier"



@interface HSRevisionViewerController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *revisionsTableView;

@property (weak) IBOutlet NSTableColumn *propertyColumn;
@property (weak) IBOutlet NSTableColumn *changedFromColumn;
@property (weak) IBOutlet NSTableColumn *changedToColumn;
@property (weak) IBOutlet NSTableColumn *actionColumn;

@property (strong) CSTaskRealmModel* sourceTask;
@property (strong) CSTaskRevisionRealmModel* sourceRevision;

- (void) configureWithSourceTask:(CSTaskRealmModel*)sourceTask
                  sourceRevision:(CSTaskRevisionRealmModel*)sourceRevision;
@end
