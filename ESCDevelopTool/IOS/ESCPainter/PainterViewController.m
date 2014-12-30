//
//  PainterViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "PainterViewController.h"

#import "ESCPainter.h"
#import "ESCPopover.h"
#import "PainterFigureList.h"

@interface PainterViewController ()

@property (nonatomic, strong) ESCPainter *view;

@end

@implementation PainterViewController

- (void)loadView
{
    self.view = [[ESCPainter alloc] initWithFrame:CGRectZero options:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *naviItemsTitle = @[@"FigureClass",@"Settings",@"undo",@"redo",@"clear"];
    
    [self navigationItemWithOptions:naviItemsTitle];
}

- (void)navigationItemWithOptions:(NSArray *)options
{
    NSMutableArray *items = [NSMutableArray new];
    [options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:obj forState:UIControlStateNormal];
        [button addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.tag = idx;
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    }];
    self.navigationItem.rightBarButtonItems = items;
}

- (void)naviItemAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        PainterFigureList *figureList = [[PainterFigureList alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        ESCPopover *popover = [[ESCPopover alloc] init];
        popover.contentView = figureList;
        __weak typeof(popover) wp = popover;
        __weak typeof(self) wself = self;
        figureList.figureSelected = ^(NSDictionary *figure){
            __strong typeof(wp) sp = wp;
            [sp dismiss:YES];
            __strong typeof(wself) sself = wself;
            [sself navigationItemWithOptions:@[figure[@"title"],@"Settings",@"undo",@"redo",@"clear"]];
            sself.view.figureClass = figure[@"class"];
        };
        CGRect rect = sender.frame;
        [popover presentFromRect:CGRectMake(rect.origin.x, 0, rect.size.width, 0) inView:self.view options:nil];
    }else if (sender.tag == 1){
        
    }else if (sender.tag == 2){
        [self.view undo];
    }else if (sender.tag == 3){
        [self.view redo];
    }else if (sender.tag == 4){
        [self.view clear];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
