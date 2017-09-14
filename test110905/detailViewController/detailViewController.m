//
//  detailViewController.m
//  test110905
//
//  Created by aklboy on 2017/9/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "detailViewController.h"
/*
 將api提供資訊show出
 資料格式json
 圖片採輪播方式
*/


@interface detailViewController (){
    
    
    IBOutlet UILabel *titleLab;
    IBOutlet UILabel *dateLab;
    IBOutlet UIScrollView *imgSV;
    IBOutlet UIScrollView *contentSV;
    IBOutlet UILabel *contentLab;
    
    NSMutableData *receivedData;
    NSURLConnection *connection;
    
    NSString *title,*date,*img,*content;
    
    
    CGFloat screenWidth,screenHeight;
    
    
    //圖片輪播用變數
    NSMutableArray *entries;
    NSUserDefaults *defaults;
    NSMutableArray *dataAry;
    NSTimer *_timer;
    BOOL isAdd;
    int page_point ;
    NSMutableArray *advsList;
}


@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    screenWidth = mSize.width;
    screenHeight = mSize.height;
    
    page_point = 0;
    //連線
    [self connectHttp];
}


-(void)connectHttp{
    //receivedData 是否存在
    if (receivedData == nil) {
        receivedData = [[NSMutableData alloc]init];
    }
    
    //資料從頭開始
    [receivedData setLength:0];
    
    //串起api網址
    NSString *urlStr = [NSString stringWithFormat:@"%@/Query/AppNewsItem.ashx?id=30",NSLocalizedString(@"api_ip", @"")];
    //NSString *img_url =[NSString stringWithFormat:@"%@/Query/AppNewsItem.ashx?id=3055",NSLocalizedString(@"api_ip", @"")];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        receivedData = nil;
    }

}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError");
    
    
    connection = nil;
    receivedData = nil;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
    title = [res objectForKey:@"title"];
    date = [res objectForKey:@"date"];
    img = [res objectForKey:@"pic"];
    content = [res objectForKey:@"content"];
    NSLog(@"%@",img);
    [titleLab setText:title];
    [dateLab setText:date];
    
    
   
    CGSize size = [content sizeWithFont:contentLab.font constrainedToSize:CGSizeMake(contentLab.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    // 設定Label的內容跟尺寸
    [contentLab setFrame:CGRectMake(contentLab.frame.origin.x, contentLab.frame.origin.y, contentLab.frame.size.width, size.height)];
    
    [contentSV setContentSize:CGSizeMake(screenWidth , size.height+50)];
    [contentLab setText:content];
    
    //圖片輪播
    [self addView:img];
    [self showAdvs];
    [self addNSTimer];
}

#pragma mark -添加控件
- (void)addView:(NSArray*)picAry{
    
    
    advsList = [(NSArray*)picAry mutableCopy];
    
    
    // advsList= [[NSMutableArray alloc]init];
    //添加图片
    /*for (int i = 1; i < 4; i++) {
     [advsList addObject:[NSString stringWithFormat:@"about_logo%d.jpg",i]];
     }*/
    for(int i = 0 ;i <advsList.count;i++){
    NSLog(@"img:%@",[advsList objectAtIndex:i]);
    }
    
    //设置代理这个必须的
    imgSV.delegate = self;
    //设置总大小也就是里面容纳的大小
    imgSV.contentSize = CGSizeMake(self.view.frame.size.width * advsList.count,180);
    [imgSV setBackgroundColor:[UIColor whiteColor]];
    //里面的子视图跟随父视图改变大小
    [imgSV setAutoresizesSubviews:YES];
    //设置分页形式，这个必须设置
    [imgSV setPagingEnabled:YES];
    //隐藏横竖滑动块
    [imgSV setShowsVerticalScrollIndicator:NO];
    [imgSV setShowsHorizontalScrollIndicator:NO];
    
}



#pragma mark -展示广告位,初始化
-(void)showAdvs{
    
    CGSize size = CGSizeMake(imgSV.frame.size.width, imgSV.frame.size.height);
    
    isAdd = true;
    
    for (UIView *view in [imgSV subviews]){
        [view removeFromSuperview];
    }
    for(int i = 0; i < [advsList count]; i ++){
        UIButton *thumbView = [[UIButton alloc] init];
        [thumbView addTarget:self
                      action:@selector(myDidSelectAdvAtIndex:)
            forControlEvents:UIControlEventTouchUpInside];
        //  thumbView.tag = i;
        // thumbView.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, img_scrollView.frame.size.height);
        
        NSString *img_url =[NSString stringWithFormat:@"%@Upload/Pic/%@",NSLocalizedString(@"api_ip", @""), [advsList objectAtIndex:i]];
        
        //UIImage *urlimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]];
        
        
        UIImage *urlimage = [self resizeImage:[[UIImage alloc] initWithData:imageData] reSize:size];
        
        CGSize mSize = [[UIScreen mainScreen] bounds].size;
        
        //urlimage width
        CGFloat imgWidth = urlimage.size.width*(imgSV.frame.size.height/urlimage.size.height)-(mSize.width/3);
        CGFloat imgHeight = imgSV.frame.size.height;
        
        CGFloat flagWidth = mSize.width -150;
        if (imgWidth<flagWidth) {
            imgWidth = flagWidth;
        }
        
        thumbView.tag = i;
        thumbView.bounds = CGRectMake(0, 0, imgWidth, imgHeight);
        thumbView.center = CGPointMake(mSize.width *( 0.5 + i) , imgHeight * 0.5);
        
        [thumbView setBackgroundImage:urlimage forState:UIControlStateNormal];
        
        
        thumbView.adjustsImageWhenHighlighted = NO;
        [imgSV addSubview:thumbView];
    }
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -添加定时器
-(void)addNSTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

#pragma mark -删除定时器
-(void)removeNSTimer
{
    [ _timer invalidate];
    _timer =nil;
}


#pragma mark -定时器下一页
- (void)nextPage{
    //int num = self.pagePoint.currentPage;
    int num = page_point;
    if(isAdd){
        num++;
        if(num == advsList.count -1){
            isAdd = false;
        }
    }else{
        num--;
        if(num == 0){
            isAdd = true;
        }
    }
    [self scrollToIndex:num];
}

#pragma mark -滑动的距离
- (void)scrollToIndex:(NSInteger)index
{
    
    CGRect frame = imgSV.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [imgSV scrollRectToVisible:frame animated:YES];
}

#pragma mark -滑动完成时计算滑动到第几页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    page_point  = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    // [self.pagePoint setCurrentPage:page];
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

#pragma mark -点击广告
- (void)myDidSelectAdvAtIndex:(id) index
{
    UIButton *thumbView = (UIButton *)index;
    NSLog(@"你点击了第个%d广告",thumbView.tag);
}



- (IBAction)backBtn:(id)sender {
   // [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
