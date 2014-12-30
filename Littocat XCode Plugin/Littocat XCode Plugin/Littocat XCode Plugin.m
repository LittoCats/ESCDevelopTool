//
//  Littocat XCode Plugin.m
//  Littocat XCode Plugin
//
//  Created by 程巍巍 on 12/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "Littocat XCode Plugin.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Carbon/Carbon.h>
#import "ESCKeyCodeHelper.h"

static LittocatXCodePlugin *sharedPlugin;

static void XPLog(NSString *logStr){
    NSLog(@"%@",logStr);
}

@interface LittocatXCodePlugin()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, strong) id keyEventMonitor;

@property (nonatomic, strong) NSDictionary *settings;

@property (nonatomic, strong) NSDictionary *shortcutKeyList;
@end

@implementation LittocatXCodePlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        self.jsContext = [[JSContext alloc] init];
        _jsContext[@"__log_"] = ^{
            NSArray *args = [JSContext currentArguments];
            NSMutableString *logStr = [NSMutableString stringWithFormat:@"JSContext : \n"];
            for (id arg in args) {
                [logStr appendFormat:@"%@\n",arg];
            }
            XPLog(logStr);
        };
        
        // 载入配制文件
        NSError *error;
        NSData *settingData = [NSData dataWithContentsOfFile:[self.bundle pathForResource:@"" ofType:@"json"]];
        self.settings = [NSJSONSerialization JSONObjectWithData:settingData options:0 error:&error];
        self.shortcutKeyList = [self analyzeShortcutKey];

        // Sample Menu Item:
        
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        // keyEventMonitor
        self.keyEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyUpMask handler:^NSEvent *(NSEvent * event) {
            NSInteger keyCode = event.keyCode;
            NSLog(@"event.keyCode : %li",(long)keyCode);
            return event;
        }];
    }
    return self;
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    [_jsContext evaluateScript:@"__log_('log')"];
    

}

- (void) applicationDidFinishLaunching: (NSNotification*) noti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];
}

- (void) textStorageDidChange:(NSNotification *)noti
{
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)noti.object;
        NSLog(@"textStorageDidChange : %@",noti.userInfo);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- analyze shortcut key
- (NSDictionary *)analyzeShortcutKey
{
    for (NSDictionary *shortcutInfo in self.settings[@"shortcutKey"]) {
        NSArray *keys = [shortcutInfo[@"key"] componentsSeparatedByString:@"+"];
        
    }
    return nil;
}
@end
