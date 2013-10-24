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

#define HEIGHT_MARGIN   7.0f

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
    CGRect rect = [text boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs context:nil];
    
    UIFont *font2 = [UIFont fontWithName:@"Futura" size:20.0f];
    NSDictionary *attrs2 = [NSDictionary dictionaryWithObjectsAndKeys:font2, NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    CGRect rect2 = [text2 boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs2 context:nil];
    
    UIFont *font3 = [UIFont fontWithName:@"Futura" size:18.0f];
    NSDictionary *attrs3 = [NSDictionary dictionaryWithObjectsAndKeys:font3, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    CGRect rect3 = [text3 boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs3 context:nil];
    
    CGSize size = CGSizeMake(rect.size.width, rect.size.height + rect2.size.height + rect3.size.height + HEIGHT_MARGIN * 2);
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    else
        UIGraphicsBeginImageContext(size);
    
    [text drawInRect:rect withAttributes:attrs];
    
    CGRect text2Rect = CGRectMake(rect2.origin.x, rect.origin.y + rect.size.height + HEIGHT_MARGIN, rect2.size.width, rect2.size.height);
    [text2 drawInRect:text2Rect withAttributes:attrs2];
    
    CGRect text3Rect = CGRectMake(rect3.origin.x, text2Rect.origin.y + text2Rect.size.height + HEIGHT_MARGIN, rect3.size.width, rect3.size.height);
    [text3 drawInRect:text3Rect withAttributes:attrs3];
    
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
