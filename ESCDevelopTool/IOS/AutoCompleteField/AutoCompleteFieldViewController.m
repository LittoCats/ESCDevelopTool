//
//  AutoCompleteFieldViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 2/9/15.
//
//

#import "AutoCompleteFieldViewController.h"

@interface AutoCompleteFieldViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *candidateTableView;

@property (nonatomic, strong) NSMutableArray *candidateList;

@end

@implementation AutoCompleteFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 320, 44)];
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:_textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:
     UITextFieldTextDidChangeNotification object:self.textField];
    
    self.candidateTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _candidateTableView.delegate = self;
    _candidateTableView.dataSource = self;
    [self.view addSubview:_candidateTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.candidateTableView.frame = CGRectMake(10, _textField.frame.size.height+_textField.frame.origin.y+10, 320, self.view.frame.size.height - (_textField.frame.size.height+_textField.frame.origin.y+10+10));
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)noti
{
    if (_textField.text.length == 0) {
        self.candidateList = nil;
        [self.candidateTableView reloadData];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSEnumerator *classes = [NSObject autoCachedClassEnumerator];
        Class class = [classes nextObject];
        self.candidateList = [NSMutableArray new];
        while (class) {
            NSString *string = NSStringFromClass(class);
            if ([string hasPrefix:self.textField.text]) {
                if ([string isEqualToString:self.textField.text]) continue;
                [self.candidateList addObject:string];
            }
            class = [classes nextObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.candidateTableView reloadData];
        });
    });
}

//  UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _candidateList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CandidateCell"];
    }
    cell.textLabel.text = [_candidateList objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.candidateList objectAtIndex:indexPath.row];
    self.textField.text = string;
}
@end

UIKIT_EXTERN void __ESCExchangeMethodImplementation(Class class,SEL selector1, BOOL isClassMethod1,SEL selector2, BOOL isClassMethod2);

@implementation NSObject (AutoCachedClass)

static NSMapTable *AutoCachedClass;
+ (void)load
{
    AutoCachedClass = [NSMapTable weakToWeakObjectsMapTable];
    [AutoCachedClass setObject:[NSMapTable class] forKey:[NSMapTable class]];
    __ESCExchangeMethodImplementation([NSObject class], @selector(alloc), YES, @selector(AutoCachedClass_alloc), YES);
}
+ (NSEnumerator *)autoCachedClassEnumerator
{
    return [AutoCachedClass keyEnumerator];
}

+ (void)AutoCachedClass_alloc
{
    if (![AutoCachedClass objectForKey:self]) {
        [AutoCachedClass setObject:self forKey:self];
    }
    [self AutoCachedClass_alloc];
}

@end
