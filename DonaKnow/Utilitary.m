//
//  Utilitary.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 02/11/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "Utilitary.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation Utilitary

+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font text:(NSString*)text {
    CGSize resultSize;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        resultSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    } else {
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGRect rect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs context:nil];
        resultSize = rect.size;
    }
    return resultSize;
}

+ (void)drawInRect:(CGRect)rect withAttributes:(NSDictionary *)attributes text:(NSString *)text {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        UIFont* font = [attributes objectForKey:NSFontAttributeName];
        UIColor* color = [attributes objectForKey:NSForegroundColorAttributeName];
        [color set];
        [text drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
    } else {
        [text drawInRect:rect withAttributes:attributes];
    }
}

+ (void)showStatusBar {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

static NSMutableArray *destaquesList;

+(NSMutableArray*)destaquesList
{
    return destaquesList;
}

+(void)setDestaquesList:(NSMutableArray*)list
{
    destaquesList = list;
}

static NSMutableArray *gratisList;

+(NSMutableArray*)gratisList
{
    return gratisList;
}

+(void)setGratisList:(NSMutableArray*)list
{
    gratisList = list;
}

@end
