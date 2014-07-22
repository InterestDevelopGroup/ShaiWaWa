//
//  ScannerQRCodeViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

#import "ZBarSDK.h"

@interface ScannerQRCodeViewController : CommonViewController<ZBarReaderViewDelegate>
{
    ZBarReaderView *zbarReaderView;
}

- (IBAction)showMyQRCodeVC:(id)sender;

@end
