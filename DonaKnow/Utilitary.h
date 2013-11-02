//
//  Utilitary.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 02/11/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilitary : NSObject

+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font text:(NSString*)text;
+ (void)drawInRect:(CGRect)rect withAttributes:(NSDictionary*)attributes text:(NSString*)text;
+ (void)showStatusBar;
@end
