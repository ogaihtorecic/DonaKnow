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
#define HEADER_TEXT_WIDTH   232.0f
#define HEADER_TEXT_X       88.0f
#define HEADER_HEIGHT       100.0f
#define CONTENT_MARGIN      7.0f
#define HEADER_CONTENT_MARGIN      5.0f

@interface EventoDetailViewController ()

- (void)configureView;

@end

@implementation EventoDetailViewController

#pragma mark - Managing the detail item

NSMutableArray *keys;
NSMutableArray *values;

UIAlertView *phoneAlert;
UIAlertView *mapAlert;
UIAlertView *calendarAlert;
UIAlertView *webAlert;

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

        UIFont *nomeEventoFont = [UIFont boldSystemFontOfSize:FONT_SIZE];
        UILabel *nomeEventoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nomeEventoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [nomeEventoLabel setNumberOfLines:0];
        [nomeEventoLabel setFont:nomeEventoFont];
        [self.header addSubview:nomeEventoLabel];
        
        CGSize headerTextSize = CGSizeMake(HEADER_TEXT_WIDTH, 20000.0f);
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:nomeEventoFont, NSFontAttributeName, nil];
        CGRect nomeEventoRect = [theEvento.nome boundingRectWithSize:headerTextSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs context:nil];
        
        UIFont *localEventoFont = [UIFont systemFontOfSize:FONT_SIZE];
        UILabel *localEventoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        localEventoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [localEventoLabel setNumberOfLines:0];
        [localEventoLabel setFont:localEventoFont];
        [self.header addSubview:localEventoLabel];
        
        attrs = [NSDictionary dictionaryWithObjectsAndKeys:localEventoFont, NSFontAttributeName, nil];
        CGRect localEventoRect = [theEvento.nome boundingRectWithSize:headerTextSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrs context:nil];
        
        float totalHeight = nomeEventoRect.size.height + localEventoRect.size.height;
        float nomeEventoY = HEADER_HEIGHT / 2 - totalHeight / 2;
        float localEventoY = nomeEventoY + nomeEventoRect.size.height + HEADER_CONTENT_MARGIN;
        
        [nomeEventoLabel setText:theEvento.nome];
        [nomeEventoLabel setFrame:CGRectMake(HEADER_TEXT_X, nomeEventoY, HEADER_TEXT_WIDTH, nomeEventoRect.size.height)];
        
        [localEventoLabel setText:theEvento.local];
        [localEventoLabel setFrame:CGRectMake(HEADER_TEXT_X, localEventoY, HEADER_TEXT_WIDTH, localEventoRect.size.height)];
        
        
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
        calendarAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Criar Evento?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
        webAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Abrir Navegador?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
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
    [calendarAlert show];
}

- (void)tapWeb:(UIGestureRecognizer *)gesture {
    [webAlert show];
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
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(theEvento.latitude, theEvento.longitude);
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
                MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                [mapItem setName:theEvento.local];

                NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
                MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
            }
        }
    } else if(alertView == calendarAlert && buttonIndex == 1) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
            event.title = self.evento.nome;
            event.location = self.evento.local;
            event.startDate = self.evento.data;
            event.endDate   = [event.startDate dateByAddingTimeInterval:60*60];
            event.URL = [NSURL URLWithString:self.evento.url];
            event.notes = self.evento.atracoes;
            
            EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
            
            addController.eventStore = eventStore;
            addController.event=event;
            
            [self presentViewController:addController animated:YES completion:nil];
            
            addController.editViewDelegate = self;
        }];
        
    } else if(alertView == webAlert && buttonIndex == 1) {
        NSString *escaped = [self.evento.atracoes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", escaped];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
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
        
    } else if([cell.titleLabel.text isEqualToString:@"Atrações"]) {
        [cell.actionButton setImage:[UIImage imageNamed:@"Web.png"] forState:UIControlStateNormal];
        [cell.actionButton addTarget:self action:@selector(tapWeb:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    return TEXT_Y + height + CONTENT_MARGIN;
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

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
