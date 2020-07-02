//
//  JJDiscoverVC.m
//  JJSliderViewController
//
//  Created by 罗文琦 on 2017/4/15.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "JJDiscoverVC.h"
#import <AVFoundation/AVFoundation.h>

#define QRCodeWidth  260.0

typedef void (^HasScan)(NSString *result);
@interface JJDiscoverVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (copy,nonatomic)NSString * type;
@property (copy,nonatomic)NSString * count_;
@end

@implementation JJDiscoverVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    if (!token) {
        [ZDPayFuncTool getLogin];
    } else {
        [self setupScan:self.count_];
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.type = @"01";
    self.count_ = @"0";
    [self setupScanWindowView];
    __weak typeof(self) weakSelf = self;
    self.topNavBar.backBlock = ^{
        __weak __typeof(self) strongself = weakSelf;
        strongself.tabBarController.selectedIndex = 0;
    };
}

- (void)setupScanWindowView
{
    CGRect labelRect =[ZDPayFuncTool getStringWidthAndHeightWithStr:@"将二维码/条码放入框内，即可自动扫描\n环境过暗，请打开闪光灯" withFont:label_font_PingFangSC_Regular(14)];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake((ScreenWidth-QRCodeWidth)/2, mcStatusBarHeight+mcNavBarHeight+60, QRCodeWidth, labelRect.size.height);
    label.text = @"将二维码/条码放入框内，即可自动扫描\n环境过暗，请打开闪光灯";
    label.font = label_font_PingFangSC_Regular(14);
    label.textColor = label_color_255;
    label.backgroundColor =  [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:.3/1.0];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];

    UIView *scanWindow = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-QRCodeWidth)/2, label.bottom+20, QRCodeWidth, QRCodeWidth)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    scanWindow.layer.borderColor = label_color_255.CGColor;
    scanWindow.layer.borderWidth = 1;
    
    CGFloat scanNetImageViewH = 241;
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    scanNetImageView.frame =CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(QRCodeWidth);
    scanNetAnimation.duration = 1.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
    CGFloat buttonWH = 18;
    UIView *topLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [scanWindow addSubview:topLeft];
    [topLeft borderForColor:[UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] borderWidth:10.0f borderType:UIBorderSideTypeTop | UIBorderSideTypeLeft];
    
    UIView *topRight = [[UIView alloc] initWithFrame:CGRectMake(QRCodeWidth-buttonWH, 0, buttonWH, buttonWH)];
    [scanWindow addSubview:topRight];
    [topRight borderForColor:[UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] borderWidth:10.0f borderType:UIBorderSideTypeTop | UIBorderSideTypeRight];
    
    UIView *bottomLeft = [[UIView alloc] initWithFrame:CGRectMake(0, QRCodeWidth-buttonWH, buttonWH, buttonWH)];
    [scanWindow addSubview:bottomLeft];
    [bottomLeft borderForColor:[UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] borderWidth:10.0f borderType:UIBorderSideTypeLeft | UIBorderSideTypeBottom];
    
    UIView *bottomRight = [[UIView alloc] initWithFrame:CGRectMake(QRCodeWidth-buttonWH, QRCodeWidth-buttonWH, buttonWH, buttonWH)];
    [scanWindow addSubview:bottomRight];
    [bottomRight borderForColor:[UIColor colorWithRed:140/255.0 green:239/255.0 blue:86/255.0 alpha:1/1.0] borderWidth:10.0f borderType:UIBorderSideTypeRight | UIBorderSideTypeBottom];
    
}

- (void)setupScan:(NSString *)count_ {
    if (![count_ isEqualToString:@"0"]) {
        return;
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
   
    //有效扫描区域
    CGFloat x = ((ScreenHeight-QRCodeWidth-64)/2.0)/ScreenHeight;
    CGFloat y = ((ScreenWidth-QRCodeWidth)/2.0)/ScreenWidth;
    CGFloat width = QRCodeWidth/ScreenHeight;
    CGFloat height = QRCodeWidth/ScreenWidth;
    output.rectOfInterest = CGRectMake(x, y, width, height);
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
   
    if ([self.session canAddInput:input]) [self.session addInput:input];
    if ([self.session canAddOutput:output]) [self.session addOutput:output];
   
    //qrcode
    if ([self.type isEqualToString:@"01"]) {
       output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    //barcode
    } else if ([self.type isEqualToString:@"02"]) {
       output.metadataObjectTypes=@[AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeUPCECode,
                                    AVMetadataObjectTypeCode39Code,
                                    AVMetadataObjectTypeCode39Mod43Code,
                                    AVMetadataObjectTypeCode93Code,
                                    AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypePDF417Code];
    }
   
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
   
    [self.session startRunning];
    self.count_ = @"1";
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   NSString *stringValue;
   if ([metadataObjects count] >0){
       [_session stopRunning];
           
       AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
       stringValue = metadataObject.stringValue;
       
       [self showMessage:stringValue target:nil];
   }
}



@end
