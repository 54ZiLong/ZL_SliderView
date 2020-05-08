//
//  SliderCell.m
//  RuntimeTest
//
//  Created by user on 2020/5/8.
//  Copyright © 2020 zilong. All rights reserved.
//

#import "ZL_SliderCell.h"

#define ItemW (([UIScreen mainScreen].bounds.size.width - 45) / 3)
#define ItemH 183

@implementation ZL_SliderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.contentImg];
        self.contentImg.frame = CGRectMake(0, 0, ItemW, ItemH);
    }
    return self;
}

#pragma mark - Get

- (UIImageView *)contentImg {
    if (!_contentImg) {
        _contentImg = [[UIImageView alloc] init];
    }
    return _contentImg;
}

@end
