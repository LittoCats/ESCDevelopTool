//
//  CandidateView.m
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import "CandidateView.h"
#import "FreeImeDB.h"
#import "Hans.h"

@interface HansButton : UIButton

@property (nonatomic, strong) Hans *han;

@end

@interface CandidateView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *cache;

@end

@implementation CandidateView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: CGRectMake(0, 0, 0, 0)]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        self.cache = [NSMutableArray new];
    }
    return self;
}

- (void)reloadData:(NSArray *)dataList
{
    // reload scrollView
    for (UIView *subview in _scrollView.subviews) {
        [subview removeFromSuperview];
        [_cache addObject:subview];
    }
    
    for (id<FreeIMETableProtocol> item in dataList) {
        HansButton *button = [_cache lastObject];[_cache removeLastObject];
        if (!button) {
            button = [HansButton buttonWithType:UIButtonTypeSystem];
            button.titleLabel.font = [UIFont systemFontOfSize:23];
            button.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
            button.layer.shadowOffset = CGSizeMake(1.5, 0);
            [button addTarget:self action:@selector(didSelectHan:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.han = [item value];
        [_scrollView addSubview:button];
    }
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _scrollView.frame = self.bounds;
}

- (void)layoutSubviews
{
    CGFloat orginX = 10;
    CGFloat centenY = self.frame.size.height/2;
    for (UIView *subview in _scrollView.subviews) {
        if (![subview isKindOfClass:HansButton.class]) continue;
        subview.center = CGPointMake(orginX+subview.frame.size.width/2, centenY);
        orginX += subview.frame.size.width+10;
    }
    _scrollView.contentSize = CGSizeMake(orginX, self.frame.size.height);
}

#pragma mark- delegate
- (void)didSelectHan:(HansButton *)sender
{
    [self.delegate candidateView:self didSelectHan:sender.han];
}
@end

@implementation HansButton

- (void)setHan:(Hans *)han
{
    _han = han;
    [self setTitle:han.value forState:UIControlStateNormal];
    [self sizeToFit];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    _han = nil;
}
@end
