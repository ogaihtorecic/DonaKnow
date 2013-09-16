//
//  Evento.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "Evento.h"

@implementation Evento

+ (Evento *) withDictionary: (NSDictionary *) dictionary {
    Evento * evento = [[Evento alloc] init];
    [evento setNome: [dictionary objectForKey:@"title"]];
    [evento setThumbnail: [dictionary objectForKey:@"thumbnail"]];
    
    NSArray *termsArray = [dictionary objectForKey:@"terms"];
    for (NSDictionary *term in termsArray){
        [evento setLocal: [term objectForKey:@"title"]];
        [evento setEndereco: [term objectForKey:@"description"]];
    }
    
    NSDictionary *customFields = [dictionary objectForKey:@"custom_fields"];
    
    NSArray *atracoesArray = [customFields objectForKey:@"bandas"];
    [evento setAtracoes: [atracoesArray componentsJoinedByString:@", "]];
    
    NSArray *informacoesArray = [customFields objectForKey:@"informacoes"];
    [evento setInformacoes: [informacoesArray componentsJoinedByString:@", "]];
    
    NSArray *valorArray = [customFields objectForKey:@"quanto"];
    [evento setValor: [valorArray objectAtIndex:0]];
    
    NSArray *observacaoArray = [customFields objectForKey:@"observacao"];
    [evento setObservacoes: [observacaoArray objectAtIndex:0]];
    
    return evento;
}

@end
