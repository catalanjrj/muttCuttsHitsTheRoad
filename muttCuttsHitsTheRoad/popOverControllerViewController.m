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
    
    self.formValidation = [[FormValidation alloc]init];
    self.locations = [[NSMutableArray alloc]init];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor darkGrayColor];
    
    CGRect textFieldFrameOne = CGRectMake(view.bounds.origin.x + 20, view.bounds.origin.y + 20, view.bounds.size.width * 0.9,40);
    CGRect textFieldFrameTwo = CGRectMake(view.bounds.origin.x + 20, view.bounds.origin.y + 20, view.bounds.size.width * 0.9,40);
    
    self.firstAddress = [[[UITextField alloc]init] initWithFrame:textFieldFrameOne];
    self.firstAddress.backgroundColor = [UIColor whiteColor];
    self.firstAddress.borderStyle = UITextBorderStyleBezel;
    self.firstAddress.placeholder =@"City, State";
    self.firstAddress.returnKeyType = UIReturnKeyNext;
    self.firstAddress.enablesReturnKeyAutomatically = YES;
    self.firstAddress.tag = 1;
    self.firstAddress.delegate = self;
    
    
    self.secondAddress = [[[UITextField alloc]init] initWithFrame:textFieldFrameOne];
    self.secondAddress.backgroundColor = [UIColor whiteColor];
    self.secondAddress.borderStyle = UITextBorderStyleBezel;
    self.secondAddress.placeholder =@"City, State";
    self.secondAddress.returnKeyType = UIReturnKeyNext;
    self.secondAddress.enablesReturnKeyAutomatically = YES;
    self.secondAddress.tag = 2;
    self.secondAddress.delegate = self;
    
    [view addSubview:self.firstAddress];
    [view addSubview:self.secondAddress];
    [self.firstAddress becomeFirstResponder];
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
