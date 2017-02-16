//
//  RKInfiniteLoopItem.h
//  RKInfiniteLoopItemDemo
//
//  Created by ricky on 15/8/22.
//  Copyright © 2015年 rickyhust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RKInfiniteLoopItem : NSObject
@property (nonatomic, strong) NSURL *imageUrl;                  //Network Image Url or Image Filr Url
@property (nonatomic, strong) NSString *placeholderImageName;   //Network Image Url Placehoder Image
@property (nonatomic, strong) NSString *imageName;              //Image Name in Image Asset
@end
