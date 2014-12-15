//
//  ViewController.m
//  IOS
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import "ViewController.h"

#import "UIView+ESC.h"
#import "ESCPDFDocument.h"

#import "UIColor+ESC.h"
#import "UIImage+ESC.h"

#import "UIControl+ESC.h"

#import "ESCPopover.h"

#import "ESCCoreData.h"
#import "Entity.h"
#import "ESCJSContext.h"

#import "ESCImageGallery.h"

#import "ESCCodeSymbol.h"

#import <math.h>

@interface ViewController ()

@property (nonatomic, strong) ESCPDFDocument *document;

@property (nonatomic, strong) UIPopoverController *pc;

@property (nonatomic, strong) UIView *locateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeToast)]];
    
    [UIView enableGradientBackgroundColor:YES];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(show:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hide:)]];
    

//    ESCPDFDocument *pdfDocument  = [[ESCPDFDocument alloc] init];
//    [pdfDocument loadPDF:[[NSBundle mainBundle] URLForResource:@"adobe_supplement_iso32000" withExtension:@"pdf"]];
//    [pdfDocument unLockDocumentWithPassword:nil];
//    [pdfDocument catalogs];
    
    ESCImageGallery *gallery = [[ESCImageGallery alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    gallery.backgroundColor = [UIColor lightGrayColor];
    [gallery setImages:@[[UIImage imageNamed:@"128sheying1.jpg"],[NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/lyj/xc.jpg"],[UIImage imageNamed:@"9556390576gjdl.jpg"],[UIImage imageNamed:@"mcmg1210.jpg"],[UIImage imageNamed:@"128sheying1.jpg"],[UIImage imageNamed:@"9556390576gjdl.jpg"],[UIImage imageNamed:@"mcmg1210.jpg"],[UIImage imageNamed:@"128sheying1.jpg"],[UIImage imageNamed:@"9556390576gjdl.jpg"],[UIImage imageNamed:@"mcmg1210.jpg"]]];
//    [gallery setImages:@[[NSURL URLWithString:@"http://img.bdstatic.com/img/image/shouye/lyj/xc.jpg"]]];
    [self.view addSubview:gallery];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)show:(id)item
{
    

    return;
}

- (void)hide:(id)item
{
    [self.view hideIndicator:NO];
}

- (void)makeToast
{
    
}

- (id)block:(id)arg,...
{
    return nil;
}

- (void)timerAction:(NSTimer *)timer
{
    NSLog(@"%@",[NSDate date]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
