//
//  ViewController.h
//  runtimeStuff
//
//  Created by Julio Andrés Carrettoni on 21/09/12.
//  Copyright (c) 2012 Julio Andrés Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIButton *buttonA;
    IBOutlet UIButton *buttonB;
    IBOutlet UISwitch *theSwitch;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}
- (IBAction)onButtonATUI:(id)sender;
- (IBAction)onButtonBTUI:(id)sender;
@end
