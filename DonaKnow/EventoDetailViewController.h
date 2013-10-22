//
//  EventoDetailViewController.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <EventKitUI/EventKitUI.h>

@class Evento;

@interface EventoDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, EKEventEditViewDelegate>

@property (strong, nonatomic) Evento *evento;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIButton *imageReferenceButton;

@end
