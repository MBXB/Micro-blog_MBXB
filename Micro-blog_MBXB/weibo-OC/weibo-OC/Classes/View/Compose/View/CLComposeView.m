//
//  CLComposeView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/6.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLComposeView.h"
#import "CLComposeButton.h"
#import "UIImage+Additions.h"
#import "CLNavigationViewController.h"

@interface CLComposeView ()

@property (strong, nonatomic) UIImageView *bgImage;
@property (strong, nonatomic) UIImageView *sloganImage;

@end

@implementation CLComposeView {
    NSMutableArray *_buttonsArray;
    NSArray *_infoArray;
    UIViewController *_fromController;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = [UIScreen mainScreen].bounds;
    
    [self addSubview:self.bgImage];
    [self addSubview:self.sloganImage];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_sloganImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_offset(100);
    }];
    [self addChildButton];
}

- (void)addChildButton {
    CGFloat itemW = 80;
    CGFloat itemH = 110;
    
    // 每个按钮之间的间距
    CGFloat itemMargin = (CLScreenW - itemW * 3) / 4;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"compose" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    _infoArray = array;
    _buttonsArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        CLComposeButton *btn = [CLComposeButton setNormalTitle:dict[@"title"] andNormalColor:[UIColor darkGrayColor] andFont:14];
        [btn setImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 行
        NSInteger col = i % 3;
        // 列
        NSInteger row = i / 3;
        
        CGFloat x = (CGFloat)col * itemW + ((CGFloat)col + 1) * itemMargin;
        CGFloat y = (CGFloat)row * itemH + CLScreenH;
        
        //设置按钮的位置
        btn.frame = CGRectMake(x, y, itemW, itemH);
        [_buttonsArray addObject:btn];
        [self addSubview:btn];
    }
}

- (void)childButtonClick:(CLComposeButton *)sender {
    for (CLComposeButton *value in _buttonsArray) {
        [UIView animateWithDuration:0.25 animations:^{
            if (value == sender) {
                value.transform = CGAffineTransformMakeScale(2, 2);
            }else {
                value.transform = CGAffineTransformMakeScale(0.2, 0.2);
            }
            value.alpha = 0.1;
        } completion:^(BOOL finished) {
            NSInteger index = [_buttonsArray indexOfObject:sender];
            NSDictionary *dict = _infoArray[index];
            if (dict[@"class"] != nil && [dict[@"class"] length] != 0) {
                UIViewController *vController = [[NSClassFromString(dict[@"class"]) alloc] init];
                [_fromController presentViewController:[[CLNavigationViewController alloc]initWithRootViewController:vController] animated:true completion:nil];
                [self removeFromSuperview];
            }
        }];
    }
}

#pragma mark -- 按钮动画
// 按钮弹出动画
- (void)showWithController:(UIViewController *)fromController {
    _fromController = fromController;
    [fromController.view addSubview:self];
    
    [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self showAnimationWithButton:obj index:idx isUp:true];
    }];
}

// 按钮滑出动画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[_buttonsArray reverseObjectEnumerator].allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self showAnimationWithButton:obj index:idx isUp:false];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)showAnimationWithButton:(UIButton *)button index:(NSInteger)index isUp:(BOOL)isUp{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(button.center.x, button.center.y + (isUp? -350 : 350))];
    animation.springBounciness = 10;
    animation.springSpeed = 12;
    animation.beginTime = CACurrentMediaTime() + (CGFloat)index * 0.025;
    [button pop_addAnimation:animation forKey:nil];
}

#pragma mark -- 懒加载
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithImage:[[UIImage getScreenSnap] blur]];
    }
    return _bgImage;
}

- (UIImageView *)sloganImage {
    if (!_sloganImage) {
        _sloganImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_slogan"]];
    }
    return _sloganImage;
}

@end
