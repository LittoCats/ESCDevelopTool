//
//  QuickLookViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/4/15.
//
//

#import "QuickLookViewController.h"

@implementation QuickLookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"_UISizeTrackingView")]) {
            subview.backgroundColor = [UIColor whiteColor];
        }
    }
}
- (NSURL *)previewItemURL
{
    return [[NSBundle mainBundle] URLForResource:@"Python study" withExtension:@"pdf"];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self;
}
@end
