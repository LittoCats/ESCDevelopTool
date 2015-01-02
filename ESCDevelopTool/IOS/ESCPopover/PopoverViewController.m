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
#import "UIImage+ESC.h"
#import "UIColor+ESC.h"

@interface PopoverViewController ()
- (IBAction)buttonAction:(UIButton *)sender;

@property (nonatomic, strong) ESCPopover *popover;
@end

@implementation PopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationItemSelected:(NSInteger)serializedID
{
    [self.popover dismiss:YES];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, arc4random()%480+44, arc4random()%1024+88)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithSize:view.frame.size colors:@[[UIColor randomColor], [UIColor randomColor], [UIColor randomColor]] gradientDirection:M_PI_2-0.3]];
    
    self.popover = self.popover ? self.popover : [[ESCPopover alloc] init];
    _popover.contentView = view;
    [_popover presentFromRect:sender.frame inView:self.view options:nil];
}
@end
