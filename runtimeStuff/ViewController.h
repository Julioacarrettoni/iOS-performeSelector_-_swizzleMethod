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
    IBOutlet UISwitch *theSwitch;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}

- (IBAction)onExecuteTargetButtonTUI:(id)sender;

- (IBAction)onCancelAllTogglesButtonTUI:(id)sender;
- (IBAction)onCancelTogglesWithArgButtonTUI:(id)sender;
- (IBAction)onCancelTogglesWithOutArgButtonTUI:(id)sender;

@end
