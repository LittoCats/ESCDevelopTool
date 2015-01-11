//
//  MPCViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/9/15.
//
//

#import "MPCViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCViewController ()<MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
@property (weak) IBOutlet NSTextField *displayNameTextField;
@property (weak) IBOutlet NSTextField *serviceTypeTextField;

@property (weak) IBOutlet NSTableView *nearbiesTableView;

@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *sendButton;

@property (unsafe_unretained) IBOutlet NSTextView *historyTextView;
@property (unsafe_unretained) IBOutlet NSTextView *inputTextView;
@property (weak) IBOutlet NSTextField *currentPeerLabel;

- (IBAction)startOrStop:(NSButton *)sender;

- (IBAction)sendMessage:(NSButton *)sender;

// Multipeer connect
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCSession *session;

@property (nonatomic, strong) MCPeerID *currentPeerID;

@end

@implementation MPCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)startOrStop:(NSButton *)sender
{
    if (sender.tag != 's') {
        self.advertiser = nil;
        self.browser = nil;
        
        NSString *displayName = self.displayNameTextField.stringValue;
        NSString *serviceType = self.serviceTypeTextField.stringValue;
        
        if (!displayName || displayName.length == 0){
            displayName = [NSString stringWithFormat:@"%.7X",arc4random()];
            [self.displayNameTextField setStringValue:displayName];
        }
        if (!serviceType || serviceType.length == 0) {
            NSAlert *alert = [NSAlert alertWithError:[NSError errorWithDomain:@"Servicetype can't be nil ." code:0 userInfo:nil]];
            [alert runModal];
            return;
        }
        
        BOOL needCreateAdvertise = NO;
        if (![_peerID.displayName isEqualToString:displayName]) {
            self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
            needCreateAdvertise = YES;
        }
        if (![serviceType isEqualToString:_advertiser.serviceType] || needCreateAdvertise){
            self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:nil serviceType:serviceType];
            self.session = [[MCSession alloc] initWithPeer:_peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
            self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:serviceType];
            self.advertiser.delegate = self;
            self.browser.delegate = self;
            self.session.delegate = self;
        }
        
        [self.advertiser startAdvertisingPeer];
        [self.browser startBrowsingForPeers];
        
        self.displayNameTextField.editable = NO;
        self.serviceTypeTextField.editable = NO;
        
        sender.title = @"Stop";
        sender.tag = 's';
    }else{
        [self.browser stopBrowsingForPeers];
        [self.advertiser stopAdvertisingPeer];
        self.displayNameTextField.editable = YES;
        self.serviceTypeTextField.editable = YES;
        
        sender.title = @"Start";
        sender.tag = 0;
    }
}

- (IBAction)sendMessage:(NSButton *)sender
{
    NSLog(@"send message");
    NSError *error;
    NSString *message = self.inputTextView.string;
    [self.session sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:@[self.currentPeerID] withMode:MCSessionSendDataUnreliable error:&error];
    NSString *string = [self.historyTextView.string stringByAppendingString:[NSString stringWithFormat:@"\n%@",message]];
    self.historyTextView.string = string;
}

#pragma mark- MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"did receive invitation from peer : %@",peerID);
    invitationHandler(YES, self.session);
    self.currentPeerID = peerID;
    self.currentPeerLabel.stringValue = peerID.displayName;
}
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"did not start advertising peer : %@",error);
}

#pragma mark- MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"foundPeer : %@",peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer : %@",peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"did not start browsing for peers : %@",error);
}

#pragma mark- MCSessionDelegate
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"%@ %@",peerID.displayName, state == MCSessionStateConnected ? @"connected ." : state == MCSessionStateConnecting ? @"connecting ..." : @"disconnect");
}
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Recive data from < %@ > : %@",peerID.displayName, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

@end
