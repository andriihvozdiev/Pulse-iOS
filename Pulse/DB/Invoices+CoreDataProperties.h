//
//  Invoices+CoreDataProperties.h
//  
//
//  Created by dev on 3/10/19.
//
//

#import "Invoices+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Invoices (CoreDataProperties)

+ (NSFetchRequest<Invoices *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *app0Emp;
@property (nullable, nonatomic, copy) NSString *app1Emp;
@property (nullable, nonatomic, copy) NSString *app2Emp;
@property (nonatomic) BOOL approval0;
@property (nonatomic) BOOL approval1;
@property (nonatomic) BOOL approval2;
@property (nullable, nonatomic, copy) NSDate *approvalDt0;
@property (nullable, nonatomic, copy) NSDate *approvalDt1;
@property (nullable, nonatomic, copy) NSDate *approvalDt2;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *company;
@property (nonatomic) BOOL deleted;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nonatomic) BOOL downloaded;
@property (nonatomic) BOOL export;
@property (nullable, nonatomic, copy) NSString *invoiceAppID;
@property (nullable, nonatomic, copy) NSDate *invoiceDate;
@property (nonatomic) int32_t invoiceID;
@property (nullable, nonatomic, copy) NSString *lease;
@property (nonatomic) BOOL noBill;
@property (nullable, nonatomic, copy) NSDate *noBillDt;
@property (nullable, nonatomic, copy) NSString *noBillEmp;
@property (nullable, nonatomic, copy) NSString *opCompany;
@property (nonatomic) BOOL outsideBill;
@property (nullable, nonatomic, copy) NSDate *outsideBillDt;
@property (nullable, nonatomic, copy) NSString *outsideBillEmp;
@property (nullable, nonatomic, copy) NSString *ownCompany;
@property (nullable, nonatomic, copy) NSString *rodComments;
@property (nullable, nonatomic, copy) NSString *route;
@property (nullable, nonatomic, copy) NSString *tubingComments;
@property (nonatomic) int32_t userid;
@property (nullable, nonatomic, copy) NSString *wellNumber;
@property (nullable, nonatomic, copy) NSString *totalCost;
@property (nullable, nonatomic, copy) NSString *dailyCost;
@property (nullable, nonatomic, copy) NSArray *invoiceImages;

@end

NS_ASSUME_NONNULL_END
