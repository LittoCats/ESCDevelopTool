//
//  __ESCToastView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/27/14.
//
//

#import "__ESCToastView.h"

#define kESCToastMargin 44.0

@implementation __ESCToastView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.layer.cornerRadius = 3.0;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self superviewFrameDidChanged];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(dismiss:) userInfo:nil repeats:NO];
}

- (void)dismiss:(NSTimer *)timer
{
    UIView *superview = [self superview];
    if (superview) {
        objc_setAssociatedObject(superview, &kESCViewToastKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [self removeFromSuperview];
    }
}

- (void)setOwner:(UIView *)owner
{
    objc_setAssociatedObject(owner, &kESCViewToastKey, self, OBJC_ASSOCIATION_ASSIGN);
    [owner addOverlay:self];
}


- (void)superviewFrameDidChanged
{
    UIView *superview = self.superview;
    if (!superview) return;
    [self sizeToFit];
    [self setFrame:CGRectMake(0, 0, self.frame.size.width + 11, self.frame.size.height+11)];
    
    CGFloat y = 0xFF00 == (_position & 0xFF00) ? superview.frame.size.height / 2 :
                0x0F00 == (_position & 0x0F00) ? superview.frame.size.height - self.frame.size.height/2 - kESCToastMargin:
                self.frame.size.height/2 + kESCToastMargin;
    CGFloat x = 0x00FF == (_position & 0x00FF) ? superview.frame.size.width / 2 :
                0x000F == (_position & 0x000F) ? superview.frame.size.width - self.frame.size.width/2 - kESCToastMargin:
                self.frame.size.width/2 + kESCToastMargin;
    
    self.center = CGPointMake(x, y);
}

@end
