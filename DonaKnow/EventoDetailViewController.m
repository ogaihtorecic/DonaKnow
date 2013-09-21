//
//  EventoDetailViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventoDetailViewController.h"
#import "Evento.h"

@interface EventoDetailViewController ()

- (void)configureView;

@end

@implementation EventoDetailViewController

#pragma mark - Managing the detail item

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

        self.enderecoLabel.text = theEvento.endereco;
        self.enderecoLabel.numberOfLines = 2;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy 'às' HH:mm"];
        
        self.dataLabel.text = [formatter stringFromDate:theEvento.data];
        
        self.atracoesLabel.text = theEvento.atracoes;
        self.atracoesLabel.numberOfLines = 2;
        
        self.informacoesLabel.text = theEvento.informacoes;
        self.informacoesLabel.numberOfLines = 2;
        
        self.valorLabel.text = theEvento.valor;
        
        self.observacoesLabel.text = theEvento.observacoes;
        self.observacoesLabel.numberOfLines = 2;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.reuseIdentifier isEqualToString:@"EnderecoCell"]) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

@end
