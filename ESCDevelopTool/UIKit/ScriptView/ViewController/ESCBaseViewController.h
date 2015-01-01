//
//  ESCBaseViewController.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/19/14.
//
//

#import <UIKit/UIKit.h>

@interface ESCBaseViewController : UIViewController

/**
 *  配制，init 时自动载入，配制为JSON文件，文件名与类名相同
 */
@property (nonatomic, readonly) NSMutableDictionary *settings;

/**
 *  子类中需重在此方法，根据不同的 serializedID ，实现不同的响应。
 *  @discussion 1~99保留，不可使用。如果为 action 设置了 URI 则会发出一个 NURLRequest 请求，参数为 param 内容，可通过 NSURLProtocol 获取事件
 */
- (void)navigationItemSelected:(NSInteger)serializedID;

@end
