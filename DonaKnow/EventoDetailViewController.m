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

#import <SDWebImage/UIImageView+WebCache.h>
#import <Social/Social.h>

@interface EventoDetailViewController ()

- (void)configureView;

@end

@implementation EventoDetailViewController

#pragma mark - Managing the detail item

NSMutableArray *keys;
NSMutableArray *values;

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
    
    if (theEvento) {
        
        self.nomeEventoLabel.text = theEvento.nome;
        self.nomeEventoLabel.numberOfLines = 2;
        
        self.localLabel.text = theEvento.local;
        self.localLabel.numberOfLines = 2;
        
        [self.imagemEvento setImageWithURL:[NSURL URLWithString:theEvento.imagem] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        self.imagemEvento.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.imagemEvento.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
        
        tapOnce.numberOfTapsRequired = 1;
        
        [self.imagemEvento addGestureRecognizer:tapOnce];
        [self.imagemEvento setUserInteractionEnabled:YES];
        
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
    }
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    PhotoViewController *viewController = [[PhotoViewController alloc] init];
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    viewController.evento = self.evento;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"DetalheCell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [keys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [values objectAtIndex:indexPath.row];
    
    if(([cell.textLabel.text isEqualToString:@"Endereço"] && self.evento.latitude != 0.000000 && self.evento.longitude != 0.000000) ||
        [cell.textLabel.text isEqualToString:@"Informações"]) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.textLabel.text isEqualToString:@"Endereço"]) {
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
    } else if([cell.textLabel.text isEqualToString:@"Informações"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:cell.detailTextLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
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
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [controller setInitialText:self.evento.nome];
            [controller addURL:[NSURL URLWithString:self.evento.url]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
    } else if ([choice isEqualToString:@"Facebook"]) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:self.evento.nome];
            [controller addURL:[NSURL URLWithString:self.evento.url]];
            [controller addImage:self.imagemEvento.image];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
    }
}

@end
