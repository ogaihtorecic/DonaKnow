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
    
    NSArray *attachmentsArray = [dictionary objectForKey:@"attachments"];
    if(attachmentsArray.count > 0) {
        NSDictionary *attachment = [attachmentsArray objectAtIndex:[attachmentsArray count] - 1];
        NSString *thumbnail = [[[attachment objectForKey:@"images"] objectForKey:@"small"] objectForKey:@"url"];
        [evento setThumbnail: thumbnail];
    }
    
    NSArray *termsArray = [dictionary objectForKey:@"terms"];
    
    NSDictionary *term = [termsArray objectAtIndex:0];
    [evento setLocal: [term objectForKey:@"title"]];
    [evento setEndereco: [term objectForKey:@"description"]];
    
    NSDictionary *customFields = [dictionary objectForKey:@"custom_fields"];
    
    NSArray *atracoesArray = [customFields objectForKey:@"bandas"];
    [evento setAtracoes: [atracoesArray objectAtIndex:0]];
    
    NSArray *informacoesArray = [customFields objectForKey:@"informacoes"];
    [evento setInformacoes: [informacoesArray objectAtIndex:0]];
    
    NSArray *valorArray = [customFields objectForKey:@"quanto"];
    [evento setValor: [valorArray objectAtIndex:0]];
    
    NSArray *observacaoArray = [customFields objectForKey:@"observacao"];
    [evento setObservacoes: [observacaoArray objectAtIndex:0]];
    
    return evento;
}

@end
