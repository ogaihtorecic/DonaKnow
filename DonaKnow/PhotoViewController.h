//
//  PhotoViewController.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 22/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Evento;

@interface PhotoViewController : UIViewController {
    Evento *evento;
    UIImageView *imageView;
}

@property(nonatomic, retain) Evento *evento;
@property(nonatomic, retain) UIImageView *imageView;

@end
