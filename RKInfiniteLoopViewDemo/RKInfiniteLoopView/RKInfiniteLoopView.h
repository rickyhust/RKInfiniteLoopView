//
//  RKInfiniteLoopView.h
//  RKInfiniteLoopItemDemo
//
//  Created by ricky on 15/8/22.
//  Copyright © 2015年 rickyhust. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKInfiniteLoopItem.h"

@class RKInfiniteLoopView;
@protocol RKInfiniteLoopViewDelegate <NSObject>
@optional
- (void)infiniteLoopView:(RKInfiniteLoopView *)loopView didSelectIndex:(NSUInteger)index;
- (void)infiniteLoopView:(RKInfiniteLoopView *)loopView didLoopToIndex:(NSUInteger)index;
@end

@interface RKInfiniteLoopView : UIView
//Auto loop, default is YES
@property (nonatomic, assign, getter=isAutoLoop) BOOL autoLoop;
//Loop duration, defatul is 5
@property (nonatomic, assign) NSTimeInterval loopDuration;
//ImageView Content Mode， default is UIViewContentModeScaleAspectFill
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;

@property (nonatomic, weak) id<RKInfiniteLoopViewDelegate> delegate;

//loopItemArray with objects of RKInfiniteLoopItem
- (void)udpateLoopItem:(NSArray *)loopItemArray;
@end
