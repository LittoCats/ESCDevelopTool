//
//  PainterFigureList.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "PainterFigureList.h"

@interface PainterFigureList ()

@property (nonatomic, strong) NSArray *figureList;

@end

@implementation PainterFigureList

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        
        self.figureList = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"json"]] options:0 error:nil];
        
        self.frame = CGRectMake(0, 0, 128, 32*self.figureList.count);
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.figureList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = self.figureList[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.figureSelected) self.figureSelected(self.figureList[indexPath.row]);
}
@end
