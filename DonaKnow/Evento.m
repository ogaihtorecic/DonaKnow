//
//  Evento.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "Evento.h"

@implementation Evento

-(id)initWithNome:(NSString *)nome local:(NSString *)local endereco:(NSString *)endereco observacoes:(NSString *)observacoes
{
    self = [super init];
    if (self) {
        _nome = nome;
        _local = local;
        _endereco = endereco;
        _observacoes = observacoes;
        
        return self;
    }
    return nil;
}

+ (Evento *) withDictionary: (NSDictionary *) dictionary {
    Evento * evento = [[Evento alloc] init];
    [evento setNome: [dictionary objectForKey:@"title"]];
    
    NSArray *termsArray = [dictionary objectForKey:@"terms"];
    for (NSDictionary *term in termsArray){
        [evento setLocal: [term objectForKey:@"title"]];
        [evento setEndereco: [term objectForKey:@"description"]];
    }
    
    [evento setObservacoes: @"Observacoes"];
    
    return evento;
}

@end
