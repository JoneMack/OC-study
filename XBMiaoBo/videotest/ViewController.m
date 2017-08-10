//
//  ViewController.m
//  videotest
//
//  Created by xubojoy on 16/9/9.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "ViewController.h"
#import "LiveListStore.h"
#import "XLWatchLiveViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"玩玩儿";
    self.view.backgroundColor = [UIColor whiteColor];
    self.liveListModelArray = [NSMutableArray new];
    [self initTableView];
    [self loadData];
}

- (void)loadData{

    [LiveListStore getAllLiveList:^(NSArray *listArray, NSError *error) {
        NSLog(@"=+=================%@",listArray);
        if (listArray.count > 0) {
            for (NSDictionary *liveDict in listArray) {
                self.liveListModel = [[LiveListModel alloc] initWithDictionary:liveDict error:nil];
                if (self.liveListModel != nil) {
                    [self.liveListModelArray addObject:self.liveListModel];
                }
            }
        }
        [self.tableView reloadData];
    } pageNo:1];
}

//初始化tableview
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width,screen_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.liveListModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *discoverIndexCellIdentifier = @"LiveListCell";
    UINib *nib = [UINib nibWithNibName:@"LiveListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:discoverIndexCellIdentifier];
    LiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:discoverIndexCellIdentifier forIndexPath:indexPath];
    if (self.liveListModelArray.count > 0) {
        self.liveListModel = self.liveListModelArray[indexPath.row];
        [cell renderLiveListCellWithLiveListModel:self.liveListModel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 420;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.liveListModelArray.count > 0) {
        self.liveListModel = self.liveListModelArray[indexPath.row];
        XLWatchLiveViewController *watch = [[XLWatchLiveViewController alloc] init];
        
        watch.hotModel = self.liveListModel;
        watch.allModels = self.liveListModelArray;
        LiveListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        watch.image = cell.bigImageView.image;
//        [self presentViewController:watch animated:YES completion:nil];
        [self.navigationController pushViewController:watch animated:NO];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
