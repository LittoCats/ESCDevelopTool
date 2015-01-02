//
//  ESCBaseViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/19/14.
//
//

#import "ESCBaseViewController.h"
#import "ESCInternationalManager+UIKit.h"
#import "UIColor+ESC.h"

@interface ESCBaseViewController ()

@property (nonatomic, strong) NSMutableDictionary *settings;

@end

@implementation ESCBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSString *JSONPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"json"];
        NSError *error;
        NSData *JSONData = [NSData dataWithContentsOfFile:JSONPath];
        self.settings = JSONData ? [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error] : [NSMutableDictionary new];
#ifdef DEBUG
        error ? NSLog(@"ESCBaseViewController load settings error : %@",error) : nil;
#endif
    }
    return self;
}

- (void)loadView
{
    Class viewClass = NSClassFromString(_settings[@"view"][@"Class"]);
    if (viewClass) self.view = [[viewClass alloc] initWithFrame:CGRectZero];
    else {
        UIView *view = [[self.nibBundle ? self.nibBundle : [NSBundle mainBundle] loadNibNamed:self.nibName ? self.nibName : NSStringFromClass(self.class) owner:self options:nil] firstObject];
        self.view = view ? view : [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 配制 navigationItem
    [self updateNavigationItems];
}

- (void)navigationItemSelected:(NSInteger)serializedID
{
#ifdef DEBUG
    NSLog(@"ESCBaseViewController select custom navigationItem with serializedID %ld",serializedID);
#endif
}


#pragma mark- 
- (void)updateNavigationItems
{
    NSDictionary *settings = [self.settings objectForKey:@"navItem"];
    // title
    id title = settings[@"title"];
    UILabel *titleLabel = title[@"NavigationItem__titleLabel__"];
    if (!titleLabel) {
        id internationalTitle;
        if ([title isKindOfClass:NSDictionary.class]) {
            title = title[@"title"];
            internationalTitle = title[@"internationalTitle"];
        }
        if ([title isKindOfClass:NSString.class] && [title length]) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            
            NSString *fontName = settings[@"title"][@"font"];
            CGFloat fontSize = [settings[@"title"][@"fontSize"] floatValue];
            fontSize = fontSize ? fontSize : 17;
            titleLabel.font = fontName && fontName.length ? [UIFont fontWithName:fontName size:fontSize] : [UIFont systemFontOfSize:fontSize];
            
            NSString *color = settings[@"title"][@"color"];
            if (color && color.length) titleLabel.textColor = [UIColor colorWithScript:color];
            
            [titleLabel setText:title withInternational:internationalTitle];
            
            [settings[@"title"] setObject:titleLabel forKey:@"NavigationItem__titleLabel__"];
        }
    }
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // back
    NSMutableDictionary *backItemInfo = settings[@"back"];
    if (backItemInfo && [backItemInfo count]) {
        UIButton *button = backItemInfo[@"NavigationItem__back_button__"];
        if (!button) button = [self __navigationButtonWithInfo:backItemInfo];
        if (button) {
            button.tag = 1;
            [button sizeToFit];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }
    
    // left
    NSMutableArray *leftItems = [NSMutableArray new];
    for (NSMutableDictionary *itemInfo in settings[@"left"]) {
        UIButton *button = [itemInfo objectForKey:[NSString stringWithFormat:@"NavigationItem__button__%p",itemInfo]];
        if (!button) button = [self __navigationButtonWithInfo:itemInfo];
        if (button) [itemInfo setObject:button forKey:[NSString stringWithFormat:@"NavigationItem__button__%p",itemInfo]];
        [button sizeToFit];
        [leftItems addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    }
    if (leftItems.count) [self.navigationItem setLeftBarButtonItems:leftItems animated:YES];
    
    // right
    NSMutableArray *rightItems = [NSMutableArray new];
    for (NSMutableDictionary *itemInfo in settings[@"right"]) {
        UIButton *button = [itemInfo objectForKey:[NSString stringWithFormat:@"NavigationItem__button__%p",itemInfo]];
        if (!button) button = [self __navigationButtonWithInfo:itemInfo];
        if (button) [itemInfo setObject:button forKey:[NSString stringWithFormat:@"NavigationItem__button__%p",itemInfo]];
            
        [button sizeToFit];
        [rightItems addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    }
    if (rightItems.count) [self.navigationItem setRightBarButtonItems:rightItems animated:YES];
}

- (UIButton *)__navigationButtonWithInfo:(NSDictionary *)info
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    // title
    NSString *title = info[@"title"];
    NSString *internationalTitle = info[@"internationalTitle"];
    [button setTitle:title withInternational:internationalTitle state:UIControlStateNormal];
    
    // highlighted title
    NSString *highlightedTitle = info[@"highlightedTitle"];
    NSString *internationalHighlightedTitle = info[@"internationalHighlightedTitle"];
    [button setTitle:highlightedTitle withInternational:internationalHighlightedTitle state:UIControlStateHighlighted];
    
    // font
    NSString *fontName = info[@"font"];
    CGFloat fontSize = [info[@"fontSize"] floatValue];
    fontSize = fontSize ? fontSize : 15;
    button.titleLabel.font = fontName && fontName.length ? [UIFont fontWithName:fontName size:fontSize] : [UIFont systemFontOfSize:fontSize];
    
    // titleColor
    NSString *titleColor = info[@"titleColor"];
    NSString *highlightedTitleColor = info[@"highlightedTitleColor"];
    if (titleColor && [titleColor length]) [button setTintColor:[UIColor colorWithScript:titleColor]];
    if (highlightedTitleColor && [highlightedTitleColor length]) [button setTintColor:[UIColor colorWithScript:highlightedTitleColor]];
    
    // image
    NSString *imageName = info[@"imageName"];
    NSString *highlightedImageName = info[@"highlightedImageName"];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    
    // tintcolor
    NSString *tintColor = info[@"tintColor"];
    if (tintColor && [tintColor length]) [button setTintColor:[UIColor colorWithScript:tintColor]];
    
    // tag
    button.tag = [info[@"serializedID"] integerValue];
    [button addTarget:self action:@selector(__navigationItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)__navigationItemSelected:(UIButton *)item
{
    switch (item.tag) {
        case 1: [self.navigationController popViewControllerAnimated:YES];break;
            
        default:[self navigationItemSelected:item.tag];
    }
}
@end
