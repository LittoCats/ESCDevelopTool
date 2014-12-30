//
//  PainterFigureList.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import <UIKit/UIKit.h>

@interface PainterFigureList : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) void (^figureSelected)(NSDictionary *figure);

@end
