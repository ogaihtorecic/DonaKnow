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
        
        [self.imagemEvento setImageWithURL:[NSURL URLWithString:theEvento.poster] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        //[self.imagemEventoButton setImage:self.imagemEvento.image forState:UIControlStateNormal];
        
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
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPhoto"]) {
        
        PhotoViewController *photoController = [segue destinationViewController];
        photoController.evento = self.evento;
    }
}

@end
