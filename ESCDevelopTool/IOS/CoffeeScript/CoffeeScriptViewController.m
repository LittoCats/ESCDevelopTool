//
//  CoffeeScriptViewController.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "CoffeeScriptViewController.h"
#import "CoffeeScriptView.h"
#import "CoffeeScript.h"

@interface CoffeeScriptViewController ()

@property (nonatomic, strong) CoffeeScriptView *view;

@end

@implementation CoffeeScriptViewController

- (void)loadView
{
    self.view = [[CoffeeScriptView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CoffeeScript";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationItemSelected:(NSInteger)serializedID
{
    switch (serializedID) {
        case 101:{
            NSString *coffee = self.view.coffee;
            NSString *js = CoffeeScript.compile(coffee);
            [self.view output:js];
        }break;
        default:
            break;
    }
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
