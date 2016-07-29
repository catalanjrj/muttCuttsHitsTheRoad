//
//  popOverControllerViewController.m
//  muttCuttsHitsTheRoad
//
//  Created by Jorge Catalan on 7/29/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

#import "popOverControllerViewController.h"
#import "FormValidation.h"

@interface popOverControllerViewController ()<UITextFieldDelegate>

@property(strong,nonatomic)UITextField *firstAddress;
@property(strong,nonatomic)UITextField *secondAddress;
@property(strong,nonatomic)NSMutableArray *locations;

@property(strong,nonatomic)FormValidation *formValidation;


-(void)presentError:(NSString *)title message:(NSString *)message;

@end

@implementation popOverControllerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Enter two cities";
 
    self.formValidation = [[FormValidation alloc]init];
    self.locations = [[NSMutableArray alloc]init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    CGRect textFieldFrameOne = CGRectMake(view.bounds.origin.x + 20, view.bounds.origin.y + 20, view.bounds.size.width * 0.9, 40);
    CGRect textFieldFrameTwo = CGRectMake(view.bounds.origin.x + 20, textFieldFrameOne.origin.y * 4, view.bounds.size.width * 0.9, 40);
    
    self.firstAddress = [[UITextField alloc] initWithFrame:textFieldFrameOne];
    self.firstAddress.backgroundColor = [UIColor whiteColor];
    self.firstAddress.borderStyle = UITextBorderStyleRoundedRect;
    self.firstAddress.placeholder =@"City, State";
    self.firstAddress.returnKeyType = UIReturnKeyNext;
    self.firstAddress.enablesReturnKeyAutomatically = YES;
    self.firstAddress.tag = 1;
    self.firstAddress.delegate = self;
    
    
    self.secondAddress = [[UITextField alloc] initWithFrame:textFieldFrameTwo];
    self.secondAddress.backgroundColor = [UIColor whiteColor];
    self.secondAddress.borderStyle = UITextBorderStyleRoundedRect;
    self.secondAddress.placeholder =@"City, State";
    self.secondAddress.returnKeyType = UIReturnKeyNext;
    self.secondAddress.enablesReturnKeyAutomatically = YES;
    self.secondAddress.tag = 2;
    self.secondAddress.delegate = self;
    
    [view addSubview:self.firstAddress];
    [view addSubview:self.secondAddress];
    [self.view addSubview:view];
    
    [self.firstAddress becomeFirstResponder];
    
    
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:self.firstAddress]){
        if([self.formValidation isAddressValid:textField.text]){
            [self.locations addObject:textField.text];
            [self.firstAddress resignFirstResponder];
            [self.secondAddress becomeFirstResponder];
            return YES;
        }else{
            [self presentError:@"Error" message:@"invalid city and state entered"];
        
        }
    
    }else if([textField isEqual:self.secondAddress]){
        if([self.formValidation isAddressValid:textField.text]){
            [self.locations addObject:textField.text];
            [self.secondAddress resignFirstResponder];
            return YES;
            
        }else{
            [self presentError:@"Error" message:@"invalid city and state entered"];
        
        }
    }
    return NO;
}

#pragma mark - Error Handling

-(void)presentError:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];

}





@end
