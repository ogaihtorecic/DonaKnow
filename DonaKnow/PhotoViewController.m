//
//  PhotoViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 22/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "PhotoViewController.h"
#import "Evento.h"
#import "Utilitary.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#define HEIGHT_MARGIN   7.0f
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

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
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setNeedsStatusBarAppearanceUpdate];
        self.modalPresentationCapturesStatusBarAppearance = YES;
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
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
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [closeButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
        [closeButton.layer setCornerRadius:4.0f];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
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
    
    NSMutableString *text = [[NSMutableString alloc] init];
    [text appendString:evento.nome];
    [text appendString:@" @ "];
    [text appendString:evento.local];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E, dd/MM/yyyy 'às' HH:mm"];
    NSString *text2 = [formatter stringFromDate:evento.data];
    
    NSString *text3 = evento.atracoes;
    
    UIFont *font = [UIFont fontWithName:@"Futura" size:32.0f];
    CGSize textSize = CGSizeMake(320.0f, 20000.0f);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    CGSize rect = [Utilitary boundingRectWithSize:textSize font:font text:text];
    
    UIFont *font2 = [UIFont fontWithName:@"Futura" size:20.0f];
    NSDictionary *attrs2 = [NSDictionary dictionaryWithObjectsAndKeys:font2, NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    CGSize rect2 = [Utilitary boundingRectWithSize:textSize font:font2 text:text2];
    
    UIFont *font3 = [UIFont fontWithName:@"Futura" size:18.0f];
    NSDictionary *attrs3 = [NSDictionary dictionaryWithObjectsAndKeys:font3, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    CGSize rect3 = [Utilitary boundingRectWithSize:textSize font:font3 text:text3];
    
    CGSize size = CGSizeMake(rect.width, rect.height + rect2.height + rect3.height + HEIGHT_MARGIN * 2);
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    else
        UIGraphicsBeginImageContext(size);

    CGRect rect_ = CGRectMake(0.0f, 0.0f, rect.width, rect.height);
    [Utilitary drawInRect:rect_ withAttributes:attrs text:text];
    
    CGRect text2Rect = CGRectMake(0.0f, rect_.origin.y + rect.height + HEIGHT_MARGIN, rect2.width, rect2.height);
    [Utilitary drawInRect:text2Rect withAttributes:attrs2 text:text2];
    
    CGRect text3Rect = CGRectMake(0.0f, text2Rect.origin.y + text2Rect.size.height + HEIGHT_MARGIN, rect3.width, rect3.height);
    [Utilitary drawInRect:text3Rect withAttributes:attrs3 text:text3];
    
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
