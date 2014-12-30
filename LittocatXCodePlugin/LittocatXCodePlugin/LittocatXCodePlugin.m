//
//  LittocatXcodePlugin.m
//  LittocatXcodePlugin
//
//  Created by 程巍巍 on 12/26/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "LittocatXcodePlugin.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Carbon/Carbon.h>

#import "ESCKeyCodeHelper.h"

static LittocatXcodePlugin *sharedPlugin;

static void XPLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
static void XPLog(NSString *format, ...){
    va_list vl;
    va_start(vl, format);
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:vl];
    va_end(vl);
    
    static NSFileHandle *fileHandle = nil;
    static dispatch_queue_t xplogQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSString *logPath = [NSHomeDirectory() stringByAppendingPathComponent:@"LittocatXcodePlugin.log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:logPath isDirectory:nil]) {
            [fileManager createFileAtPath:logPath contents:[@"// LittocatXcodePlugin by cww\n// log\n\n" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
        [fileHandle seekToEndOfFile];
        
        xplogQueue = dispatch_queue_create("littocats_plugin_xplogQueue", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(xplogQueue, ^{
        [fileHandle writeData:[[NSString stringWithFormat:@"%@ >> %@\n",[NSDate date],logString] dataUsingEncoding:NSUTF8StringEncoding]];
    });
    
}

@interface LittocatXcodePlugin()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, strong) id keyEventMonitor;

@property (nonatomic, strong) NSDictionary *settings;

@property (nonatomic, strong) NSDictionary *shortcutKeyList;
@end

@implementation LittocatXcodePlugin

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
            XPLog(@"%@",logStr);
        };
        
        // load settings
        NSError *error;
        NSData *settingData = [NSData dataWithContentsOfFile:[self.bundle pathForResource:@"" ofType:@"json"]];
        self.settings = [NSJSONSerialization JSONObjectWithData:settingData options:0 error:&error];
        self.shortcutKeyList = [self analyzeShortcutKey];
        
        // Create menu items, initialize UI, etc.

        // Sample Menu Item:
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:nil object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        // keyEventMonitor
        self.keyEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyUpMask handler:^NSEvent *(NSEvent * event) {
            NSInteger keyCode = event.keyCode;
            NSEventModifierFlags keyMask = event.modifierFlags & NSDeviceIndependentModifierFlagsMask;
            
            NSString *command = [self.shortcutKeyList objectForKey:@(keyCode | keyMask)];
            XPLog(@"Littocats keyEventMonitor command : %@  keyCode : %@    keyMask : %@",command,@(keyCode),@(keyMask));
            return event;
        }];
    }
    
    return self;
}

- (void)notification:(NSNotification *)noti
{
    XPLog(@"Notification : %@ \nobject: %@\nuserInfo : %@",noti.name,noti.object,noti.userInfo);
}
// Sample Action, for menu item:
- (void)doMenuAction
{
    [_jsContext evaluateScript:@"__log_('_jsContext')"];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
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
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSEvent removeMonitor:self.keyEventMonitor];
    self.keyEventMonitor = nil;
}

#pragma mark- analyze shortcut key
- (NSDictionary *)analyzeShortcutKey
{
    NSMutableDictionary *actionMap = [NSMutableDictionary new];
    for (NSDictionary *shortcutInfo in self.settings[@"shortcutKey"]) {
        NSArray *keys = [shortcutInfo[@"key"] componentsSeparatedByString:@"+"];
        NSInteger keyCode = 0;
        for (NSString *key in keys) {
            NSInteger code = [ESCKeyCodeHelper keyCodeWithScript:key];
            keyCode |= code;
            
        }
        if (!keyCode) continue;
        
        NSString *action = shortcutInfo[@"action"];
        if (action) [actionMap setObject:action forKey:@(keyCode)];
    }
    XPLog(@"shortcut : %@",actionMap);
    return actionMap;
}
@end
