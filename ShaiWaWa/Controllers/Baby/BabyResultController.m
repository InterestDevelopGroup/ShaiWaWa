//
//  BabyResultController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-10-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyResultController.h"
#import "PinYin4Objc.h"
#import "BabyInfo.h"
#import "UIImageView+WebCache.h"
#import "BabyListCell.h"
#import "BabyHomePageViewController.h"
@interface BabyResultController ()
{
    NSMutableArray *_resultBabys; // 放着所有搜索到的宝宝
}

@end

@implementation BabyResultController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor colorWithRed:212/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    _resultBabys = [NSMutableArray array];
}


- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    
    // 1.清除之前的搜索结果
    [_resultBabys removeAllObjects];
    
    // 2.筛选宝宝
    HanyuPinyinOutputFormat *fmt = [[HanyuPinyinOutputFormat alloc] init];
    fmt.caseType = CaseTypeUppercase;
    fmt.toneType = ToneTypeWithoutTone;
    fmt.vCharType = VCharTypeWithUUnicode;
    NSMutableArray *searahArr = [NSMutableArray array];
    for (BabyInfo *b in _myBabyList) {
        [searahArr addObject:b];
    }
    for (BabyInfo *b in _friendsBabyList) {
        [searahArr addObject:b];
    }
    
    for (BabyInfo *baby in searahArr) {
        // 1.拼音
        NSString *pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:baby.nickname withHanyuPinyinOutputFormat:fmt withNSString:@"#"];
        // 2.拼音首字母
        NSArray *words = [pinyin componentsSeparatedByString:@"#"];
        NSMutableString *pinyinHeader = [NSMutableString string];
        for (NSString *word in words) {
            [pinyinHeader appendString:[word substringToIndex:1]];
        }
        
        // 去掉所有的#
        pinyin = [pinyin stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        // 3.宝宝昵称名中包含了搜索条件
        // 拼音中包含了搜索条件
        // 拼音首字母中包含了搜索条件
        if (([baby.nickname rangeOfString:searchText].length != 0) ||
            ([pinyin rangeOfString:searchText.uppercaseString].length != 0)||
            ([pinyinHeader rangeOfString:searchText.uppercaseString].length != 0))
        {
            // 说明宝宝昵称中包含了搜索条件
            [_resultBabys addObject:baby];
        }
    }

    // 3.刷新表格
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共%d个搜索结果", _resultBabys.count];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultBabys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    BabyInfo *baby = _resultBabys[indexPath.row];
    babyListCell.babyNameLabel.text = baby.nickname;
    
    [babyListCell.babyImage sd_setImageWithURL:[NSURL URLWithString:baby.avatar] placeholderImage:[UIImage imageNamed:@"user_touxiang"]];
    
    if([baby.sex isEqualToString:@"0"])
    {
        //保密
        babyListCell.babySexImage.hidden = YES;
    }
    else if([baby.sex isEqualToString:@"1"])
    {
        //男
        babyListCell.babySexImage.hidden = NO;
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_boy.png"];
    }
    else if([baby.sex isEqualToString:@"2"])
    {
        //女
        babyListCell.babySexImage.hidden = NO;
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_girl.png"];
    }
    
    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@"%@条动态",baby.record_count];
    
    if([baby.is_focus isEqualToString:@"0"])
    {
        babyListCell.focusImageView.hidden = YES;
    }
    else
    {
        babyListCell.focusImageView.hidden = NO;
    }
    return babyListCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    [self.tableView removeFromSuperview];
    BabyInfo *baby = _resultBabys[indexPath.row];
    BabyHomePageViewController *vc = [[BabyHomePageViewController alloc]init];
    vc.babyInfo = baby;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.parentViewController push:vc];
}


@end
