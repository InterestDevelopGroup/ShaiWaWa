//
//  ScannerQRCodeViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ScannerQRCodeViewController.h"
#import "QRCodeCardViewController.h"
#import "UIViewController+BarItemAdapt.h"



@interface ScannerQRCodeViewController ()

@end

@implementation ScannerQRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = @"扫一扫";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [self initZBar];
  
}

- (void)initZBar
{
    zbarReaderView = [[ZBarReaderView alloc] init];
    zbarReaderView.frame = CGRectMake(22, 44, self.view.frame.size.width-44, (self.view.frame.size.height - 88)/2);
    zbarReaderView.readerDelegate = self;
    //关闭闪光灯
    zbarReaderView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = CGRectMake(22, 44, self.view.frame.size.width-44, (self.view.frame.size.height - 88)/2);
    //CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(zbarReaderView.frame) - 126, 200, 200);
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc] initWithViewController:self];
        cameraSimulator.readerView = zbarReaderView;
    }
    [self.view addSubview:zbarReaderView];
    //扫描区域计算
    zbarReaderView.scanCrop =[self getScanCrop:scanMaskRect readerViewBounds:zbarReaderView.bounds];
    
    [zbarReaderView start];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        break;
    }
    
    [zbarReaderView stop];
}
- (IBAction)showMyQRCodeVC:(id)sender
{
    QRCodeCardViewController *qrCodeCardVC = [[QRCodeCardViewController alloc] init];
    [self.navigationController pushViewController:qrCodeCardVC animated:YES];
}
@end
