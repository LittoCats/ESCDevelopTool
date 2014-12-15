//
//  ESCHorizontalTableView.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/15/14.
//  Copyright (c) 12/15/14 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCHorizontalTableView : UIView

@property (nonatomic, weak)   id <UITableViewDataSource> dataSource;
@property (nonatomic, weak)   id <UITableViewDelegate>   delegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end