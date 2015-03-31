//
//  HSTaskListViewController.m
//  HubSync
//
//  Created by CommSync on 3/30/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSTaskListViewController.h"
#import "HSTaskListCell.h"
#import "AppDelegate.h"
#import "CSTaskRealmModel.h"


@interface HSTaskListViewController ()
@property (strong, nonatomic) RLMNotificationToken* updateUIToken;
@end

@implementation HSTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    __weak typeof(self) weakSelf = self;
    void (^realmNotificationBlock)(NSString*, RLMRealm*) = ^void(NSString* note, RLMRealm* rlm) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didReceiveNewTask:nil];
        });
    };
    
    _updateUIToken = [[RLMRealm defaultRealm] addNotificationBlock:realmNotificationBlock];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNewTask:)
                                                 name:@"kCSDidFinishReceivingResourceWithName"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveNewTask:(NSNotification*)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.taskList reloadData];
    });
    
}

#pragma mark - Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 64.0f;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    if (self.taskList.selectedRow == -1) {
        return;
    }
    
    HSTaskListCell *cell = [self.taskList viewAtColumn:self.taskList.selectedColumn row:self.taskList.selectedRow makeIfNecessary:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSelectedRowNotification" object:cell];
}

#pragma mark - Data Source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [[CSTaskRealmModel allObjects] count];
}

- (id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    HSTaskListCell* cell = [tableView makeViewWithIdentifier:@"TaskCell" owner:self];
    CSTaskRealmModel *task = [[CSTaskRealmModel allObjects] objectAtIndex:row];
    [cell configureWithSourceTask:task];
    
    return cell;
}

@end
