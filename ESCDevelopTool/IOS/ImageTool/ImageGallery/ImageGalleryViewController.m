//
//  ImageGalleryViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/2/15.
//
//

#import "ImageGalleryViewController.h"
#import "ESCImageGallery.h"

@interface ImageGalleryViewController ()

@property (nonatomic, strong) ESCImageGallery *view;

@end

@implementation ImageGalleryViewController

- (void)loadView
{
    self.view = [[ESCImageGallery alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setImages:self.settings[@"images"]];
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
