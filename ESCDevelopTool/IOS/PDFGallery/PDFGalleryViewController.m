//
//  PDFGalleryViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "PDFGalleryViewController.h"
#import "ESCPDFGallery.h"
#import "ESCPDFDocument.h"

@interface PDFGalleryViewController ()
@property (weak, nonatomic) IBOutlet ESCPDFGallery *pdfGallery;

@end

@implementation PDFGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ESCPDFDocument *document = [[ESCPDFDocument alloc] init];
    [document loadPDF:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Python study" ofType:@"pdf"]]];
    [document unLockDocumentWithPassword:nil];
    self.pdfGallery.document = document;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
