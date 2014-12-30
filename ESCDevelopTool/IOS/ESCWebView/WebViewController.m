//
//  WebViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/30/14.
//
//

#import "WebViewController.h"

#import "ESCWebView.h"

@interface WebViewController ()

@property (nonatomic, strong) ESCWebView *view;

@end

@implementation WebViewController

- (void)loadView
{
    self.view = [[ESCWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"first" forState:UIControlStateNormal];
    button.tag = 0;
    [button addTarget:self action:@selector(navigationItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.view addJSAction:@"nRandomString" withCallback:^(ESCWebView *webView, NSString *action, NSArray *arguments, __autoreleasing id *returnValue) {
        NSLog(@"action from webview");
        NSLog(@"action from webview");
        NSLog(@"action from webview");
        NSLog(@"action from webview");
        
        NSString *randomStr = [NSString stringWithFormat:@"%X",arc4random()];
        *returnValue = [randomStr dataUsingEncoding:NSUTF8StringEncoding];
    }];
    
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"webview" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    [self.view loadHTMLString:html baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationItemAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            
            break;
            
        default:
            NSLog(@"NavigationItemAction : %@",sender);
            break;
    }
}
@end
