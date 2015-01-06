//
//  GIFViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/6/15.
//
//

#import "GIFViewController.h"
#import <ImageIO/ImageIO.h>

@interface GIFViewController ()
{
    CGImageSourceRef gif; // 保存gif动画
    NSDictionary *gifProperties; // 保存gif动画属性
    size_t index; // gif动画播放开始的帧序号
    size_t count; // gif动画的总帧数
    NSTimer *timer; // 播放gif动画所使用的timer
}
@end

@implementation GIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    index = -1;
    
    // load gif image
    NSURL *gifURL = [self.nibBundle URLForResource:@"gif" withExtension:@"gif"];
    NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    
    gifProperties = [NSDictionary dictionaryWithObject:gifLoopCount forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    gif = CGImageSourceCreateWithURL((CFURLRef)gifURL, (CFDictionaryRef)gifProperties);
    
    count =CGImageSourceGetCount(gif);
    
    [self displayGIF];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayGIF
{
    index ++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    self.view.layer.contents = (__bridge id)ref;
    CFRelease(ref);
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(wself) sself = wself; if (!sself) return ;
        [sself displayGIF];
    });
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
