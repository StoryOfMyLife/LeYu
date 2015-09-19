//
//  UserInfoEditViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/19.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "UserInfoEditViewController.h"

@interface UserInfoEditViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UITextField *nickname;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *desc;

@end

@implementation UserInfoEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.avatar.layer.cornerRadius = 15;
    
    NSString *sex = [LYUser currentUser].sex;
    if ([sex isEqualToString:@"男"]) {
        [self changTomale];
    } else {
        [self changTofemale];
    }
    
    [[LYUser currentUser].thumbnail getThumbnail:YES width:80 height:80 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            self.avatar.image = image;
        }
    }];
    
    self.nickname.text = [LYUser currentUser].username;
    self.phone.text = [LYUser currentUser].mobilePhoneNumber;
    self.desc.text = [LYUser currentUser].signature;
    
    self.nickname.delegate = self;
    self.phone.delegate = self;
    self.desc.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[LYUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
        } else {
            Log(@"%@", error);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.isShopUser) {
        self.title = @"店家资料";
    } else {
        self.title = @"用户资料";
    }
}

#pragma mark -
#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self changeAvatar];
    }
}

#pragma mark -
#pragma mark TextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    LYUser *user = [LYUser currentUser];
    if (textField == self.nickname) {
        user.username = textField.text;
    } else if (textField == self.phone) {
        user.mobilePhoneNumber = textField.text;
    } else if (textField == self.desc) {
        user.signature = textField.text;
    }
}

#pragma mark -
#pragma mark actionsheet delelgate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    } else if(buttonIndex == 1) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark -
#pragma mark image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (info[UIImagePickerControllerEditedImage]) {
        UIImage* image = (UIImage *)info[UIImagePickerControllerEditedImage];
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        [LYUser currentUser].thumbnail = [AVFile fileWithData:data];
        self.avatar.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark methods

- (IBAction)genderSelected:(id)sender
{
    if (sender == self.maleButton) {
        [self changTomale];
    } else if (sender == self.femaleButton) {
        [self changTofemale];
    }
}

- (void)changTomale
{
    [LYUser currentUser].sex = @"男";
    self.maleButton.selected = YES;
    self.femaleButton.selected = NO;
}

- (void)changTofemale
{
    [LYUser currentUser].sex = @"女";
    self.maleButton.selected = NO;
    self.femaleButton.selected = YES;
}


- (void)changeAvatar
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:
                                     @"拍照",
                                     @"从相册选择",
                                     nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

@end
