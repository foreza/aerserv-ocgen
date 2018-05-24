//
//  VC-Singleton.swift
//  OCGEN
//
//  Created by Jason C on 5/21/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import Foundation

class VCInstance {
    
    // We only want once intance of this ever, by defintion of the Singleton
    static let sharedInstance = VCInstance()
    
    // Initialize variables. Control amounts, initial amounts, and currency name here
    var currencyName = "Energy"
    var amount : Int = 0
    var initialAmount : Int = 10000
    var spendAmount : Int = 5
    var saveFile = "db.txt"
    
    
    // ** [INIT] **
    // Initialize the singleton class here.
    
    private init() {
        
        // Verify that only one instance is ever created
        print("[DEBUG] VC - Singleton instance VCInstance created" )
        
        // If a local save instance does not exist, create one
        if !(checkLocalSave()) {
            initLocalSave()
        }
        // Otherwise, read from the local save and set it to the correct amount
        setAmount(toSet: readValueFromLocalSave())
    }
    
    
    // ** [ACCESSORS] **
    // Methods that get / return and do not change the data
    
    // Get the currency name
    func getCurrencyName() -> String {
        return currencyName
    }
    
    // Get the spend amount
    func getSpendAmount() -> Int {
        return spendAmount
    }
    
    // Get the current amount
    func getAmount() -> Int {
        return amount
    }
    
    // Check if the amount if valid for this 'transaction'
    func checkAmountIsValid(toCheck: Int) -> Bool {
        if (toCheck > amount){
            return false
        }
        return true
    }
    
    
    // ** [MUTATORS] **
    // Methods that increment, decrement, or set variables
    
    // Method to increment the amount
    func incrementAmount(toAdd: Int) {
        amount += toAdd
        print("[DEBUG] VC incrementAmount - VC new amount is \(amount)")
        saveLocalAmount()
    }
    
    // Method to decrement the amount
    func decrementAmount(toTake: Int) {
        amount -= toTake
        print("[DEBUG] VC decrementAmount - VC new amount is \(amount)")
        saveLocalAmount()
    }
    
    // Class method to set the amount in the application
    func setAmount(toSet: Int) {
        amount = toSet
        print("[DEBUG] VC setAmount - VC new amount is \(amount)")
        saveLocalAmount()
    }
    
    

    
    // ** [FILE READ/WRITE/MANIPULATION] **
    // READ / WRITE METHODS CALLED ONLY BY THIS SINGLETON CLASS
    
    // Class method to save the amount in the application - called very often!
    private func saveLocalAmount() {
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent(saveFile)
                
                //  HAve the text to be the value of VC at present; convert to String
                let text = String(amount)
                
                // writing to disk
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print("[DEBUG] saving was successful at \(fileURL)")
                print("[DEBUG] VC saveLocalAmount - VC amount is \(text)")
                
            }
        } catch {
            print("error:", error)
        }
    }
    
    // Checks the local storage to see if we do have the local energy amount stored
    private func checkLocalSave() -> Bool {
        do {
            // Get the documents folder url
            let fileManager = FileManager.default
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                // Create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent(saveFile)
                
                // If the file exists, return true
                if fileManager.fileExists(atPath: fileURL.path) {
                    print("[DEBUG] VC checkLocalSave - File exists")
                    return true
                    
                } else {
                    print("[DEBUG] VC checkLocalSave - File not found")
                    return false
                }
            }
        } catch {
            print("[DEBUG] VC checkLocalSave - error:", error)
        }
        
       return false
      
    }
    
    // Sets up a db.txt file if one does not yet exist already
    private func initLocalSave() {
        
        do {
            
            // Get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                // Create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent(saveFile)
               
                // Initialize the text to be the value of VC, and convert for writing purposes
                let text = String(initialAmount)
                
                // Write to the disk
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print("[DEBUG] VC initLocalSave - creation was successful at \(fileURL)")
            }
        } catch {
            print("error:", error)
        }
    }
    
    // Reads the value from the local saved file and returns it to the calling function
    func readValueFromLocalSave() -> Int {
            
            do {
                // Get the documents folder url
                if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    
                    // Create the destination url for the text file to be accessed
                    let fileURL = documentDirectory.appendingPathComponent(saveFile)
                    let savedValue = try String(contentsOf: fileURL)
                    print("[DEBUG] VC readValueFromLocalSave - \(type(of:savedValue)) value from \(fileURL):  \(savedValue)" )
                    let retValue : Int = Int(savedValue)!
                    return retValue
                }
            } catch {
                print("[DEBUG] error:", error)
            }
        
        return 0;
    
    }
      
    
}
