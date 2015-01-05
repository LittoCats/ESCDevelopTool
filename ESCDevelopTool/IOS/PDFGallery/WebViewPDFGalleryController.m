//
//  WebViewPDFGalleryController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/5/15.
//
//

#import "WebViewPDFGalleryController.h"

@interface WebViewPDFGalleryController ()

@property (nonatomic, strong) UIWebView *view;

@end

@implementation WebViewPDFGalleryController

- (void)loadView
{
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view loadRequest:[NSURLRequest requestWithURL:[self.nibBundle URLForResource:@"Python study" withExtension:@"pdf"]]];
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
