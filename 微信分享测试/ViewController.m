//
//  ViewController.m
//  微信分享测试
//
//  Created by apple on 2018/6/1.
//  Copyright © 2018年 范文哲. All rights reserved.
//

#import "ViewController.h"
#import <WXApi.h>

#import <AFNetworking.h>

@interface ViewController ()<WXApiDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [WXApi registerApp: @"wx9d01aface61753a3"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [WXApi handleOpenURL:url delegate:self];
}
-(void) onReq:(BaseReq*)reqonReq{
    
}
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
         PayResp*response=(PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess:
                NSLog(@"支付成功");
                break;
                
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

/**
 <#Description#>

 @param req WXSceneSession (会话)   WXSceneTimeline（朋友圈）  WXSceneFavorite （微信收藏）
 @return <#return value description#>
 */
-(BOOL) sendReq:(BaseReq*)req{
    
    return  YES;
}

- (IBAction)button1:(id)sender { //文字类型分享示  分享到群聊
    SendMessageToWXReq *rep = [[SendMessageToWXReq alloc]init];
    rep.text = @"哈哈哈哈哈哈哈哈";
    rep.bText = YES;
    rep.scene = WXSceneFavorite; //收藏
    [WXApi sendReq:rep];
}
- (IBAction)button2:(id)sender { //图片类型分享示例  分享到朋友圈
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
    WXImageObject *imageObject = [WXImageObject object];
   NSString *filePath = [[ NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *rep = [[SendMessageToWXReq alloc]init];
    rep.bText = NO;
    rep.message = message;
    rep.scene = WXSceneTimeline; //朋友圈
    [WXApi sendReq:rep];
}
- (IBAction)button3:(id)sender { //音乐类型分享示例
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"音乐标题--银临 - 棠梨煎雪";
    message.description = @"音乐描述--- 测试一下微信音乐本地音乐分享功能";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    NSString *filePath = [[ NSBundle mainBundle] pathForResource:@"银临 - 棠梨煎雪" ofType:@"mp3"];

    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://music.163.com/#/m/song?id=564446999"; //
    ext.musicLowBandUrl = ext.musicUrl;
    ext.musicDataUrl = filePath;
    ext.musicLowBandDataUrl = ext.musicDataUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;//会话
    [WXApi sendReq:req];
}
- (IBAction)button4:(id)sender { // 视频类型分享示例
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"标题：";
    message.description = @"描述：  ";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = @"http://music.163.com/#/m/song?id=562594267";//视频url
    videoObject.videoLowBandUrl = videoObject.videoUrl;
    message.mediaObject = videoObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}
- (IBAction)button5:(id)sender {//网页类型分享示例
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"标题";
    message.description = @"描述";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = @"https://open.weixin.qq.com";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
}
- (IBAction)button6:(id)sender {//程序类型分享示例
}
- (IBAction)button7:(id)sender {//微信支付
    //参考链接 一 ：https://blog.csdn.net/deft_mkjing/article/details/52701608
    //统一下单
    //1.appid ------>
    //2.mch_id------->
    //3.device_info -------> 终端设备号(门店号或收银设备ID)，默认请传"WEB"
    //4.nonce_str ------> 随机字符串，不长于32位 //https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
    //5.sign ------>  sign  //https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
    //6.sign_type ------->  HMAC-SHA256       HMAC-SHA256和MD5，默认为MD5
    //7.body --------> 商品描述交易字段格式根据不同的应用场景按照以下格式： APP—— 需传入应用市场上的APP名字-实际商品名称，天天爱消除-游戏充值。
    //8.detail ------> 商品详细描述，对于使用单品优惠的商户，改字段必须按照规范上传，详 https://pay.weixin.qq.com/wiki/doc/api/danpin.php?chapter=9_102&index=2
    //9.attach ------> 深圳分店   附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
    //10.out_trade_no ---->20150806125346 商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*且在同一个商户号下唯一 //https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_2
    //11.fee_type -----> CNY 符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见  //https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_2
    //12.total_fee ----> //https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_2
    //13.spbill_create_ip -----> 123.12.12.123 用户端实际ip
    //14.time_start --- 订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010  时间规则//https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_2
    //15.time_expire---> 订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。订单失效时间是针对订单号而言的，由于在请求支付的时候有一个必传参数prepay_id只有两小时的有效期，所以在重入时间超过2小时的时候需要重新请求下单接口获取新的prepay_id。其他详//最短失效时间间隔大于1分钟
    //16.goods_tag---->订单优惠标记，代金券或立减优惠功能的参数 代金券立减优惠//https://pay.weixin.qq.com/wiki/doc/api/tools/sp_coupon.php?chapter=12_1
    //17.notify_url--->  http://www.weixin.qq.com/wxpay/pay.php   接收微信支付异步通知回调地址，通知url必须为直接可访问的url，不能携带参数。
    //18.trade_type---> APP 支付类型
    //19.limit_pay--->no_credit no_credit--指定不能使用信用卡支付
    //20.scene_info 该字段用于统一下单时上报场景信息，目前支持上报实际门店信息。{"store_id": "", //门店唯一标识，选填，String(32)"store_name":"”//门店名称，选填，String(64)}
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp= @"1397527777";
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
   
    [WXApi sendReq:request];
    
    
}
    



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
