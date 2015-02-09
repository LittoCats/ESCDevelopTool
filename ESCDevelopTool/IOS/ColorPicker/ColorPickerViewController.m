//
//  ColorPickerViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 2/9/15.
//
//

#import "ColorPickerViewController.h"
#import "ESCPopover.h"
#import "UIColor+ESC.h"
#import "UIImage+ESC.h"

#import "ESCColorPicker.h"

@interface ColorPickerViewController ()<ESCColorPickerDelegate>

@property (nonatomic, strong) ESCPopover *popover;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.popover = [[ESCPopover alloc] init];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 128, 36)];
    _textField.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HEXColorNotification:) name:UITextFieldTextDidChangeNotification object:_textField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 66, 88, 36)];
    label.text = @"[[UILabel alloc] initWithFrame:CGRectMake(20, 66, 88, 36)];";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

- (void)navigationItemSelected:(NSInteger)serializedID
{
    switch (serializedID) {
        case 100:{
            [self popview:_textField];
        }break;
        case 101:{
            ESCColorPicker *picker = [ESCColorPicker plate];
            picker.delegate = self;
            picker.frame = CGRectMake(0, 0, self.view.frame.size.width-33, self.view.frame.size.width/3);
            [self popview:picker];
        }break;
            
        default:
            break;
    }
}
- (void)popview:(UIView *)view
{
    _popover.contentView = view;
    [_popover presentFromRect:CGRectZero inView:self.view options:nil];
}

- (void)HEXColorNotification:(NSNotification *)noti
{
    UIColor *color = [UIColor colorWithScript:[@"#" stringByAppendingString:_textField.text]];
    if (!color) return;
    self.view.backgroundColor = color;
}

// ESCColorPickerDelegate
- (void)colorPicker:(ESCColorPicker *)picker didPickColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}
@end
