//
//  AppDelegate.m
//  OSX
//
//  Created by 程巍巍 on 11/26/14.
//
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)buttonAction:(NSButton *)sender
{
    NSLog(@"button clicked : %@",sender.title);
    switch (sender.tag) {
        case 101:
            [self startMPC];
            break;
            
        default:
            break;
    }
    
}

#pragma mark- child windows
- (void)startMPC
{
    Class class = NSClassFromString(@"MPCViewController");
    NSViewController *vc = [[class alloc] init];
    
    [vc presentViewControllerAsModalWindow:vc];
}

@end
