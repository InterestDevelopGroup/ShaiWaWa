//
//  LocationsViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "LocationsViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UIView+CutLayer.h"
#import "SVProgressHUD.h"
#import "CSqlite.h"
#import "BMapKit.h"
@interface LocationsViewController ()
{
    CSqlite *m_sqlite;
}
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,strong) NSMutableArray * placemarks;
@end

@implementation LocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _placemarks = [@[] mutableCopy];
        m_sqlite = [[CSqlite alloc]init];
        [m_sqlite openSqlite];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter=0.5;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"我在这里";
    [self setLeftCusBarItem:@"square_back" action:@selector(backAction:)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除位置" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 10, 60, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearLocation) forControlEvents:UIControlEventTouchUpInside];
    [btn changeLayerToRoundWithCornerRadius:4.0 MasksToBounds:YES BorderWidth:0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
   
    //清除分割线
    [_addrTableView clearSeperateLine];
    
}

- (void)backAction:(id)sender
{
    if([_placemarks count] == 0)
    {
        if(self.didSelectPlacemark)
        {
            self.didSelectPlacemark(nil);
        }
    }
    
    [self popVIewController];
}


//搜索过滤地址
- (IBAction)finishEvent:(id)sender
{
    [_addrField resignFirstResponder];
    if([_addrField.text length] == 0)
    {
        return ;
    }
    
    NSMutableArray * tmp = [@[] mutableCopy];
    for(NSDictionary * placemark in _placemarks)
    {
        NSRange range = [placemark[@"address"] rangeOfString:_addrField.text];
        if(range.location != NSNotFound)
        {
            [tmp addObject:placemark];
        }
    }
    
    _placemarks = tmp;
    [_addrTableView reloadData];
}


//清楚地址
- (void)clearLocation
{
    _placemarks = [@[] mutableCopy];
    [_addrTableView reloadData];
    
    if(self.didSelectPlacemark)
    {
        self.didSelectPlacemark(nil);
    }
    
    [self popVIewController];
}


#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_placemarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    
    NSDictionary * info = _placemarks[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = info[@"name"];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = info[@"address"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * placemark = _placemarks[indexPath.row];
    if(self.didSelectPlacemark)
    {
        self.didSelectPlacemark(placemark);
    }
    [self popVIewController];
}


-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    //NSLog(sql);
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    //转为火星坐标
    CLLocationCoordinate2D mylocation = newLocation.coordinate;
    
    /*
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(mylocation,BMK_COORDTYPE_COMMON);
    //转换GPS坐标至百度坐标
    testdic = BMKConvertBaiduCoorFrom(mylocation,BMK_COORDTYPE_GPS);
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);

    mylocation = BMKCoorDictionaryDecode(testdic);
    */
    NSString * locationStr = [NSString stringWithFormat:@"%f,%f",mylocation.latitude,mylocation.longitude];
    NSString * urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=B56b08182a6df5a96b58a04eda049deb&location=%@&output=json&pois=1&coordtype=wgs84ll",locationStr];
    
    NSLog(@"%@",locationStr);
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [SVProgressHUD dismiss];
        
        if(connectionError)
        {
            [self showAlertViewWithMessage:@"定位失败."];
            return ;
        }
        
        NSError * error;
        NSDictionary * info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        //NSLog(@"%@",info);
        
        //先判断解析定位是否成功
        if (error) {
            [self showAlertViewWithMessage:@"地理位置解析错误."];
            return;
        }
        
        if(info[@"status"] == nil || ![info[@"status"] isEqual:@0])
        {
            [self showAlertViewWithMessage:@"地理位置解析错误."];
            return;
        }
        
        if(info[@"result"] == nil)
        {
            [self showAlertViewWithMessage:@"地理位置解析错误."];
            return;
        }
        
        //可变数组，用于存放解析得到的地理位置
        NSMutableArray * results = [@[] mutableCopy];
        //获取解析到的地理信息
        NSDictionary * resultInfo = info[@"result"];
        //解析第一个地理信息
        NSMutableDictionary * addressInfo = [@{} mutableCopy];
        if(resultInfo[@"location"] != nil)
        {
            addressInfo[@"latitude"] = resultInfo[@"location"][@"lat"];
            addressInfo[@"longitude"] = resultInfo[@"location"][@"lng"];
        }
        
        if(resultInfo[@"formatted_address"] != nil)
        {
            addressInfo[@"address"] = resultInfo[@"formatted_address"];
            addressInfo[@"name"] = resultInfo[@"formatted_address"];
        }
        //判断信息是否完整
        if([addressInfo count] == 4)
        {
            [results addObject:addressInfo];
        }
        
        //解析周边地理信息
        if(resultInfo[@"pois"] != nil)
        {
            
            for(NSDictionary * tmpInfo in resultInfo[@"pois"])
            {
                NSMutableDictionary * addressInfo = [@{} mutableCopy];
                addressInfo[@"latitude"] = tmpInfo[@"point"][@"y"];
                addressInfo[@"longitude"] = tmpInfo[@"point"][@"x"];
                addressInfo[@"name"] = tmpInfo[@"name"];
                addressInfo[@"address"] = tmpInfo[@"addr"];
                
                [results addObject:addressInfo];
                
                addressInfo = nil;
            }
            
        }
        
        _placemarks = results;
        [_addrTableView reloadData];
        
    }];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [_locationManager stopUpdatingLocation];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"定位失败!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alertView show];
    alertView = nil;
}



#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self popVIewController];
}

@end
