//
//  Invoices+CoreDataProperties.m
//  
//
//  Created by dev on 3/10/19.
//
//

#import "Invoices+CoreDataProperties.h"

@implementation Invoices (CoreDataProperties)

+ (NSFetchRequest<Invoices *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Invoices"];
}

@dynamic app0Emp;
@dynamic app1Emp;
@dynamic app2Emp;
@dynamic approval0;
@dynamic approval1;
@dynamic approval2;
@dynamic approvalDt0;
@dynamic approvalDt1;
@dynamic approvalDt2;
@dynamic comments;
@dynamic company;
@dynamic deleted;
@dynamic deviceID;
@dynamic downloaded;
@dynamic export;
@dynamic invoiceAppID;
@dynamic invoiceDate;
@dynamic invoiceID;
@dynamic lease;
@dynamic noBill;
@dynamic noBillDt;
@dynamic noBillEmp;
@dynamic opCompany;
@dynamic outsideBill;
@dynamic outsideBillDt;
@dynamic outsideBillEmp;
@dynamic ownCompany;
@dynamic rodComments;
@dynamic route;
@dynamic tubingComments;
@dynamic userid;
@dynamic wellNumber;
@dynamic invoiceImages;
@dynamic totalCost;
@dynamic dailyCost;

@end
