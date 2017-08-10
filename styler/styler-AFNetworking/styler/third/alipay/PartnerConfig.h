//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088901629529722"
//收款支付宝账号
#define SellerID  @"caiwu@meilizhuanjia.cn"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"yyp69bkxqzi4nhrialt6jn3rg6oum75f"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOG1ldDMVVfu3/S5A+N8IbHeQ5i4r9yjUE21R7WUo+WBtYlfNV67sceH80qEt8mkDoo1aaSJeUqyw2RvmFsBCcJ8tUfUAXvZzx7boFrdZlOD6lgps1vkULJjnR4rvkNDV88nb9duOZfh9A1KeAziK9KW13Ez2YhhfS23bOgzTiLPAgMBAAECgYBUf52ZsJWWuOgA/y7UgElBBJu71hCIgl9y6BXzhbUiG8AxsIITeCMjNuM/F5aSl6eV2E83ePv+mhQKSrj4ANh80guh7qMG4MOb+1/+Ap2pOg4b6zeUn+bO26VWLIktr1vBvbRRjzKriWbE8A1BarGn0Gkl5565ZI9zlluBmv0DiQJBAPiV/EIyhRJWp7c9c6y6EPSxBi/zQntkhcN7czmvV2BwKKx1FwMZOy/nOkFfjg6L2Ihphy835Nu+PnEh4qTevG0CQQDocO5+rDvoN9GLCXqjW3MiDyKyBXd1IudOplls6nO40dTlksilQz731HoQ6KZ6Btn4jKulRzzhJmMQQQa4R56rAkBDGHCLCYnDZmJEYjDLqTkUYoeR/62tEnfMSJDUPBBwdjV0PvJkIrZH+rhNltYH9RUP1LPpOcPqz9GYxZWf/IKNAkEAoAuqW7Qx55oPgQF83OAJ7WiohhU3hIMM612k81aXaampQo2H9CrSP4igp+XZQupWyUnqofnkFE7/JODxRI+j0wJAFXChsNyfBQXycWQLRmch01l+VtL6+T9WC5oVaPyZlaBjh867SIAWr1BjcdVRrNDxt7aKT5mL0411+vX0OwqISw=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
