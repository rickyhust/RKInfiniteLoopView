//
//  RKInfiniteLoopView.m
//  RKInfiniteLoopItemDemo
//
//  Created by ricky on 15/8/22.
//  Copyright © 2015年 rickyhust. All rights reserved.
//

#import "RKInfiniteLoopView.h"
#import "UIImageVIew+WebCache.h"

#define kLoopImageViewBaseTag 332211

@interface RKInfiniteLoopView()<UIScrollViewDelegate>
{
    BOOL _autoLoop;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *loopItemArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation RKInfiniteLoopView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupView];
    }
    return self;
}

- (void)dealloc{
    [self stopLoop];
}

- (void)setupView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UITapGestureRecognizer *regnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapScrollView:)];
    regnizer.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:regnizer];
    
    _autoLoop = YES;
    _imageViewContentMode = UIViewContentModeScaleAspectFill;
    _loopDuration = 5;
    _currentIndex = -1;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    if(!CGRectEqualToRect(_scrollView.frame, self.bounds))
        _scrollView.frame = self.bounds;
    
    _scrollView.contentSize = CGSizeMake(_loopItemArray.count * self.bounds.size.width, 0);
    
    for (int i = 0; i<_loopItemArray.count; i++) {
        UIImageView *imageView = [_scrollView viewWithTag:kLoopImageViewBaseTag + i];
        imageView.frame = CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
}

- (void)udpateLoopItem:(NSArray *)loopItemArray{
    //Stop Loop
    [self stopLoop];
    
    //Deal data
    if(loopItemArray.count > 1)
    {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        //n-1 0 1 2 3 4 5 ... n-1 1
        [temp addObject:loopItemArray.lastObject];
        [temp addObjectsFromArray:loopItemArray];
        [temp addObject:loopItemArray.firstObject];
        _loopItemArray = temp;
    }
    else{
        _loopItemArray = loopItemArray;
    }
    
    //Update Content
    [self updateContent];
    
    [self setNeedsLayout];
}

- (void)updateContent{
    _scrollView.delegate = nil;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImageView class]] && obj.tag >= kLoopImageViewBaseTag) //防止把滚动条给remove了！
            [obj removeFromSuperview];
    }];
    
    for (int i = 0; i<_loopItemArray.count; i++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.tag = kLoopImageViewBaseTag + i;
        imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        imageView.contentMode = _imageViewContentMode;
        imageView.clipsToBounds = YES;
        [_scrollView addSubview:imageView];
        
        RKInfiniteLoopItem *item = [_loopItemArray objectAtIndex:i];
        if(item.imageName.length > 0)
            imageView.image = [UIImage imageNamed:item.imageName];
        else if(item.imageUrl && [item.imageUrl.absoluteString hasPrefix:@"file://"])
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:item.imageUrl]];
        else if(item.imageUrl){
            [imageView sd_setImageWithURL:item.imageUrl placeholderImage:item.placeholderImageName.length > 0 ?[UIImage imageNamed:item.placeholderImageName]:nil];
        }
    }
    
    if(_loopItemArray.count > 1)
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
        _currentIndex = 1;
    }
    else
    {
        [_scrollView setContentOffset:CGPointZero animated:NO];
        _currentIndex = 0;
    }
    
    if(_loopItemArray.count > 0){
        if ([self.delegate respondsToSelector:@selector(infiniteLoopView:didLoopToIndex:)]) {
            [self.delegate infiniteLoopView:self didLoopToIndex:0];
        }
    }
    
    _scrollView.delegate = self;
    
    //check auto loop
    if(_autoLoop)
        [self startLoop];
}

- (BOOL)isAutoLoop{
    return _autoLoop;
}

- (void)setAutoLoop:(BOOL)autoLoop{
    _autoLoop = autoLoop;
    if(_autoLoop)
        [self startLoop];
}

- (void)startLoop{
    if(_loopItemArray.count > 1)
    {
        [self performSelector:@selector(runItemLoop) withObject:nil afterDelay:_loopDuration];
    }
}

- (void)stopLoop{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runItemLoop) object:nil];
}

- (void)runItemLoop{
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    targetX = (int)(targetX/_scrollView.frame.size.width) * _scrollView.frame.size.width;
    
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    
    [self performSelector:@selector(runItemLoop) withObject:nil afterDelay:_loopDuration];
}

#pragma mark - Tap Action
- (void)onTapScrollView:(UIGestureRecognizer *)gestureRecognizer{
    if(_loopItemArray.count == 0)
        return;
    
    int page = (int)([gestureRecognizer locationInView:_scrollView].x / _scrollView.frame.size.width);
    if (page > -1
        && ((_loopItemArray.count <= 1 && page < _loopItemArray.count)
            || (_loopItemArray.count > 1 && page < _loopItemArray.count - 1))) {
        if ([self.delegate respondsToSelector:@selector(infiniteLoopView:didSelectIndex:)]) {
            [self.delegate infiniteLoopView:self didSelectIndex:page>0?page-1:0];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float targetX = scrollView.contentOffset.x;
    if(_loopItemArray.count > 1){
        if (targetX >= _scrollView.frame.size.width * (_loopItemArray.count -1)) {
            targetX = _scrollView.frame.size.width;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = _scrollView.frame.size.width *(_loopItemArray.count - 2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    
    NSUInteger page = (_scrollView.contentOffset.x+_scrollView.frame.size.width/2.0) / _scrollView.frame.size.width;
    
    if(_loopItemArray.count > 1 && (page == _loopItemArray.count-1 || page == 0))//为了实现循环滚动，当滚动到最后一页时候会直接跳到第二页，加上这个判断防止重复调用delegate
        return;
    
    if(page != _currentIndex && _loopItemArray.count > 0){
        if ([self.delegate respondsToSelector:@selector(infiniteLoopView:didLoopToIndex:)]) {
            [self.delegate infiniteLoopView:self didLoopToIndex:page>0?page-1:0];
        }
        _currentIndex = page;
    }
}
@end
