//
//  CLComposeController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/7.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLComposeController.h"
#import "UIBarButtonItem+Addition.h"
#import "CLTextView.h"
#import "CLUserAccountViewModel.h"
#import "CLUserAccount.h"
#import "CLComposeToolBar.h"
#import "CLComposePictureView.h"
#import "CLEmotionKeyboard.h"
#import "CLEmoiconModel.h"

@interface CLComposeController () <UITextViewDelegate, UIScrollViewDelegate, CLComposeToolBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) CLTextView *textView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) CLComposeToolBar *composeToolBar;
@property (strong, nonatomic) CLComposePictureView *composePictureView;
@property (strong, nonatomic) CLEmotionKeyboard *emotionKeyboard;

@end

@implementation CLComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 添加表情到textView上
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonButtonClick:) name:CLEmoticonButtonDidSelectedNotification object:nil];
    // 删除按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonButtonClick:) name:CLEmoticonButtonDidDeletedNotification object:nil];
}

- (void)setupUI {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" imageName:nil target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    // 默认设置为不可点击
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.titleView = self.titleLabel;

    [self.view addSubview:self.textView];
    [self.view addSubview:self.composeToolBar];
    [self.textView addSubview:self.composePictureView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.composeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.composePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(10);
        make.width.equalTo(_textView.mas_width).mas_offset(-20);
        make.height.equalTo(_composePictureView.mas_width);
    }];
}

#pragma mark - 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView endEditing:true];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)composeToolBarWithToolBar:(CLComposeToolBar *)toolBar composeToolBarType:(CLComposeToolBarType)type {
    switch (type) {
        case CLComposeToolBarTypePicture:
            [self selectPicture];
            break;
        case CLComposeToolBarTypeMention:
            NSLog(@"CLComposeToolBarTypeMention");
            break;
        case CLComposeToolBarTypeTrend:
            NSLog(@"CLComposeToolBarTypeTrend");
            break;
        case CLComposeToolBarTypeEmoticon:
            [self changeKeyboard];
            break;
        case CLComposeToolBarTypeAdd:
            NSLog(@"CLComposeToolBarTypeAdd");
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.composePictureView addImageWithImgae:[image scaleToWidth:600]];
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark - 监听事件

- (void)back {
    [self.textView endEditing:true];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)selectPicture {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:true completion:nil];
}

- (void)changeKeyboard {
    if (_textView.inputView == nil) {
        _textView.inputView = self.emotionKeyboard;
    }else {
        _textView.inputView = nil;
    }
    
    [_textView reloadInputViews];
    if (![_textView isFirstResponder]) {
        [_textView becomeFirstResponder];
    }
    // 告诉composeToolBar当前的键盘类型，方便修改按钮的样式
    self.composeToolBar.isSystemKeyboard = _textView.inputView == nil;
}

- (void)keyboardWillChangeFrame:(NSNotification *)sender {
    CGRect frame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.composeToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(frame.origin.y - CLScreenH);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)emoticonButtonClick:(NSNotification *)sender {
    if ([sender.name isEqual: CLEmoticonButtonDidSelectedNotification]) {
        CLEmoiconModel *model = sender.userInfo[@"emoticon"];
        [self.textView insertEmoticon:model];
    }else {
        [self.textView deleteBackward];
    }
}

- (void)send {
    if (self.composePictureView.imageArray.count == 0) {
        [self update];
    }else {
        [self upload];
    }
}

#pragma mark - 发送微博
// 发送文字微博
- (void)update {
    NSString *urlString = @"https://api.weibo.com/2/statuses/update.json";
    NSString *access_token = [CLUserAccountViewModel sharedManager].access_token;
    NSLog(@"%@",self.textView.emoticonText);
    NSDictionary *params = @{
                             @"access_token": access_token,
                             @"status": self.textView.emoticonText
                             };
    [[CLNetWorkTools sharedTools] requestWithHttpMethod:HTTPMethodPOST UrlString:urlString parameter:params completion:^(id response, NSError *error) {
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }
    }];
}

// 发送图文微博
- (void)upload {
    NSString *urlString = @"https://api.weibo.com/2/statuses/upload.json";
    NSString *access_token = [CLUserAccountViewModel sharedManager].access_token;
    
    NSDictionary *params = @{
                             @"access_token": access_token,
                             @"status": self.textView.emoticonText
                             };
    
    NSDictionary *fileData = @{
                               @"pic": UIImagePNGRepresentation(self.composePictureView.imageArray.firstObject)
                               };
    [[CLNetWorkTools sharedTools] uploadWithURLString:urlString parameter:params fileData:fileData completion:^(id response, NSError *error) {
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }
    }];
}

#pragma mark - 懒加载
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        // 设置不同状态下的北京图片
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"common_button_orange"] forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"common_button_orange_highlighted"] forState:UIControlStateHighlighted];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateDisabled];
        // 设置不同状态下的按钮文字颜色
        [_rightButton setTitleColor:[UIColor grayColor] forState: UIControlStateDisabled];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        // 设置按钮的大小
        _rightButton.frame = CGRectMake(0, 0, 44, 30);
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        NSString *name = [CLUserAccountViewModel sharedManager].account.name;
        _titleLabel = [UILabel labelWithText:name andTextColor:[UIColor blackColor] andFontSize:16];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *title = [NSString stringWithFormat:@"发微博\n%@",name];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        NSRange range = [title rangeOfString:name];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor grayColor]} range:range];
        _titleLabel.attributedText = attributedString;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (CLTextView *)textView {
    if (!_textView) {
        _textView = [[CLTextView alloc] initWithFrame:CGRectZero textContainer:nil];
        _textView.placeholder = @"听说下雨天，巧克力和音乐更配哦~~";
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.alwaysBounceVertical  = true;
    }
    return _textView;
}

- (CLComposeToolBar *)composeToolBar {
    if (!_composeToolBar) {
        _composeToolBar = [[CLComposeToolBar alloc] init];
        _composeToolBar.delegate = self;
    }
    return _composeToolBar;
}

- (CLComposePictureView *)composePictureView {
    if (!_composePictureView) {
        _composePictureView = [[CLComposePictureView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _composePictureView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) wealSelf = self;
        _composePictureView.addImageBlock = ^{
            [wealSelf selectPicture];
        };
    }
    return _composePictureView;
}

- (CLEmotionKeyboard *)emotionKeyboard {
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[CLEmotionKeyboard alloc] init];
        _emotionKeyboard.bounds = CGRectMake(0, 0, CLScreenW, 200);
    }
    return _emotionKeyboard;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
