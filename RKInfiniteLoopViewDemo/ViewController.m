//
//  ViewController.m
//  RKInfiniteLoopViewDemo
//
//  Created by apple on 17/2/16.
//  Copyright © 2017年 rickyhust. All rights reserved.
//

#import "ViewController.h"
#import "RKInfiniteLoopView.h"

@interface ViewController ()<RKInfiniteLoopViewDelegate>
@property (weak, nonatomic) IBOutlet RKInfiniteLoopView *loopView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _loopView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)onLoadData:(id)sender {
    RKInfiniteLoopItem *item1 = [[RKInfiniteLoopItem alloc] init];
    item1.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/20161028173654642ba91ffe14eb.jpg"];
    
    RKInfiniteLoopItem *item2 = [[RKInfiniteLoopItem alloc] init];
    item2.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/2017011618406644c588e24e6216.jpg"];
    
    RKInfiniteLoopItem *item3 = [[RKInfiniteLoopItem alloc] init];
    item3.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/20161024142059c4da196792ab3b.jpg"];
    
    RKInfiniteLoopItem *item4 = [[RKInfiniteLoopItem alloc] init];
    item4.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/2016110915204444dfc8d0755fa4.jpg"];
    
    RKInfiniteLoopItem *item5 = [[RKInfiniteLoopItem alloc] init];
    item5.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/201612221825aff4900aac0b3a1d.png"];
    
    RKInfiniteLoopItem *item6 = [[RKInfiniteLoopItem alloc] init];
//    item6.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/201608231908f754703b5e1df5f5.jpg"];
    item6.imageName = @"IMG_3810.PNG";
    
    RKInfiniteLoopItem *item7 = [[RKInfiniteLoopItem alloc] init];
//    item7.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/201608261030e304d9dbd1e83d94.jpg"];
    item7.imageName = @"IMG_3815.PNG";
    
    RKInfiniteLoopItem *item8 = [[RKInfiniteLoopItem alloc] init];
//    item8.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/201611021608dfe4073bc5fec5ce.jpg"];
    item8.imageName = @"IMG_3816.PNG";
    
    [_loopView udpateLoopItem:@[item1,item2,item3,item4,item5,item6,item7,item8]];
}

- (IBAction)onRest:(id)sender {
//    RKInfiniteLoopItem *item1 = [[RKInfiniteLoopItem alloc] init];
//    item1.imageUrl = [NSURL URLWithString:@"http://img4.peiyinxiu.com/20161028173654642ba91ffe14eb.jpg"];
//    [_loopView udpateLoopItem:@[item1]];
    
//    [_loopView udpateLoopItem:nil];
    
    [_loopView udpateLoopItem:@[]];
}


#pragma mark - RKInfiniteLoopViewDelegate
- (void)infiniteLoopView:(RKInfiniteLoopView *)loopView didSelectIndex:(NSUInteger)index{
    NSLog(@"click to %lu",(unsigned long)index);
}

- (void)infiniteLoopView:(RKInfiniteLoopView *)loopView didLoopToIndex:(NSUInteger)index{
    NSLog(@"loop to %lu",(unsigned long)index);
}


@end
