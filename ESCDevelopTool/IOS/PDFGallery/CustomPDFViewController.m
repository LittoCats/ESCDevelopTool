//
//  CustomPDFViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/5/15.
//
//

#import "CustomPDFViewController.h"
#import "ESCPDFGallery.h"
#import "ESCPDFDocument.h"

@interface CustomPDFViewController ()
@property (nonatomic, strong) ESCPDFGallery *view;
@end

@implementation CustomPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    ESCPDFDocument *document = [ESCPDFDocument new];
    [document loadPDF:[self.nibBundle URLForResource:@"Python study" withExtension:@"pdf"]];
    [document unLockDocumentWithPassword:nil];
    self.view.document = document;
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
