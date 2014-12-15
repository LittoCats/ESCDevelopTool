//
//  __ESCIndicatorView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 11/28/14.
//
//

#import "__ESCIndicatorView.h"

#import <QuartzCore/QuartzCore.h>

@interface __ESCIndicatorView ()

@property (nonatomic, strong) NSMutableArray *infos;

@property (nonatomic) NSUInteger refrenceCount;

@property (nonatomic) __ESCIndicatorViewOverlay *contentView;

@property (nonatomic, strong) NSMapTable *timeMap;

@end

#define kMessage    @"message"
#define kStyle      @"style"
#define kInterval   @"interval"
@implementation __ESCIndicatorView

- (void)setMessage:(NSString *)message style:(ESCIndicatorStyle)style interval:(NSTimeInterval)interval
{
    NSDictionary *info = @{kMessage:message ? message : @"",
                           kStyle:@(style),
                           kInterval:@(interval)};
    [self.infos addObject:info];
    
    if (interval > 0) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(respondsToTimer:) userInfo:[_infos lastObject] repeats:NO];
        [self.timeMap setObject:timer forKey:info];
    }
    self.refrenceCount += 1;
}

- (void)setOwner:(UIView *)owner
{
    self.frame = owner.bounds;
    objc_setAssociatedObject(owner, &kESCViewIndicatorKey, self, OBJC_ASSOCIATION_ASSIGN);
    [owner addOverlay:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide:(BOOL)isAll
{
    if (self.refrenceCount == 0) {
        return;
    }
    
    if (isAll) {
        self.refrenceCount -= _refrenceCount;
        return;
    }
    
    // 移除最后一个加入的 interval <＝ 0 的配制
    for (NSInteger i = self.infos.count-1; i >= 0; i --) {
        NSDictionary *info = [self.infos objectAtIndex:i];
        if ([[info objectForKey:kInterval] doubleValue] <= 0) {
            [self.infos removeObjectAtIndex:i];
            self.refrenceCount -= 1;
            break;
        }
    }
}

#pragma mark- timer
- (void)respondsToTimer:(NSTimer *)timer
{
    NSDictionary *info = timer.userInfo;
    for (int i = 0; i <self.infos.count; i ++) {
        if ([self.infos objectAtIndex:i] == info){
            [self.infos removeObjectAtIndex:i];
            break;
        }
    }
    self.refrenceCount -= 1;
}

#pragma mark- refrenceCount
- (void)setRefrenceCount:(NSUInteger)refrenceCount
{
    _refrenceCount = refrenceCount;
    if (!refrenceCount){
        objc_setAssociatedObject(self.superview, &kESCViewIndicatorKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        // invalid all timer
        NSEnumerator *enumerator = [self.timeMap objectEnumerator];
        NSTimer *timer;
        while (timer = [enumerator nextObject]) {
            [timer invalidate];
        }
    }else
        [self refresh];
}

#pragma mark- init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
        self.infos = [NSMutableArray new];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        self.contentView = [[__ESCIndicatorViewOverlay alloc] init];
        [self addSubview:_contentView];
        
        self.timeMap = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}

#pragma mark- frame
- (void)superviewFrameDidChanged
{
    self.frame = self.superview.bounds;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
#pragma mark- 
- (void)refresh
{
    NSDictionary *info = [self.infos lastObject];
    self.contentView.title = [info objectForKey:kMessage];
    ESCIndicatorStyle style = [[info objectForKey:kStyle] unsignedIntegerValue];
    CGAffineTransform transform;
    if (style == ESCIndicatorStyleDefault) {
        transform = CGAffineTransformMakeScale(1,1);
    }else if (style == ESCIndicatorStyleSmall){
        transform = CGAffineTransformMakeScale(0.6,0.6);
    }else if (style == ESCIndicatorStyleSizeToFit){
        CGFloat size = MIN(self.frame.size.height, self.frame.size.width);
        CGFloat scale = size/6/66;
        scale = MIN(1.0, scale);
        transform = CGAffineTransformMakeScale(scale,scale);
    }
    self.contentView.transform = transform;
    [self setNeedsLayout];
}
@end

@implementation __ESCIndicatorViewOverlay

- (void)setTitle:(NSString *)title
{
    self.label.text = title;
    [self setNeedsLayout];
}

#pragma mark- init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 66, 66)]) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = self.frame.size.width/10;
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_indicator];
        [_indicator startAnimating];
        
        self.label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:13];
        [self addSubview:_label];
    }
    return self;
}

#pragma mark- frame
- (void)layoutSubviews
{
    [_label sizeToFit];
    
    self.indicator.center = CGPointMake(self.frame.size.width/self.transform.a/2, self.frame.size.height/self.transform.d/2-_label.frame.size.height/2-1.5);
    self.label.center = CGPointMake(self.frame.size.width/self.transform.a/2, self.frame.size.height/self.transform.d/2+_indicator.frame.size.height/2+1.5);
}
@end
