//
//  UserInfoDetailViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 7/23/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UserInfoDetailViewController.h"
#import "ColorFactory.h"
#import "UserInfoDetailCell.h"
#import "UserNickNameEditViewController.h"
#import "UserInfoDetailEditViewController.h"
#import "UserPersonalizedDiscriptionViewController.h"
#import "GenderSelectViewController.h"
#import <MBProgressHUD.h>

@interface UserInfoDetailViewController() <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) LYUser *user;
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UIImage *image;

@end

@implementation UserInfoDetailViewController


-(instancetype) initWithUser:(LYUser *)user {
    if (self = [self init]) {
        self.user =user;
    }
    return self;
}


-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人信息";
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate =  self;
    self.tableview.dataSource =  self;
    [self.view addSubview:self.tableview];
    UIView *footerView = [[UIView alloc] init];
    self.tableview.backgroundColor = [ColorFactory dyLightGray];
    self.tableview.tableFooterView = footerView;
    
    WeakSelf weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (weakSelf.view);
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerClass:UserInfoDetailCell.class forCellReuseIdentifier:NSStringFromClass(UserInfoDetailCell.class)];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return UserInfoDetailSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == UserSignature) {
        return 1;
    }
    return UserInfoDetailSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [ColorFactory dyLightGray];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoDetailCell *userInfoDetailCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UserInfoDetailCell.class) forIndexPath:indexPath];
    userInfoDetailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case UserInfoBasic: {
            switch (indexPath.row) {
                case UserThumbnail: {
                  userInfoDetailCell.textLabel.text = @"用户头像";
                  [userInfoDetailCell configureImage:self.user.thumbnail];
                   return userInfoDetailCell;
                }
                case UserNickName: {
                  userInfoDetailCell.textLabel.text = @"昵称";
                    [userInfoDetailCell configureText:self.user.username];
                  return userInfoDetailCell;
                }
                case UserSex: {
                  userInfoDetailCell.textLabel.text = @"性别";
                    [userInfoDetailCell configureText:self.user.sex];
                    return userInfoDetailCell;
                }
            }
            
            break;
        }
        case UserPersonalized: {
            switch (indexPath.row) {
                case UserPersonalizedExplaination: {
                    userInfoDetailCell.textLabel.text = @"个性说明";
                    [userInfoDetailCell configureText:self.user.personalDescription];
                    return userInfoDetailCell;
    
                }
                    
                case UserPersonalizedBackground: {
                    userInfoDetailCell.textLabel.text = @"选择背景";
                    return userInfoDetailCell;
                }
                    
                case UserTelephoneNumber: {
                    userInfoDetailCell.textLabel.text =@"手机号";
                    [userInfoDetailCell configureText:self.user.mobilePhoneNumber];
                    return userInfoDetailCell;
                }
            }
        
        
            break;
        
        };
            
        case UserSignature: {
           userInfoDetailCell.textLabel.text = @"个性签名";
            [userInfoDetailCell configureText:self.user.signature];
            return userInfoDetailCell;
        
        }
        
    }
    return nil;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoDetailEditViewController *controller;
    
    switch (indexPath.section) {
        case UserInfoBasic: {
            switch (indexPath.row) {
                case UserThumbnail: {
                    [self uploadPhoto];
                    break;
                   
                }
                case UserNickName: {
                    controller = [[UserNickNameEditViewController alloc] init];
                    break;
                   
              
                }
                case UserSex: {
                    controller = [[GenderSelectViewController alloc] init];
                    break;
              
                }
            }
            
            break;
        }
        case UserPersonalized: {
            switch (indexPath.row) {
                case UserPersonalizedExplaination: {
                    controller = [[UserPersonalizedDiscriptionViewController alloc] init];
                
                    
                }
                    
                case UserPersonalizedBackground: {
                   
                }
                    
                case UserTelephoneNumber: {
                   
                }
            }
            
            
            break;
            
        };
            
        case UserSignature: {
            
            
        }
            
    }
    
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }

}


-(void) uploadPhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }else {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:
                                     @"拍照",
                                     @"照片里面取",
                                     nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [popupQuery showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex == 1) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
}


-(void)showImagePicker:(int) sourceType {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info[UIImagePickerControllerOriginalImage]) {
        UIImage* image = (UIImage *)info[UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        LYUser *user = [LYUser currentUser];
        user.thumbnail = [AVFile fileWithData:data];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.tableview reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
