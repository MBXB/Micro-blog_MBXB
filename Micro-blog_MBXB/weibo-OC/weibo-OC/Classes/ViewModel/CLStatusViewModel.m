//
//  CLStatusViewModel.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import "CLStatusViewModel.h"
#import "CLStatusModel.h"
#import "CLUserModel.h"
#import "RegexKitLite.h"
#import "CLMatchResult.h"
#import "CLEmoiconModel.h"
#import "CLEmoticonKeyboardViewModel.h"

@implementation CLStatusViewModel

- (void)setModel:(CLStatusModel *)model {
    _model = model;
    
    NSInteger rank = model.user.mbrank;
    if (rank > 0) {
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%zd",rank];
        self.memberImage = [UIImage imageNamed:imageName];
    }
    
    NSInteger type = model.user.verified_type;
    switch (type) {
        case 0:  // 大v
            self.avatatImage = [UIImage imageNamed:@"avatar_vip"];
            break;
        case 2:  // 企业
        case 3:
        case 5:
            self.avatatImage = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case 200: // 达人
            self.avatatImage = [UIImage imageNamed:@"avatar_grassroot"];
            break;
        default:
            break;
    }
    
    self.reposts_count = [self caclCount:model.reposts_count defaultTitle:@"转发"];
    self.comments_count = [self caclCount:model.comments_count defaultTitle:@"评论"];
    self.attitudes_count = [self caclCount:model.attitudes_count defaultTitle:@"赞"];
    
    NSString *name = model.retweeted_status.user.name;
    NSString *text = model.retweeted_status.text;
    if (name != nil || text != nil) {
        self.retweetStatusText = [NSString stringWithFormat:@"@%@:%@",name, text];
        self.retweetAttributedText = [self dealStatusTextWithString:_retweetStatusText];
    }
    
    // 格式化来源
    if(model.source != nil && model.source.length != 0){
        NSString *preString = @"\">";
        NSString *sufString = @"</";
        NSRange preRange = [model.source rangeOfString:preString];
        NSRange sufRange = [model.source rangeOfString:sufString];
        NSString *result = [model.source substringWithRange:NSMakeRange(preRange.location + preString.length, sufRange.location - preRange.location - preString.length)];
        self.sourceString = [@"来自 " stringByAppendingString:result];
    }
    
    self.originalAttributedText = [self dealStatusTextWithString:_model.text];
}

// 格式化时间来源
- (NSString *)createAtString {
    if (self.model.created_at == nil)
        return nil;
    NSDate *creatAt = self.model.created_at;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 当前时间
    NSDate *currentDate = [NSDate date];
    
    if ([self  isThisYearWithDate:creatAt]) {
        if ([calendar isDateInToday:creatAt]) {
            NSTimeInterval result = [currentDate timeIntervalSinceDate:creatAt];
            if (result < 60) {
                return @"刚刚";
            }else if (result < 3600) {
                return [NSString stringWithFormat:@"%zd 分钟前",(NSInteger)result / 60];
            }else {
                return [NSString stringWithFormat:@"%zd 小时前",(NSInteger)result / 3600];
            }
            
        }else if ([calendar isDateInYesterday:creatAt]) {
            // 昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:creatAt];
            
        }else {
            // 其他
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:creatAt];
        }
    }else {
        // 不是今年的
        formatter.dateFormat = @"yyyy-MM--dd";
        return [formatter stringFromDate:creatAt];
    }
}

- (NSAttributedString *)dealStatusTextWithString:(NSString *)text {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableArray *matchResults = [NSMutableArray array];
    
    [text enumerateStringsMatchedByRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        // 取到匹配的字符串
        NSString *chs = *capturedStrings;
        // 取到匹配的范围
        NSRange range = *capturedRanges;
        // 将匹配的结果初始化为一个模型
        CLMatchResult *matchResult = [[CLMatchResult alloc] initWithCaptureString:chs CaptureRange:range];
        // 将结果保存在一个数组中，方便反序遍历，替换表情
        [matchResults addObject:matchResult];
    }];
    
    
    [[matchResults reverseObjectEnumerator].allObjects enumerateObjectsUsingBlock:^(CLMatchResult *match, NSUInteger index, BOOL * _Nonnull stop) {
        CLEmoiconModel *emoticon = [[CLEmoticonKeyboardViewModel sharedManeger] getEmoticonWithString:match.captureString];
        // 获取文本所对应的表情图片
        NSBundle *bundle = [CLEmoticonKeyboardViewModel sharedManeger].emoticonBundel;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",emoticon.path,emoticon.png] inBundle:bundle compatibleWithTraitCollection:nil];
        
        UIFont *font = [UIFont systemFontOfSize:CLStatusContentFontSize];
        CGFloat imageHW = font.lineHeight;
        
        NSMutableAttributedString *attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(imageHW, imageHW) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        // 使用指定的富文本替换指定位置的数据
        [result replaceCharactersInRange:match.captureRange withAttributedString:attr];
    }];
    
    [self addHighlightedWithRegex:@"" attributedString:result];
    [self addHighlightedWithRegex:@"@[a-zA-Z0-9\\u4e00-\\u9fa5_\\-]+" attributedString:result];
    [self addHighlightedWithRegex:@"([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.',;]*)?" attributedString:result];
    return result;
}
    
- (void)addHighlightedWithRegex:(NSString *)regex attributedString:(NSMutableAttributedString *)attr {
    [attr.string enumerateStringsMatchedByRegex:regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        UIColor *color = [UIColor colorWithRed:80.0 / 255 green:125.0 / 255 blue:175.0 / 255 alpha:1];
        UIColor *bgColor = [UIColor colorWithRed:177.0 / 255 green:215.0 / 255 blue:255.0 / 255 alpha:1];
        
        [attr addAttribute:NSForegroundColorAttributeName value:color range:*capturedRanges];
        
        YYTextBorder *border = [YYTextBorder borderWithFillColor:bgColor cornerRadius:3];
        border.insets = UIEdgeInsetsZero;
        
        YYTextHighlight *highLighted = [[YYTextHighlight alloc] init];
        highLighted.userInfo = @{@"value": *capturedStrings};
        
        [highLighted setColor:[UIColor redColor]];
        [highLighted setBackgroundBorder:border];
        
        highLighted.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            YYTextHighlight *highlighted = [attr yy_attribute:YYTextHighlightAttributeName atIndex:range.location];
            NSLog(@"%@",highlighted.userInfo[@"value"]);
        };
        [attr yy_setTextHighlight:highLighted range:*capturedRanges];
    }];
}
    
- (BOOL)isThisYearWithDate:(NSDate *)target {
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    
    NSString *targetYear = [formatter stringFromDate:target];
    NSString *currentYear = [formatter stringFromDate:currentDate];
    
    return [targetYear isEqualToString:currentYear];
}

- (NSString *)caclCount:(NSInteger)count defaultTitle:(NSString *)defaultTitle{
    if (count == 0) {
        return defaultTitle;
    }else {
        if (count < 10000) {
            return @(count).description;
        }else {
            NSInteger result = count / 1000;
            NSString *str =  @((CGFloat)result / 10).description;
            str = [str stringByAppendingString:@"万"];
            return [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
}

@end
