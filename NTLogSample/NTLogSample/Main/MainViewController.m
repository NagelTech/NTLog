//
//  MainViewController.m
//  NTLogSample
//
//  Created by Ethan Nagel on 1/5/14.
//  Copyright (c) 2014 Nagel Technologies, Inc. All rights reserved.
//

#import "MainViewController.h"

#import "LogEntryCell.h"


@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, NTLogListener>
{
    NSMutableArray *_items;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation MainViewController


#pragma mark - UIViewController overrides


-(id)init
{
    return [super initWithNibName:NSStringFromClass([self class]) bundle:nil];  // why isn't this built-in to UIViewController?
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"NTLog Sample";
    
    [self.tableView registerNib:[LogEntryCell nib] forCellReuseIdentifier:[LogEntryCell reuseIdentifier]];
    
    _items = [NSMutableArray array];
    
    NTLogAddListener(self);
    
    NTLog(@" --- LogListener added -- ");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - IBActions


- (IBAction)doLogDebug:(id)sender
{
    NTLogDebug(@"Sample Debug Log Item");
}


- (IBAction)doLogInfo:(id)sender
{
    NTLog(@"Sample Info Log Item");
}


- (IBAction)doLogWarn:(id)sender
{
    NTLogWarn(@"Sample Warn Log Item");
}


- (IBAction)doLogError:(id)sender
{
    NTLogError(@"Sample Error Log Item");
}


- (IBAction)doLogFatal:(id)sender
{
    NTLogFatal(@"Sample Fatal Log Item");
}


#pragma mark - NTLogListener


-(void)writeLine:(NSString *)line
{
    [_items addObject:line];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_items.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma UITableViewDataSource/Delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = _items[indexPath.row];
    
    return [LogEntryCell cellHeightForLogEntry:item width:self.tableView.frame.size.height];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = _items[indexPath.row];
    
    LogEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:[LogEntryCell reuseIdentifier] forIndexPath:indexPath ];
    
    [cell configureCellWithLogEntry:item];
    
    return cell;
}


@end
