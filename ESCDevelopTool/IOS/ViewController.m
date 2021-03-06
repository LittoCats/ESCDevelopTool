//
//  ViewController.m
//  IOS
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import "ViewController.h"

#import "ESCArchiver.h"
#import "ESCPopover.h"
#import "UIControl+ESC.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *view;

@property (nonatomic, strong) NSDictionary *options;

@property (nonatomic, strong) NSArray *moduleList;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSString *optionsPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"json"];
        NSData *optionsData = [[NSData alloc] initWithContentsOfFile:optionsPath];
        self.options = optionsData && optionsData.length >= 2 ? [NSJSONSerialization JSONObjectWithData:optionsData options:0 error:nil] : @{};
        self.moduleList = [self.options objectForKey:@"moduleList"];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view.delegate = self;
    self.view.dataSource = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:7461"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
//        [data writeToFile:tempPath atomically:YES];
//        
//        NSString *projectPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Project"];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:projectPath error:nil];
//        [fileManager createDirectoryAtPath:projectPath withIntermediateDirectories:YES attributes:nil error:nil];
//        
//        NSError *error;
//        [ESCArchiver unArchive:tempPath to:projectPath withType:ESCArchiveTypeZip password:nil overWrite:YES error:&error];
//    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDetail:(id)sender
{
    
}

#pragma mark- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moduleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    NSDictionary *options = [self.moduleList objectAtIndex:indexPath.row];
    cell.textLabel.text = [options objectForKey:@"title"];
    cell.detailTextLabel.text = [options objectForKey:@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *options = [self.moduleList objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *options = [self.moduleList objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width-10, tableView.frame.size.height)];
    
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = options[@"description"];
    [label sizeToFit];
    
    ESCPopover *popover = [[ESCPopover alloc] init];
    popover.contentView = label;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *view in [cell subviews]) {
        if ([view isKindOfClass:UIButton.class]){
            CGRect rect = [cell convertRect:view.frame toView:tableView];
            rect.origin.y -= tableView.contentOffset.y;
            [popover presentFromRect:rect inView:tableView options:nil];
        }
    }
}
@end
