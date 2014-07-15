//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "UICollectionViewWaterfallCell.h"

@interface UICollectionViewWaterfallCell()
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) UILabel *releaseNameLabel;
@property (nonatomic, strong) UILabel *releaseTimeLabel;
@property (nonatomic, strong) UITextView *explainTextView;
@end

@implementation UICollectionViewWaterfallCell

#pragma mark - Accessors
- (UILabel *)displayLabel
{
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
//        _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayLabel.backgroundColor = [UIColor lightGrayColor];
        _displayLabel.textColor = [UIColor whiteColor];
        _displayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayLabel;
}

- (UILabel *)releaseNameLabel
{
    if (!_releaseNameLabel) {
        _releaseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, 20)];
//        _releaseNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _releaseNameLabel.backgroundColor = [UIColor lightGrayColor];
        _releaseNameLabel.textColor = [UIColor whiteColor];
        _releaseNameLabel.font = [UIFont systemFontOfSize:15];
//        _releaseNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _releaseNameLabel;
}

- (UILabel *)releaseTimeLabel
{
    if (!_releaseTimeLabel) {
        _releaseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 24, 80, 20)];
//        _releaseTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _releaseTimeLabel.backgroundColor = [UIColor lightGrayColor];
        _releaseTimeLabel.textColor = [UIColor whiteColor];
        _releaseTimeLabel.font = [UIFont systemFontOfSize:12];
//        _releaseTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _releaseTimeLabel;
}

- (UITextView *)explainTextView
{
    if (!_explainTextView) {
        _explainTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 90, 80, 20)];
//        _explainTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _explainTextView.scrollEnabled = NO;
        _explainTextView.editable = NO;
        _explainTextView.showsHorizontalScrollIndicator = NO;
        _explainTextView.showsVerticalScrollIndicator = NO;
        _explainTextView.backgroundColor = [UIColor lightGrayColor];
        _explainTextView.textColor = [UIColor whiteColor];
        _explainTextView.textAlignment = NSTextAlignmentCenter;
    }
    return _explainTextView;
}


- (void)setDisplayString:(NSString *)displayString
{
    if (![_displayString isEqualToString:displayString]) {
        _displayString = [displayString copy];
        self.displayLabel.text = _displayString;
    }
}

- (void)setReleaseTimeString:(NSString *)releaseTimeString
{
    if (![_releaseTimeString isEqualToString:releaseTimeString]) {
        _releaseTimeString = [releaseTimeString copy];
        self.releaseTimeLabel.text = _releaseTimeString;
    }
}

- (void)setReleaseNameString:(NSString *)releaseNameString
{
    if (![_releaseNameString isEqualToString:releaseNameString]) {
        _releaseNameString = [releaseNameString copy];
        self.releaseNameLabel.text = _releaseNameString;
    }
}

- (void)setExplainString:(NSString *)explainString
{
    if (![_explainString isEqualToString:explainString]) {
        _explainString = [explainString copy];
        self.explainTextView.text = _explainString;
    }
}
#pragma mark - Life Cycle
- (void)dealloc
{
    [_displayLabel removeFromSuperview];
    _displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.displayLabel];
        
        releaseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-45, self.bounds.size.width, 45)];
        releaseView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        releaseView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:releaseView];
        [releaseView addSubview:self.releaseNameLabel];
        [releaseView addSubview:self.releaseTimeLabel];
        
        //[self.contentView addSubview:self.explainTextView];
        
    }
    return self;
}

@end
