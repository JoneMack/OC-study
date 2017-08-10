//
//  AccountSessionSpringBoard.m
//  styler
//
//  Created by System Administrator on 13-6-27.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "AccountSessionSpringBoard.h"
#import "FeedbackController.h"
#import "StylistListController.h"
#import "UserCenterController.h"
#import "MyOrderController.h"
#import "StylistEvaluationsController.h"
#import "WorkListController.h"
#import "StylistWorkStore.h"
#import "StylistProfileController.h"
#import "ContentNavController.h"
#import "UserStore.h"
#import "AppDelegate.h"
#import "StylistView.h"
#import "WorkDetailController.h"
#import "WebContainerController.h"
#import "ShareEnableWebController.h"
#import "ChatViewController.h"

@implementation AccountSessionSpringBoard

+(void) jumpToAccountSessionFrom:(UIViewController *)viewController accountSessionFrom:(int)accountSessionFrom{
    NSNotification *notification = [NSNotification notificationWithName:@"sessionUpdate" object:nil];
    NSNotification *notification2 = [NSNotification notificationWithName:notification_name_user_login object:nil userInfo:[NSDictionary dictionaryWithObject:[[NSNumber alloc] initWithInt:accountSessionFrom] forKey:notification_name_pn_account_session_from]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    if(accountSessionFrom == account_session_from_inx){
        [viewController.navigationController popToRootViewControllerAnimated:YES];
    }else if(accountSessionFrom == account_session_from_feedback){
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        [controllers addObject:viewController.navigationController.viewControllers[0]];
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:@"support"];
        chatVC.title = page_name_feedback;
        [controllers addObject:chatVC];
        [viewController.navigationController setViewControllers:controllers animated:YES];
    }else if(accountSessionFrom == account_session_from_my_order){
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        [controllers addObject:viewController.navigationController.viewControllers[0]];
        [controllers addObject:[[MyOrderController alloc] init]];
        [viewController.navigationController setViewControllers:controllers animated:YES];
    }else if(accountSessionFrom == account_session_from_my_stylist){
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        [controllers addObject:viewController.navigationController.viewControllers[0]];
        
        AppStatus *as = [AppStatus sharedInstance];
        NSString *url = [UserStore getUriForUserFavStylists:as.user.idStr];
        StylistListController *slc = [[StylistListController alloc] initWithRequestUrl:url title:@"我收藏的发型师" type:my_fav_styler_type];
        
        [controllers addObject:slc];
        [viewController.navigationController setViewControllers:controllers animated:YES];
    }else if(accountSessionFrom == account_session_from_my_favorite){
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        [controllers addObject:viewController.navigationController.viewControllers[0]];
        NSString *url = [StylistWorkStore getUrlForFavWorks:[AppStatus sharedInstance].user.idStr];
        [controllers addObject:[[WorkListController alloc] initWithRequestURL:url title:@"我收藏的作品" type:my_fav_work]];
        [viewController.navigationController setViewControllers:controllers animated:YES];
    }else if(accountSessionFrom == account_session_from_add_favorite_works){
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[WorkDetailController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"add_stylist_work" object:nil];
                break;
            }
        }
    }else if(accountSessionFrom == account_session_from_add_favorite_stylist){
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[StylistProfileController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }else if(accountSessionFrom == account_session_from_user_home){
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[UserCenterController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                //[viewController.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    }else if (accountSessionFrom == account_session_from_stylist_order){
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[StylistProfileController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }else if (accountSessionFrom == account_session_from_stylist_profile_set_evaluation)
    {
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[StylistProfileController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }else if (accountSessionFrom == account_session_from_evaluations_set_evaluation)
    {
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[StylistEvaluationsController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }else if (accountSessionFrom == account_session_from_buy_card){
        NSArray *controllers = viewController.navigationController.viewControllers;
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass:[ShareEnableWebController class]]){
                [viewController.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }
}

@end
