//
//  SliderView.m
//  RuntimeTest
//
//  Created by user on 2020/5/7.
//  Copyright © 2020 zilong. All rights reserved.
//

#import "ZL_SliderView.h"
#import "ZL_SliderCell.h"

#define ZL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define ItemW ((ZL_SCREEN_WIDTH - 45) / 3)
#define ItemH 183

@interface ZL_SliderView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) CGFloat offset_x;

@end

@implementation ZL_SliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.offset_x = 0.00;
        [self addAllView];
    }
    return self;
}

- (void)addAllView {
    CGSize size = self.frame.size;
    [self addSubview:self.collectionView];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    self.collectionView.frame = CGRectMake(-ItemW / 2, 0, ZL_SCREEN_WIDTH + ItemW, size.height);
    self.leftButton.frame = CGRectMake(0, 0, ItemW / 2, size.height);
    self.rightButton.frame = CGRectMake(ZL_SCREEN_WIDTH - ItemW / 2, 0, ItemW / 2, size.height);
}

#pragma mark - ButtonAction

- (void)leftButtonTouch {
    if (self.offset_x > 0) {
        self.offset_x -= ZL_SCREEN_WIDTH / 3;
    }
    [self.collectionView setContentOffset:CGPointMake(self.offset_x, 0) animated:YES];
}

- (void)rightButtonTouch {
    if (self.offset_x < (_titleArray.count + 2 - 4) * (ZL_SCREEN_WIDTH / 3)) {
        self.offset_x += ZL_SCREEN_WIDTH / 3;
    }
    [self.collectionView setContentOffset:CGPointMake(self.offset_x, 0) animated:YES];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat moveWidth = scrollView.contentOffset.x;
    self.leftButton.enabled = moveWidth > 0;
    self.rightButton.enabled = (moveWidth < (_titleArray.count + 2 - 4) * (ZL_SCREEN_WIDTH / 3));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat moveWidth = scrollView.contentOffset.x;
    if ((NSInteger)moveWidth % (NSInteger)(ZL_SCREEN_WIDTH / 3) < ZL_SCREEN_WIDTH / 6) {
        self.offset_x = ((NSInteger)moveWidth / (NSInteger)(ZL_SCREEN_WIDTH / 3)) * (ZL_SCREEN_WIDTH / 3);
    } else {
        self.offset_x = ((NSInteger)moveWidth / (NSInteger)(ZL_SCREEN_WIDTH * 1 / 3) + 1) * (ZL_SCREEN_WIDTH / 3);
    }
    [self.collectionView setContentOffset:CGPointMake(self.offset_x, 0) animated:YES];
}

- (void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView {
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    CGFloat moveWidth = scrollView.contentOffset.x;
    if ((NSInteger)moveWidth % (NSInteger)(ZL_SCREEN_WIDTH / 3) < ZL_SCREEN_WIDTH / 6) {
        self.offset_x = ((NSInteger)moveWidth / (NSInteger)(ZL_SCREEN_WIDTH / 3)) * (ZL_SCREEN_WIDTH / 3);
    } else {
        self.offset_x = ((NSInteger)moveWidth / (NSInteger)(ZL_SCREEN_WIDTH * 1 / 3) + 1) * (ZL_SCREEN_WIDTH / 3);
    }
    [self.collectionView setContentOffset:CGPointMake(self.offset_x, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        CGFloat moveWidth = scrollView.contentOffset.x;
        if ((NSInteger)moveWidth % (NSInteger)(ZL_SCREEN_WIDTH / 3) < ZL_SCREEN_WIDTH / 6) {
            self.offset_x = ((NSInteger)moveWidth / (NSInteger)(ZL_SCREEN_WIDTH / 3)) * (ZL_SCREEN_WIDTH / 3);
        } else {
            self.offset_x = ((NSInteger)moveWidth / (NSInteger)(ZL_SCREEN_WIDTH * 1 / 3) + 1) * (ZL_SCREEN_WIDTH / 3);
        }
        [self.collectionView setContentOffset:CGPointMake(self.offset_x, 0) animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArray.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZL_SliderCell *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SliderCell" forIndexPath:indexPath];
    sliderCell.contentImg.backgroundColor = [UIColor purpleColor];
    return sliderCell;
}

#pragma mark - Get

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(ItemW, ItemH);
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 15.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ZL_SliderCell class] forCellWithReuseIdentifier:@"SliderCell"];
    }
    return _collectionView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.enabled = NO;
        _leftButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
//        [_leftButton setBackgroundImage:[RGBA(255, 255, 255, 0.9) createImageWithColor] forState:UIControlStateNormal];
//        [_leftButton setBackgroundImage:[RGBA(255, 255, 255, 0.9) createImageWithColor] forState:UIControlStateDisabled];
        [_leftButton setImage:[UIImage imageNamed:@"move_left"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage new] forState:UIControlStateDisabled];
        [_leftButton addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
//        [_rightButton setBackgroundImage:[RGBA(255, 255, 255, 0.9) createImageWithColor] forState:UIControlStateNormal];
//        [_rightButton setBackgroundImage:[RGBA(255, 255, 255, 0.9) createImageWithColor] forState:UIControlStateDisabled];
        [_rightButton setImage:[UIImage imageNamed:@"move_right"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage new] forState:UIControlStateDisabled];
        [_rightButton addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
