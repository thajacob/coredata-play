//
//  main.m
//  Core Data
//
//  Created by jakub skrzypczynski on 07/10/2016.
//  Copyright © 2016 test project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        
        //find the momd
        
        NSURL* modelURL = [[NSBundle mainBundle]URLForResource:@"MyModel"withExtension:@"momd"];
        
        //Make the MOM
        
        NSManagedObjectModel *mom = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        
        //Create the PSC
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        
        //Link the MOC to the PCS
        
        NSManagedObjectContext *managedObjectContext =[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [managedObjectContext setPersistentStoreCoordinator:psc];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"MyModel.sqlite"];
        
        NSError *error = nil;
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            NSLog(@"Error initialising PSC: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
            
        }
        NSLog(@"persistent store initialised");
        
        NSArray *computersToAdd =
        @[
          @[@1,@"MacBookAir13.png",@"MacBook Air 13 inch",@849.00,@"Apple",@"Laptop"],
          @[@2,@"macBookAir11.png",@"macBook Air 11 inch",@749.00, @"Apple",@"Laptop"],
          @[@3,@"MacBookPro13.png",@"MacBook Pro",@999.00,@"Apple",@"Laptop"],
          @[@4,@"MacBookProRetina13.png",@"MacBook Pro retina 13 inch",@1099.00,@"Apple",@"Laptop"],
          @[@5,@"MacBookProretina15.png",@"MacBook Pro Retina 15 inch",@1699.00,@"Apple",@"laptop"],
          @[@6,@"Macmini.png",@"mac mini",@499.00,@"apple",@"Desktop"],
          @[@7,@"MacminiwithOSXServer.png",@"mac mini with osx server",@849.00,@"Apple", @"Desktop"],
          @[@8,@"imac215inch.png",@"imac 27 inch",@1149.00,@"apple",@"Desktop"]
          ];
        
        for (NSArray *computers in computersToAdd)
            
        {
            NSManagedObject *newComputer = [NSEntityDescription insertNewObjectForEntityForName:@"Computers" inManagedObjectContext: managedObjectContext];
        
        
        [newComputer setValue:computers[0] forKey:@"id"];
        [newComputer setValue:computers[1] forKey:@"image"];
        [newComputer setValue:computers[2] forKey:@"name"];
        [newComputer setValue:computers[3] forKey:@"price"];
        [newComputer setValue:computers[4] forKey:@"supplier"];
        
        
        NSLog(@"Creating %@ %@ %@ %@ %@...", computers[0], computers[1],computers[2],computers[3],computers[4]);
        
        }
        
        error = nil;
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] :@"Unknows Error");
            exit(1);
            
        }
        else
            
        {
            NSLog(@"managedObjectContext succesfully saved!");
            
        }
        
        
        NSFetchRequest *request =[[NSFetchRequest alloc]init];
        [request setEntity:[NSEntityDescription entityForName:@"Computers" inManagedObjectContext:managedObjectContext]];
        
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES]]];
                                     
        
        error = nil;
        NSArray *computers = [managedObjectContext executeFetchRequest:request error:&error];
        
        if (error)
        {
            NSLog(@"Error fetching the computers entities: %@", error);
            
        }
        else
            
        {
            for (NSManagedObject *macs in computers)
                
            {
                NSLog(@"found: %@ %@ %@ %@ %@", [macs valueForKey:@"id"],
                      [macs valueForKey:@"image"], [macs valueForKey:@"name"], [macs valueForKey:@"price"], [macs valueForKey:@"supplier"]);
                
                
            }
        }
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"price > 1000"];

    [request setPredicate:predicate];

    error = nil;
    NSArray *computersWithPredicate = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {

        NSLog(@"Error fetching the computers entities: %@", error);
    }
    else
    {
        for(NSManagedObject *macs in computersWithPredicate)
        {

            NSLog(@"Found with predicate: %@ %@ %@ %@ %@",
                  [macs valueForKey:@"id"], [macs valueForKey:@"image"], [macs valueForKey:@"name"], [macs valueForKey:@"price"],[macs valueForKey:@"supplier"]);
        }
        //
    }
     
    for  (NSManagedObject *macs in computers)
    {
        [managedObjectContext deleteObject:macs];
        
    }
        
        NSLog(@"about to delegate the following objects from POS %@",[managedObjectContext deletedObjects]);
              
        
        error = nil;
        
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Uknowns Error");
            exit (1);
        }
        else
        {
            NSLog(@"managedObjectContext successfully saved (again)!");
            
        }
        
            
            
        }
        return 0;
    }


        

//    if (error)
//    {
//        
//        NSLog(@"Error fetching the computers entities: %@, error);
//              }
//              
//              else
//              {
//                  for(NSManagedObject *macs in computersWithPredicate)
//                  {
//                      
//                      NSLog(@"Found with predicate: %@ %@ %@ %@ @%",
//                            [macs valueForKey:@"id"], [macs valueForKey:@"image"], [macs valueForKey:@"name"], [macs valueForKey];[@"price" ],
//                            [macs valueForKey:@"supplier"]);
//                  }
//              }
//              
//        
//    
//    
//    
//              }
//    return 0;
//              
//}
