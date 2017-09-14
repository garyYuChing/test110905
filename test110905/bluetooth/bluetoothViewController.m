//
//  bluetoothViewController.m
//  test110905
//
//  Created by aklboy on 2017/9/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "bluetoothViewController.h"

@interface bluetoothViewController ()

@end

@implementation bluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//檢查藍芽狀態
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSMutableString *btStateStr = [ NSMutableString stringWithString:@"UpdateState"];
    //初始化藍芽
    CBCentralManager *CM = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    CBPeripheralManager *connectedPeripheral = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    
    BOOL *isWork = FALSE;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            [btStateStr appendString:@"Unknown\n"];
            break;
        case CBCentralManagerStateUnsupported:
            [btStateStr appendString:@"Unsupported\n"];
            break;
        case CBCentralManagerStateUnauthorized:
            [btStateStr appendString:@"Unauthorized\n"];
            break;
        case CBCentralManagerStateResetting:
            [btStateStr appendString:@"Resetting\n"];
            break;
        case CBCentralManagerStatePoweredOff:
            [btStateStr appendString:@"PoweredOff\n"];
            if (connectedPeripheral!=NULL){
                [CM cancelPeripheralConnection:connectedPeripheral];
            }
            break;
        case CBCentralManagerStatePoweredOn:
            [btStateStr appendString:@"PoweredOn\n"];
            isWork = TRUE;
            break;
        default:
            [btStateStr appendString:@"none\n"];
            break;
    }
    NSLog(@"%@",btStateStr);
   // [delegate didUpdateState:isWork message:nsmstring getStatus:central.state];

    
}

//前往設定藍芽開啟
-(void)openBLESetting
{
    NSURL *bluetoothURLOS8 = [NSURL URLWithString:@"prefs:root=General&path=Bluetooth"];
    NSURL *bluetoothURLOS9 = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    NSURL *bluetoothURLOS10 = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 10) {
        [[UIApplication sharedApplication] openURL:bluetoothURLOS10];
    }
    else if ([[[UIDevice currentDevice] systemVersion] intValue] >= 9) {
        [[UIApplication sharedApplication] openURL:bluetoothURLOS9];
    }
    else {
        [[UIApplication sharedApplication] openURL:bluetoothURLOS8];
    }
}
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
