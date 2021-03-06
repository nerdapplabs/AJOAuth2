//
//  ForgotPasswordViewController.h
//  AJOAuth2
//
//  Created by Ashish Jabble on 20/01/17.
//  Copyright © 2017 Ashish Jabble. All rights reserved.
//

#import <UIKit/UIKit.h>
@import JJMaterialTextField;

@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JJMaterialTextfield *emailTextfield;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;

- (IBAction)reset:(id)sender;
@end
