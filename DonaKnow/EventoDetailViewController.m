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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

@end
