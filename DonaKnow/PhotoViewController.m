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
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
    
    tapOnce.numberOfTapsRequired = 1;
    
    [self.imageView addGestureRecognizer:tapOnce];
    [self.imageView setUserInteractionEnabled:YES];
    
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
    
    [imageView setImageWithURL:[NSURL URLWithString:evento.posterGrande] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.view = imageView;
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
