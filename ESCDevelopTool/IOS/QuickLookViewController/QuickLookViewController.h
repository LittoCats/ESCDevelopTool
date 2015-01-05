//
//  QuickLookViewController.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/4/15.
//
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface QuickLookViewController : QLPreviewController<QLPreviewControllerDataSource,QLPreviewControllerDelegate,QLPreviewItem>

@property(readonly) NSURL * previewItemURL;
@end
