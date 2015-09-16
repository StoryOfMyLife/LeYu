//
//  UserFavoriteShopsViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 7/24/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UserFavoriteShopsViewController.h"
#import "FavoriteShopCell.h"
#import "ShopFollower.h"
#import "ShopViewController.h"

@interface UserFavoriteShopsViewController()<UITableViewDataSource,UITableViewDelegate>;

@property (nonatomic,strong) LYUser *user;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *favoriteShops;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation UserFavoriteShopsViewController

-(instancetype) initWithUser:(LYUser *)user {
    if (self = [self init]) {
        self.user =user;
        self.favoriteShops = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
     self.title = @"个人信息";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    WeakSelf weakSelf =self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicator];
    

    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
    

}


-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:FavoriteShopCell.class forCellReuseIdentifier:NSStringFromClass(FavoriteShopCell.class)];
    [self.indicator startAnimating];
    AVQuery *query = [ShopFollower query];
    [query whereKey:@"user" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *shopObjectIds = [[NSMutableArray alloc] init];
            for (ShopFollower* follower in objects) {
                [shopObjectIds addObject:follower.shop.objectId];
            }
            AVQuery* shopQuery = [Shop query];
            [shopQuery whereKey:@"objectId" containedIn:shopObjectIds];
            [shopQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [self.favoriteShops addObjectsFromArray:objects];
                    [self.tableView reloadData];
                    [self.indicator stopAnimating];
                }else {
                    [self.indicator stopAnimating];
                }
            }];
            
        }else {
            [self.indicator stopAnimating];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.favoriteShops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteShopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FavoriteShopCell.class) forIndexPath:indexPath];
    [cell configureCell:[self.favoriteShops objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Shop *shop = [self.favoriteShops objectAtIndex:indexPath.row];
    ShopViewController *shopDetailViewController = [[ShopViewController alloc] initWithShop:shop];
    [self.navigationController pushViewController:shopDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260.0f;
}



@end
