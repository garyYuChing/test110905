//
//  photoViewController.m
//  test110905
//
//  Created by aklboy on 2017/9/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "photoViewController.h"

@interface photoViewController (){
    
    IBOutlet UIImageView *imgView;
    
    
    BOOL isCamera;
    
    
}

@end

@implementation photoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   

    
    
}
- (IBAction)pickBtn:(id)sender {
   
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"訊息" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"使用相簿",@"使用相機",@"開啟藍芽" ,nil];
    
    
    [alert show];
    
    
    }



- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    
              //使用者按的 alertView 是要用來連線的
    
                   switch (buttonIndex) {
                case 0:
                    //NSLog(@"Cancel Button Pressed");
                    break;
                case 1:
                    
                    // 設定相片來源來自於手機內的相本
                    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    // 開啓相片瀏覽界面
                    [self presentViewController:imgPicker animated:YES completion:nil];
                           isCamera = NO;
                    break;
                case 2:
                    // 先檢查裝置是否配備相機
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        // 設定相片來源為裝置上的相機
                        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                       
                        // 開啓相片瀏覽界面
                        [self presentViewController:imgPicker animated:YES completion:nil];
                        isCamera = YES;
                    }
                    break;
                default:
                    break;
                   }
   
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取得使用者拍攝的照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //存檔，需判斷使用相簿內照片不存檔
    if (isCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    }
    
    imgView.image = image;
    // 關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
    isCamera = NO;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 當使用者按下取消按鈕後關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
