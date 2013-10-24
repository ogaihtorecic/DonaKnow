//
//  PhotoViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 22/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "PhotoViewController.h"
#import "Evento.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface PhotoViewController ()

- (UIImage*)placeholderImage;

@end

@implementation PhotoViewController

@synthesize evento;
@synthesize imageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.modalPresentationCapturesStatusBarAppearance = YES;
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) loadView {
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    
    [imageView setImageWithURL:[NSURL URLWithString:evento.imagem] placeholderImage:[self placeholderImage]];
    [imageView setUserInteractionEnabled:TRUE];
    
    self.view = imageView;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton addTarget:self action:@selector(hidePhoto) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"FECHAR" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    [closeButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    [closeButton.layer setCornerRadius:4.0f];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    float buttonWidth = 70.0;
    float buttonHeight = 30.0;
    float buttonX = self.view.frame.size.width - buttonWidth - 10.0;
    float buttonY = 20.0;
    closeButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    
    [self.view addSubview:closeButton];
}

- (void)hidePhoto
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (UIImage*)placeholderImage {
    NSString *nomeEvento = evento.nome;
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGSize size  = [nomeEvento sizeWithFont:font];
    
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    [nomeEvento drawInRect:CGRectMake(0,0,size.width,size.height) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
