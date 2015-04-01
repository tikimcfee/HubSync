//
//  HSUserListViewController.m
//  HubSync
//
//  Created by Student on 4/1/15.
//  Copyright (c) 2015 AppsByDLI. All rights reserved.
//

#import "HSUserListViewController.h"
#import "HSUserListCell.h"
#import "CSSessionManager.h"
#import "AppDelegate.h"
#import "HSConstantsHeader.h"

@interface HSUserListViewController ()
@property (strong) CSSessionManager *sessionManager;
@end

@implementation HSUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserList:) name:@"PEER_CHANGED_STATE" object:nil];
    
    _userList.dataSource = self;
    _userList.delegate = self;
}

- (void)viewDidAppear {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_userList reloadData];
    });
    
    if(_sessionManager == nil) {
        AppDelegate* d = [[NSApplication sharedApplication] delegate];
        self.sessionManager = d.globalSessionManager;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUserList:(NSNotification *)notification {
    __weak HSUserListViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.userList reloadData];
    });
}

#pragma mark - Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 64.0f;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    if (self.userList.selectedRow == -1) {
        return;
    }
    
    HSUserListCell *cell = [self.userList viewAtColumn:self.userList.selectedColumn row:self.userList.selectedRow makeIfNecessary:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHSSelectedUserDetailNotification object:cell.name.stringValue];
}

#pragma mark - Data Source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [self.sessionManager.currentConnectedPeers count];
}

- (id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    HSUserListCell* cell = [tableView makeViewWithIdentifier:@"UserCell" owner:self];
    cell.name.stringValue = [[self.sessionManager.currentConnectedPeers allKeys] objectAtIndex:row];
    
    return cell;
}

@end








