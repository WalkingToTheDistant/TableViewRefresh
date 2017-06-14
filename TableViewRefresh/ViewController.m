//
//  ViewController.m
//  TableViewRefresh
//
//  Created by LHJ on 2017/6/13.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "ViewController.h"
#import "TableViewHeaderRefresh.h"
#import "TableViewFooterRefresh.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UITableView *mTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tableView];
    
    TableViewHeaderRefresh *headerRefresh = [TableViewHeaderRefresh new];
    [headerRefresh setRefreshBlock:^(void){
    
    }];
    [tableView addSubview:headerRefresh];
    
    TableViewFooterRefresh *footerRefresh = [TableViewFooterRefresh new];
    [footerRefresh setRefreshBlock:^(void){
    
    }];
    [tableView addSubview:footerRefresh];
    mTableView = tableView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [mTableView setContentSize:mTableView.bounds.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
