//
//  HomeViewController.m
//  Motic
//
//  Created by Rose CW on 9/9/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "SignInViewController.h"
#import "FaceViewController.h"

@interface HomeViewController ()
@property PFLogInView* loginView;
@property PFSignUpView* signUpView;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


//        [self.loginView setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"homebg.png"]] ];
        
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    if([PFUser currentUser]){
//        [PFUser logOut];
//        [self presentModalViewController:[FaceViewController new] animated:YES];
//    }
    if([PFUser currentUser]){
        FaceViewController* faceView = [FaceViewController new];
        [self presentModalViewController:faceView animated:YES];
    }
    
    //if (![PFUser currentUser])
    else {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.signUpController = [SignInViewController new];

        
        [self presentViewController:login animated:YES completion:NULL];
    
    
    
    login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsTwitter | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
    login.delegate = self;
    login.signUpController.delegate = self;
    

    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    NSLog(@"%@", error);
//    [self dismissModalViewControllerAnimated:YES];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissModalViewControllerAnimated:YES];
    
    [self presentModalViewController:[FaceViewController new] animated:YES];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
        [self dismissModalViewControllerAnimated:YES];
}
-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissModalViewControllerAnimated:YES];
    
}
-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    [self dismissModalViewControllerAnimated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
