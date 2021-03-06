//
//  SignupViewController.m
//  AJOAuth2
//
//  Created by Ashish Jabble on 20/01/17.
//  Copyright © 2017 Ashish Jabble. All rights reserved.
//

#import "SignupViewController.h"
#import "MCLocalization.h"
#import "Helper.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "AJOauth2ApiClient.h"

NSInteger const kFirstNamefieldTag = 1234;
NSInteger const kLastNameTextfieldTag = 1235;
NSInteger const kEmailTextfieldTag = 1236;
NSInteger const kPasswordTextfieldTag = 1237;
NSInteger const kDisplayNameTextfieldTag = 1238;
NSInteger const kDobTextfieldTag = 1239;

@interface SignupViewController ()

@end

@implementation SignupViewController

#pragma mark View-Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Navigation title
    self.navigationItem.title = [MCLocalization stringForKey:@"signup_nav_title"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[MCLocalization stringForKey:@"back_bar_button_item_title"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    // View BG Color
    self.view.backgroundColor = VIEW_BG_COLOR;
    
    // First Name Textfield
    _firstNameTextfield.placeholder = [MCLocalization stringForKey:@"first_name_placeholder"];
    _firstNameTextfield.tag = kFirstNamefieldTag;
    
    // Last Name Textfield
    _lastNameTextfield.placeholder = [MCLocalization stringForKey:@"last_name_placeholder"];
    _lastNameTextfield.tag = kLastNameTextfieldTag;
    
    // Email Textfield
    _emailTextfield.placeholder = [MCLocalization stringForKey:@"email_placeholder"];
    _emailTextfield.tag = kEmailTextfieldTag;
    _emailTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    
    // Password Textfield
    _passwordTextfield.placeholder = [MCLocalization stringForKey:@"password_placeholder"];
    _passwordTextfield.secureTextEntry = YES;
    _passwordTextfield.tag = kPasswordTextfieldTag;
    
    // Display name Textfield
    _displayNameTextfield.placeholder = [MCLocalization stringForKey:@"user_name_placeholder"];
    _displayNameTextfield.tag = kDobTextfieldTag;
    
    // DOB Textfield
    _dobTextfield.placeholder = [MCLocalization stringForKey:@"dob_placeholder"];
    _dobTextfield.tag = kDobTextfieldTag;
    
    // DOB - UIPickerView added as input view of UITextfield
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [_dobTextfield setInputView:datePicker];
    
    _firstNameTextfield.errorColor = _lastNameTextfield.errorColor = _emailTextfield.errorColor = _passwordTextfield.errorColor = _displayNameTextfield.errorColor = ERROR_LINE_COLOR;
    //_firstNameTextfield.lineColor = _lastNameTextfield.lineColor = _emailTextfield.lineColor = _passwordTextfield.lineColor = _displayNameTextfield.lineColor =  THEME_BG_COLOR;
    _firstNameTextfield.enableMaterialPlaceHolder = _lastNameTextfield.enableMaterialPlaceHolder = _emailTextfield.enableMaterialPlaceHolder = _passwordTextfield.enableMaterialPlaceHolder = _displayNameTextfield.enableMaterialPlaceHolder = YES;
    _firstNameTextfield.delegate = _lastNameTextfield.delegate = _emailTextfield.delegate = _passwordTextfield.delegate = _displayNameTextfield.delegate = self;
    _firstNameTextfield.autocorrectionType = _lastNameTextfield.autocorrectionType = _emailTextfield.autocorrectionType = _passwordTextfield.autocorrectionType = _displayNameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    _firstNameTextfield.returnKeyType = _lastNameTextfield.returnKeyType = _emailTextfield.returnKeyType = _passwordTextfield.returnKeyType = UIReturnKeyNext;
    _displayNameTextfield.returnKeyType = UIReturnKeyDone;
    _firstNameTextfield.clearButtonMode = _lastNameTextfield.clearButtonMode = _emailTextfield.clearButtonMode = _passwordTextfield.clearButtonMode = _displayNameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _firstNameTextfield.textColor = _lastNameTextfield.textColor = _passwordTextfield.textColor = _emailTextfield.textColor = _displayNameTextfield.textColor = _dobTextfield.textColor = TEXT_LABEL_COLOR;
    
    
    // Sign up button title
    [_signupButton setTitle:[MCLocalization stringForKey:@"signup_btn_title"] forState:UIControlStateNormal];
    _signupButton.layer.cornerRadius = BTN_CORNER_RADIUS;
    _signupButton.layer.borderWidth = BTN_BORDER_WIDTH;
    _signupButton.layer.borderColor = BTN_BORDER_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark IBAction

- (IBAction)signup:(id)sender {
    if (_firstNameTextfield.text.length == 0) {
        [_firstNameTextfield showError];
        return;
    }
    if (_lastNameTextfield.text.length == 0) {
        [_lastNameTextfield showError];
        return;
    }
    if (_emailTextfield.text.length == 0) {
        [_emailTextfield showError];
        return;
    }
    if (_passwordTextfield.text.length == 0) {
        [_passwordTextfield showError];
        return;
    }
    if (_displayNameTextfield.text.length == 0) {
        [_displayNameTextfield showError];
        return;
    }
    if (_dobTextfield.text.length == 0){
        [_dobTextfield showError];
        return;
    }
    if ([Helper validateEmail:_emailTextfield.text]) {
        NSLog(@"Proceed to next!!");
        if ([Helper isConnected])
            [self registerMe];
        else
            [SVProgressHUD showErrorWithStatus:[MCLocalization stringForKey:@"no_internet_connectivity"]];
    }else {
        [_emailTextfield showError];
    }
}

#pragma mark UITextfield

- (void)textFieldDidEndEditing:(JJMaterialTextfield *)textField {
    if (textField.text.length == 0) {
        [textField showError];
    }
    else {
        [textField hideError];
        if (_firstNameTextfield.text.length > 0 && _lastNameTextfield.text.length > 0){
            if (_displayNameTextfield.text.length == 0)
                _displayNameTextfield.text = [NSString stringWithFormat:@"%@.%@", _firstNameTextfield.text, _lastNameTextfield.text];
        }
    }
}

- (BOOL)textFieldShouldReturn:(JJMaterialTextfield *)textField {
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    (!view) ? [textField resignFirstResponder] : [view becomeFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(JJMaterialTextfield *)textField {
    if(textField.tag == kDobTextfieldTag) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updateTextField:)
             forControlEvents:UIControlEventValueChanged];
        [_dobTextfield setInputView:datePicker];
    }
}

#pragma mark DateTimePicker

- (void)updateTextField:(UIDatePicker *)sender {
    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
    [objDateFormatter setDateFormat:@"MM/dd/yyyy"];
    _dobTextfield.text = [objDateFormatter stringFromDate:sender.date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [datePicker removeFromSuperview];
}

#pragma mark Registration API

- (void)registerMe {
    [_firstNameTextfield hideError];
    [_lastNameTextfield hideError];
    [_emailTextfield hideError];
    [_passwordTextfield hideError];
    [_displayNameTextfield hideError];
    [_dobTextfield hideError];
    
    [SVProgressHUD show];
    AJOauth2ApiClient *client = [AJOauth2ApiClient sharedClient];
    [client registerMe:_displayNameTextfield.text password:_passwordTextfield.text email:_emailTextfield.text firstName:_firstNameTextfield.text lastName:_lastNameTextfield.text dob:_dobTextfield.text success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![Helper checkResponseObject:responseObject])
            return ;
        
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        NSInteger statusCode = [jsonDict[@"code"] integerValue];
        if (statusCode == SUCCESS_CODE) {
            AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:jsonDict[@"oauth"][@"access_token"] tokenType:jsonDict[@"oauth"][@"token_type"]];
            [credential setRefreshToken:jsonDict[@"oauth"][@"refresh_token"]];
            
            // Store credential
            [AFOAuthCredential storeCredential:credential withIdentifier:client.serviceProviderIdentifier];
            NSLog(@"%@", [client retrieveCredential]);
            
            // User info stored in NSUserDefaults i.e to access basic info on left drawer
            NSDictionary *userInfoDict = @{@"username": _displayNameTextfield.text, @"email": _emailTextfield.text};
            [Helper saveUserInfoInDefaults:userInfoDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:SVProgressHUDWillDisappearNotification object:nil];
                [SVProgressHUD showSuccessWithStatus:jsonDict[@"show_message"]];
            });
        } else {
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if (![Helper isWebUrlValid:error])
            return;

        id errorObject = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        
        if(![Helper checkResponseObject:errorObject])
            return;
        
        NSDictionary *errorJsonDict = (NSDictionary *)errorObject;
        NSInteger statusCode = [errorJsonDict[@"code"] integerValue];
        if (statusCode == BAD_REQUEST_CODE) {
            [SVProgressHUD showErrorWithStatus:errorJsonDict[@"show_message"]];
            return;
        }else if (statusCode == INTERNAL_SERVER_ERROR_CODE) {
            NSLog(@"Error Code: %zd; ErrorDescription: %@", statusCode, errorJsonDict[@"error_description"]);
        }
        [SVProgressHUD showErrorWithStatus:[MCLocalization stringForKey:@"error_message"]];
    }];
}

#pragma mark SVProgressHUD

- (void)handleNotification:(NSNotification *)notification {
    NSLog(@"Notification received: %@", notification.name);
    NSLog(@"Status user info key: %@", notification.userInfo[SVProgressHUDStatusUserInfoKey]);
    
    if ([notification.name isEqualToString:SVProgressHUDWillDisappearNotification]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDWillDisappearNotification object:nil];
    }
}

@end
