//
//  TopicViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TopicViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "Topic.h"
#import "PersistentStore.h"
@interface TopicViewController ()

@end

@implementation TopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        topicList = [PersistentStore getAllObjectWithType:[Topic class]];
        topicList = [[topicList reverseObjectEnumerator] allObjects];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"话题";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_topicListTableView clearSeperateLine];
}

- (IBAction)finishAction:(id)sender
{
    [_topicValue resignFirstResponder];
    if([_topicValue.text length] == 0)
    {
        return ;
    }
    
    NSString * str = _topicValue.text;
    if(self.didSelectTopic)
    {
        self.didSelectTopic(str);
    }
    
    //先判断话题是否存在数据库，如果不存在，则保存
    int count = [PersistentStore countOfObjectWithType:[Topic class] Key:@"topic" Value:str];
    if(count == 0)
    {
        Topic * topic = [Topic MR_createEntity];
        topic.topic = str;
        [PersistentStore save];
    }
    
    [self popVIewController];
}


#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topicList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    Topic * topic = topicList[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = topic.topic;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic * topic = topicList[indexPath.row];
    if(self.didSelectTopic)
    {
        self.didSelectTopic(topic.topic);
    }
    
    [self popVIewController];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length < 1) {
        _topicListTableView.hidden = NO;
    }
    else
        _topicListTableView.hidden = YES;
}

@end
