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

@interface LocationsViewController ()
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,strong) NSArray * placemarks;
@end

@implementation LocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _placemarks = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    for(CLPlacemark * placemark in _placemarks)
    {
        NSRange range = [placemark.name rangeOfString:_addrField.text];
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
    _placemarks = @[];
    [_addrTableView reloadData];
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
    
    CLPlacemark * placemark = _placemarks[indexPath.row];
    DDLogInfo(@"%@,%@,%@,%@,%@,%@,%@",placemark.thoroughfare,placemark.locality,placemark.subLocality,placemark.subThoroughfare,placemark.country,placemark.subLocality,placemark.administrativeArea);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    NSString * address = @"";
    if(placemark.subLocality != nil)
    {
        address = [address stringByAppendingString:placemark.subLocality];
    }
    if(placemark.thoroughfare != nil)
    {
        address = [address stringByAppendingString:placemark.thoroughfare];
    }
    if(placemark.subThoroughfare)
    {
        address = [address stringByAppendingString:placemark.subThoroughfare];
    }
    cell.textLabel.text = address;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = placemark.name;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLPlacemark * placemark = _placemarks[indexPath.row];
    if(self.didSelectPlacemark)
    {
        self.didSelectPlacemark(placemark);
    }
    [self popVIewController];
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
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"定位失败!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];
            alertView = nil;

            DDLogError(@"定位失败");
            return ;
        }
        
        if([placemarks count] > 0)
        {
            [_locationManager stopUpdatingLocation];
            _placemarks = placemarks;
            [_addrTableView reloadData];
            
//            CLPlacemark * placemark = placemarks[0];
//            _addrField.text = placemark.name;
        }
        
    }];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
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
