//
//  PopoverViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "PopoverViewController.h"

#import "ESCPopover.h"
#import "UIView+ESC.h"

@interface PopoverViewController ()
- (IBAction)buttonAction:(UIButton *)sender;

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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

- (IBAction)buttonAction:(UIButton *)sender {
    NSLog(@"button clicked : %@",sender);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, arc4random()%480+44, arc4random()%1024+88)];
    view.backgroundColor = [UIColor colorWithPatternImage:[self.view snap]];
    
    ESCPopover *popover = [[ESCPopover alloc] init];
    popover.contentView = view;
    [popover presentFromRect:sender.frame inView:self.view options:nil];
}
@end
