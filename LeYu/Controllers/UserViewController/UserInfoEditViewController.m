//
//  UserInfoEditViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/19.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "UserInfoEditViewController.h"
#import <MBProgressHUD.h>

@interface UserInfoEditViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UITextField *nickname;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *desc;

@property (nonatomic, assign) BOOL edited;

@property (nonatomic, assign) BOOL avatarEdited;

@end

@implementation UserInfoEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edited = NO;
    self.avatarEdited = NO;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    self.edited = YES;
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
        self.avatar.image = image;
        self.avatarEdited = YES;
        self.edited = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark methods

- (IBAction)done:(id)sender
{
    if (self.edited) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        LYUser *user = [LYUser currentUser];
        user.username = self.nickname.text;
        user.mobilePhoneNumber = self.phone.text;
        user.signature = self.desc.text;
        if (self.maleButton.selected) {
            user.sex = @"男";
        } else {
            user.sex = @"女";
        }
        if (self.avatarEdited) {
            user.thumbnail = [AVFile fileWithData:UIImageJPEGRepresentation(self.avatar.image, 0.1)];
        }
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (succeeded) {
                [self.userVC updateAvatar];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                Log(@"%@", error);
            }
        }];
    }
}

- (IBAction)genderSelected:(id)sender
{
    if (sender == self.maleButton) {
        [self changTomale];
    } else if (sender == self.femaleButton) {
        [self changTofemale];
    }
    self.edited = YES;
}

- (void)changTomale
{
    self.maleButton.selected = YES;
    self.femaleButton.selected = NO;
}

- (void)changTofemale
{
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
