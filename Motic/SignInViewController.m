//
//  SignInViewController.m
//  Motic
//
//  Created by Rose CW on 9/9/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homebg.png"]];
        self.signUpView.logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
        self.signUpView.usernameField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
        self.signUpView.usernameField.textColor = [UIColor darkGrayColor];
        self.signUpView.passwordField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
        self.signUpView.passwordField.textColor = [UIColor darkGrayColor];

        self.signUpView.emailField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
        self.signUpView.emailField.textColor = [UIColor darkGrayColor];

        
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
