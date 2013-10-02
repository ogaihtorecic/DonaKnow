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

@interface PhotoViewController ()

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
    
    [imageView setImageWithURL:[NSURL URLWithString:evento.imagem] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [imageView setUserInteractionEnabled:TRUE];
    
    self.view = imageView;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton addTarget:self action:@selector(hidePhoto) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"Fechar" forState:UIControlStateNormal];
    [closeButton.layer setBorderWidth:2.0f];
    [closeButton.layer setBorderColor:[UIColor lightTextColor].CGColor];
    closeButton.layer.masksToBounds = YES;
    [closeButton.layer setCornerRadius:4.0f];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    closeButton.backgroundColor = [UIColor lightGrayColor];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
