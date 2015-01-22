//
//  CandidateView.h
//  EasyKeyboard
//
//  Created by 程巍巍 on 1/22/15.
//  Copyright (c) 2015 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hans;
@protocol CandidateDelegate;

@interface CandidateView : UIView

@property (nonatomic, strong) id<CandidateDelegate> delegate;

- (void)reloadData:(NSArray *)dataList;

@end

@protocol CandidateDelegate <NSObject>

@required
- (void)candidateView:(CandidateView *)view didSelectHan:(Hans *)han;

@end