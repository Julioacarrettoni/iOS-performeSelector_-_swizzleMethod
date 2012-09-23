//
//  ViewController.m
//  runtimeStuff
//
//  Created by Julio Andrés Carrettoni on 21/09/12.
//  Copyright (c) 2012 Julio Andrés Carrettoni. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+myProxyForPerformSelectorWithObjectAfterDelay.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    activityIndicator.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc {
    [theSwitch release];
    [activityIndicator release];
    [super dealloc];
}

- (void) toggle
{
    [theSwitch setOn:!theSwitch.isOn animated:YES];
    activityIndicator.hidden = YES;
}

- (IBAction)onExecuteTargetButtonTUI:(id)sender {
    [self performSelector:@selector(toggle) withObject:nil afterDelay:2.0];
    activityIndicator.hidden = NO;
}

- (IBAction)onCancelAllTogglesButtonTUI:(id)sender {
    [NSObject cancelALLPreviousPerformRequestsWithSelector:@selector(toggle)];
    activityIndicator.hidden = YES;
}

- (IBAction)onCancelTogglesWithArgButtonTUI:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggle) object:nil];
    activityIndicator.hidden = YES;
}

- (IBAction)onCancelTogglesWithOutArgButtonTUI:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggle)];
    activityIndicator.hidden = YES;
}
@end
