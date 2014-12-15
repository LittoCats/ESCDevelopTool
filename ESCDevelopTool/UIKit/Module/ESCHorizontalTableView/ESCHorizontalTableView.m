//
//  ESCHorizontalTableView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/15/14.
//  Copyright (c) 12/15/14 Littocats. All rights reserved.
//

#import "ESCHorizontalTableView+Private.h"

@implementation ESCHorizontalTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] initWithFrame:frame style:style];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark- frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_tableView setFrame:self.bounds];
}

#pragma mark- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)] ? [self.dataSource tableView:self.tableView numberOfRowsInSection:section] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    return nil;
}

#pragma mark-
@end
