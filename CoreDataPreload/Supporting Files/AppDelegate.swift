//
//  AppDelegate.swift
//  CoreDataPreload
//
//  Created by Adnann Muratovic on 14.09.21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // To locate SQLite database and copy 3 file in your project
        let urls = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
        print(urls[0])
        
        preloadData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        
        // MARK -Load the existing database ------------------------------------------------->
        
        /*
         let directoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         let applicationDocumentDirectory = directoryUrls[0]
         let storeUrl = applicationDocumentDirectory.appendingPathComponent("CoreDataPreloadDemo.sqlite")
         */
        
        
//        if !FileManager.default.fileExists(atPath: storeUrl.path) {
//            let sourceSqliteURLs = [Bundle.main.url(forResource: "CoreDataPreload", withExtension: "sqlite")!, Bundle.main.url(forResource: "CoreDataPreload", withExtension: "sqlite-wal")!, Bundle.main.url(forResource: "CoreDataPreload", withExtension: "sqlite-shm")!]
//            let destSqliteURLs = [applicationDocumentDirectory.appendingPathComponent("CoreDataPreload.sqlite"), applicationDocumentDirectory.appendingPathComponent("CoreDataPreload.sqlite-wal"), applicationDocumentDirectory.appendingPathComponent("CoreDataPreload.sqlite-shm")]
//
//            for index in 0..<sourceSqliteURLs.count {
//                do {
//                    try FileManager.default.copyItem(at: sourceSqliteURLs[index], to: destSqliteURLs[index])
//                } catch {
//                    print(error)
//                }
//            }
//        }
        // ----------------------------------------------------------------------------------------------->
        
        
        /*
         ----------------------------------------->
         let description = NSPersistantStoreDescription()
         description.url = storeURL
         */
        
        let container = NSPersistentContainer(name: "CoreDataPreload")
        // container.persistantStoreDescription = [descriptions]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func parseCSV(contentsOfURL: URL, encoding: String.Encoding) -> [(name: String, detail: String, price: String)]? {
        
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(name: String, detail: String, price: String)]?
        
        do {
            let context = try String(contentsOf: contentsOfURL, encoding: encoding)
            items = []
            let lines: [String] = context.components(separatedBy: .newlines)
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we user NSScanner to perform parsing
                    if line.range(of: "\"") != nil {
                        var textToScan: String = line
                        var value: String?
                        var texScenner:Scanner = Scanner(string: textToScan)
                        
                        while texScenner.string != "" {
                            if (texScenner.string as NSString).substring(to: 1) == "\"" {
                                texScenner.currentIndex = texScenner.string.index(after: texScenner.currentIndex)
                                value = texScenner.scanUpToString("\"")
                                texScenner.currentIndex = texScenner.string.index(after: texScenner.currentIndex)
                            } else {
                                value = texScenner.scanUpToString(delimiter)
                            }
                            
                            // Store the value into the values array
                            if let value = value {
                                values.append(value)
                            }
                            
                            // Retrive the value into the values array
                            if !texScenner.isAtEnd {
                                let fromIndex = texScenner.string.index(after: texScenner.currentIndex)
                                textToScan = String(texScenner.string.suffix(from: fromIndex))
                            } else {
                                textToScan = ""
                            }
                            
                            texScenner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using delimiter
                        
                    } else {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into tuple and add it to the items array
                    let item = (name: values[0], detail: values[1], price: values[2])
                    items?.append(item)
                    
                    print("\(item.name), \(item.detail), \(item.price)")
                }
                
            }
        }
        catch {
            print(error)
        }
        
        return items
    }
    
    // MARK: - PreloadData
    func preloadData() {
        // load file from google drive - remote url
        
//        guard let removeURL = URL(string: "https://drive.google.com/uc?export=download&id=0ByZhaKOAvtNGelJOMEdhRFo2c28") else {
//            return
//        }
        
        // Load the data file. For any reason it can't be loaded,we just return
        guard let contentsOfURL = Bundle.main.url(forResource: "menudata", withExtension: "csv") else {
            return
        }
        
        // Remove all menu items before preloading
        removeData()
        
        // Parse the CSV file and import data
        if let items = parseCSV(contentsOfURL: contentsOfURL, encoding: String.Encoding.utf8) {
            let context = persistentContainer.viewContext
            
            for item in items {
                let menuItem = MenuItem(context: context)
                menuItem.name = item.name
                menuItem.detail = item.detail
                menuItem.price = Double(item.price) ?? 0.0
                
                do {
                    try context.save()
                }
                
                catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Remove Data
    
    func removeData() {
        // Remove Existing Data
        let fetchRequest = NSFetchRequest<MenuItem>(entityName: "MenuItem")
        let context = persistentContainer.viewContext
        
        do {
            let menuItems = try context.fetch(fetchRequest)
            
            for menuItem in menuItems {
                context.delete(menuItem)
            }
        }
        
        catch {
            print(error)
        }
    }
}

