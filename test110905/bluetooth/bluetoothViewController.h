//
//  bluetoothViewController.h
//  test110905
//
//  Created by aklboy on 2017/9/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface bluetoothViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
@end
