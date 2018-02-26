//
//  DetailViewController.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/24.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>

@interface DetailViewController ()<WKUIDelegate,WKNavigationDelegate,NSXMLParserDelegate> {
    UIProgressView *_progressView;
}

@property (nonatomic, strong)WKWebView *wkWebView;
@property (nonatomic, strong)HCDataManager *dataManager;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听webview的进度
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.dataManager = [HCDataManager manager];
    [self initUI];
    [self initProgressview];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.page_url]]];
}

- (void)initUI{
    
    self.titleText = self.model.title;
    [self.topContainerView addSubview:self.backButton];
    UIImage  *img1 = IMGNAMED(@"favorite");
    self.rightButton.frame = CGRectMake(self.containerView.width-img1.size.width-2, 0, img1.size.width, img1.size.height);
    self.rightButton.centerY = self.topContainerView.height/2;
    self.rightButton.right = SCREEN_WIDTH - 20;
    [self.rightButton setImage:img1 forState:UIControlStateNormal];
    [self.rightButton setImage:IMGNAMED(@"unfavorite") forState:UIControlStateSelected];
    self.rightButton.selected = [self.dataManager isExistModel:self.model];
    
    [self wkWebView];

}

- (void)initProgressview {
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 15)];
    _progressView.backgroundColor = [UIColor clearColor];
    _progressView.alpha = 1.0;
    _progressView.progressTintColor = [UIColor blackColor];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    _progressView.progress = 0.0;
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    [self.view addSubview:_progressView];
}

#pragma mark - actions

- (void)rightBarBtnClickAction:(UIButton *)btn{

    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.dataManager insertRemindData:self.model];
        [HUDUtils showHUDToast:LOCALIZED(@"收藏成功")];
    }else{
        [self.dataManager removeRelationShipOfRemindContent:self.model];
        [HUDUtils showHUDToast:LOCALIZED(@"取消收藏")];
    }
}

-(BOOL)currentLanguageIsEnglish{
    //获取当前设备语言
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName isEqualToString:@"en"]) {
        return YES;
    }
    
    return NO;
    
}

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        
        WKWebViewConfiguration* configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        //    configuration.preferences = [NSClassFromString(@"WKPreferences") new];
        configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:configuration];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        _wkWebView.backgroundColor = [UIColor clearColor];
        _wkWebView.opaque = NO;
        [self.view addSubview:_wkWebView];
//            [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _wkWebView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if(resultBOOL)
    {
//        self.currentRequest = navigationAction.request;
        if(navigationAction.targetFrame == nil)
        {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    _progressView.hidden = NO;
    
    [self callback_webViewDidStartLoad];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    _progressView.hidden = YES;
    _progressView.progress = 0.0;
    
    [self callback_webViewDidFinishLoad];
}
- (void)webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    _progressView.hidden = YES;
    _progressView.progress = 0.0;
    
    [self callback_webViewDidFailLoadWithError:error];
}
- (void)webView: (WKWebView *)webView didFailNavigation:(WKNavigation *) navigation withError: (NSError *) error
{
    [self callback_webViewDidFailLoadWithError:error];
}

- (void)callback_webViewDidFinishLoad
{
//    if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)])
//    {
//        [self.delegate webViewDidFinishLoad:self];
//    }
}
- (void)callback_webViewDidStartLoad
{
//    if([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)])
//    {
//        [self.delegate webViewDidStartLoad:self];
//    }
}
- (void)callback_webViewDidFailLoadWithError:(NSError *)error
{
//    if([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
//    {
//        [self.delegate webView:self didFailLoadWithError:error];
//    }
}
-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    BOOL resultBOOL = YES;
//    if([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
//    {
//        if(navigationType == -1) {
//            navigationType = UIWebViewNavigationTypeOther;
//        }
//        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
//    }
    return resultBOOL;
}

#pragma mark -- 监听进度条和title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.wkWebView) {
            [_progressView setAlpha:1.0f];
            [_progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
            
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark --
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
