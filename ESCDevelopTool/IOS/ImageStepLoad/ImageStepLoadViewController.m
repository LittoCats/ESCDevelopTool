//
//  ImageStepLoadViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 2/8/15.
//
//

#import "ImageStepLoadViewController.h"
#import <ImageIO/ImageIO.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ImageStepLoadViewController ()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *imageData;

@end

@implementation ImageStepLoadViewController

- (void)loadView
{
    self.view = [[UIImageView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"http://preview.quanjing.com/mint_rm001/mintrm-0994.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.imageData = [[NSMutableData alloc] init];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    NSLog(@"%@",[response allHeaderFields]);
}
static int delay = 1;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"get data : %lu",(unsigned long)data.length);
    [self.imageData appendData:data];
    CFDataRef cfdata = (__bridge CFDataRef)(self.imageData);
    CGImageSourceRef image = CGImageSourceCreateWithData(cfdata, nil);
    if (CGImageSourceGetCount(image)) {
        CGImageRef imageref = CGImageSourceCreateImageAtIndex(image, 0, nil);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*delay++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.layer.contents = (__bridge id)(imageref);
        });
    }
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
