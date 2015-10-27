//
//  MusicListController.m
//  HMAudioPlayer
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "MusicListController.h"
#import "MJExtension.h"
#import "HMMusic.h"
#import "UIImage+NJ.h"
#import "Colours.h"
#import "MusicPlayController.h"

@interface MusicListController ()

@property (nonatomic, strong) NSArray *musicListArray;

@property (nonatomic, strong) MusicPlayController *musicPlayCon;
@end

@implementation MusicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - 解析数据
-(NSArray *)musicListArray {
    if (_musicListArray == nil) {
        _musicListArray = [HMMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musicListArray;
}

-(MusicPlayController *)musicPlayCon {
    if (_musicPlayCon == nil) {
        _musicPlayCon = [[MusicPlayController  alloc]init];
    }
    return _musicPlayCon;
}

#pragma mark - TableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"music";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    HMMusic *model = self.musicListArray[indexPath.row];
    cell.textLabel.text = model.name;
//    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:model.singerIcon ofType:nil]];
    cell.imageView.image = [UIImage circleImageWithName:model.singerIcon borderWidth:4.0 borderColor:[UIColor skyBlueColor]];
    cell.detailTextLabel.text = model.singer;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self performSegueWithIdentifier:@"listToPlay" sender:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
