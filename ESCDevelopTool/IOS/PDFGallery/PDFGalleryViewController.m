//
//  PDFGalleryViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/5/15.
//
//

#import "PDFGalleryViewController.h"

@interface PDFGalleryViewController ()
- (IBAction)galleryPDF:(UIButton *)sender;

@end

@implementation PDFGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)galleryPDF:(UIButton *)sender {
    if ([self.settings[@"galleryAction"] count] < sender.tag) return;
    NSDictionary *options = [self.settings[@"galleryAction"] objectAtIndex:sender.tag-1];
    NSURL *url = [NSURL URLWithString:[options objectForKey:@"action"]];
    
    if ([[url.scheme lowercaseString] isEqualToString:@"escm"]) {
        Class vcClass = NSClassFromString(url.host);
        if (!vcClass) {
            NSLog(@"vcClass is not exist : %@",url);
            return;
        }
        UIViewController *vc = [[vcClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
