//
//  EventoDetailViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventoDetailViewController.h"
#import "Evento.h"
#import "PhotoViewController.h"
#import "DetailTableCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

#define CELL_CONTENT_WIDTH  261.0f
#define FONT_SIZE           16.0f
#define TEXT_X              10.0f
#define TEXT_Y              25.0f
#define TEXT_MAX_HEIGHT     28.0f

@interface EventoDetailViewController ()

- (void)configureView;

@end

@implementation EventoDetailViewController

#pragma mark - Managing the detail item

NSMutableArray *keys;
NSMutableArray *values;

UIAlertView *phoneAlert;
UIAlertView *mapAlert;

UIImageView *imagemEvento;

- (void)setEvento:(Evento *) newEvento
{
    if (_evento != newEvento) {
        _evento = newEvento;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    Evento *theEvento = self.evento;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if (theEvento) {
        imagemEvento = [[UIImageView alloc] initWithFrame:self.imageReferenceButton.frame];
        [imagemEvento setImageWithURL:[NSURL URLWithString:theEvento.imagem] placeholderImage:[UIImage imageNamed:@"placeholder_70x70.png"]];
        imagemEvento.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imagemEvento.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapImage:)];
        imageTap.numberOfTapsRequired = 1;
        [self.imageReferenceButton addGestureRecognizer:imageTap];
        
        CALayer* containerLayer = [CALayer layer];
        containerLayer.shadowColor = [UIColor blackColor].CGColor;
        containerLayer.shadowOffset = CGSizeMake(0.f, 5.f);
        containerLayer.shadowOpacity = 1.f;

        imagemEvento.layer.masksToBounds = YES;
        
        [containerLayer addSublayer:imagemEvento.layer];
        [self.view.layer addSublayer:containerLayer];

        self.nomeEventoLabel.text = theEvento.nome;
        self.nomeEventoLabel.numberOfLines = 2;
        
        self.localLabel.text = theEvento.local;
        self.localLabel.numberOfLines = 2;
        
        
        
        keys = [[NSMutableArray alloc] init];
        values = [[NSMutableArray alloc] init];
        
        if([theEvento.endereco length] > 0) {
            [keys addObject:@"Endereço"];
            [values addObject:theEvento.endereco];
        }
        
        if(theEvento.data) {
            [keys addObject:@"Data"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"E, dd/MM/yyyy 'às' HH:mm"];
            [values addObject:[formatter stringFromDate:theEvento.data]];
        }
        
        if([theEvento.atracoes length] > 0) {
            [keys addObject:@"Atrações"];
            [values addObject:theEvento.atracoes];
        }
        
        if([theEvento.informacoes length] > 0) {
            [keys addObject:@"Informações"];
            [values addObject:theEvento.informacoes];
        }
        
        if([theEvento.valor length] > 0) {
            [keys addObject:@"Valor"];
            [values addObject:theEvento.valor];
        }
        
        if([theEvento.observacoes length] > 0) {
            [keys addObject:@"Observações"];
            [values addObject:theEvento.observacoes];
        }
        
        phoneAlert = [[UIAlertView alloc] initWithTitle:nil message:self.evento.informacoes delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Ligar", nil];
        mapAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Abrir Mapa?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
    }
}

- (void)tapImage:(UIGestureRecognizer *)gesture
{
    PhotoViewController *viewController = [[PhotoViewController alloc] init];
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    viewController.evento = self.evento;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)tapPin:(UIGestureRecognizer *)gesture {
    [mapAlert show];
}

- (void)tapCalendar:(UIGestureRecognizer *)gesture {
    
}

- (void)tapPhone:(UIGestureRecognizer *)gesture {
    [phoneAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == phoneAlert && buttonIndex == 1) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.evento.informacoes];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else if(alertView == mapAlert && buttonIndex == 1) {
        Evento *theEvento = self.evento;
        if(theEvento.latitude != 0.000000 && theEvento.longitude != 0.000000) {
            Class mapItemClass = [MKMapItem class];
            if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
            {
                // Create an MKMapItem to pass to the Maps app
                CLLocationCoordinate2D coordinate =
                CLLocationCoordinate2DMake(theEvento.latitude, theEvento.longitude);
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
                MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                [mapItem setName:theEvento.local];
                
                // Set the directions mode to "Walking"
                // Can use MKLaunchOptionsDirectionsModeDriving instead
                NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
                // Get the "Current User Location" MKMapItem
                MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                // Pass the current location and destination map items to the Maps app
                // Set the direction mode in the launchOptions dictionary
                [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                               launchOptions:launchOptions];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *tableIdentifier = @"DetailTableCell";
    DetailTableCell *cell = (DetailTableCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    UILabel *label = nil;
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:tableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        
        [[cell contentView] addSubview:label];
    }
    cell.titleLabel.text = [keys objectAtIndex:indexPath.row];
    [cell.actionButton setShowsTouchWhenHighlighted:YES];
    
    if(([cell.titleLabel.text isEqualToString:@"Endereço"] && self.evento.latitude != 0.000000 && self.evento.longitude != 0.000000)) {
        [cell.actionButton setImage:[UIImage imageNamed:@"Pin.png"] forState:UIControlStateNormal];
        [cell.actionButton addTarget:self action:@selector(tapPin:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if([cell.titleLabel.text isEqualToString:@"Informações"]) {
        [cell.actionButton setImage:[UIImage imageNamed:@"Phone.png"] forState:UIControlStateNormal];
        [cell.actionButton addTarget:self action:@selector(tapPhone:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if([cell.titleLabel.text isEqualToString:@"Data"]) {
        [cell.actionButton setImage:[UIImage imageNamed:@"Calendar.png"] forState:UIControlStateNormal];
        [cell.actionButton addTarget:self action:@selector(tapCalendar:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    NSString *text = [values objectAtIndex:indexPath.row];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs context:nil];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:text];
    [label setFrame:CGRectMake(TEXT_X, TEXT_Y, CELL_CONTENT_WIDTH, MAX(rect.size.height, TEXT_MAX_HEIGHT))];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [values objectAtIndex:[indexPath row]];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs context:nil];
    
    CGFloat height = MAX(rect.size.height, TEXT_MAX_HEIGHT);
    
    return TEXT_Y + height + 7.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(shareEvento);
    
    [self configureView];
}

- (void)shareEvento {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Compartilhar" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", nil];
    
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([choice isEqualToString:@"Twitter"]) {
            
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:self.shareText];
        [controller addURL:[NSURL URLWithString:self.evento.url]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    } else if ([choice isEqualToString:@"Facebook"]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:self.shareText];
        [controller addURL:[NSURL URLWithString:self.evento.url]];
        [controller addImage:imagemEvento.image];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

- (NSString *)shareText {
    NSMutableString *text = [[NSMutableString alloc] init];
    [text appendString:self.evento.nome];
    [text appendString:@" @ "];
    [text appendString:self.evento.local];
    return text;
}

@end
