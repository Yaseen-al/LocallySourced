//
//  FileManagerHelper.swift
//  LocallySourced
//
//  Created by C4Q on 3/3/18.
//  Copyright © 2018 TeamLocallySourced. All rights reserved.
//

import Foundation
struct DefaultStruct:Codable {
    let name: String
    let id: Int
}
enum SavedDataPath: String{
    case farmersMarketDataPath
    case shoppingListsDataPath
}

import UIKit
class FileManagerHelper {
    private init() {}
    private let farmersMarketSavedDataPath = SavedDataPath.farmersMarketDataPath.rawValue
    private let shoppingListDataPath = SavedDataPath.shoppingListsDataPath.rawValue
    static let manager = FileManagerHelper()
    private var savedFarmersMarkets = [FarmersMarket]() {
        didSet {
            print(savedFarmersMarkets)
            saveFarmersMarket()
        }
    }
    private var savedShoppingLists = [List](){
        didSet{
            print(savedShoppingLists)
        }
    }
    //Saving Images To Disk
    func saveImage(with urlStr: String, image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        let imagePathName = urlStr.components(separatedBy: "/").last!
        let url = dataFilePath(withPathName: imagePathName)
        do {
            try imageData?.write(to: url)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func getImage(with urlStr: String) -> UIImage? {
        do {
            let imagePathName = urlStr.components(separatedBy: "/").last!
            let url = dataFilePath(withPathName: imagePathName)
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //this func checks if this farmersMarket has been saved before
    func alreadySavedFarmersMarket(_ farmersMarket: FarmersMarket) -> Bool {
        return savedFarmersMarkets.contains(where: { (market) -> Bool in
            return market.facilityname == farmersMarket.facilityname && market.facilitycity == farmersMarket.facilitycity && market.facilityzipcode == farmersMarket.facilityzipcode
        })
    }
    
    //this func checks if this shoppingList has been saved before
    func alreadySavedShoppingList(_ shoppingList: List) -> Bool {
        return savedShoppingLists.contains(where: { (list) -> Bool in
            return list.title == shoppingList.title
        })
    }
    
    // this function will add new farmersMarket to be saved
    func addNewFarmersMarket(_ farmersMarket: FarmersMarket) {
        savedFarmersMarkets.append(farmersMarket)
        print("added new farmers market!!")
    }
    // this function will add a new shopping list to be saved
    func addNewShoppingList(_ shoppingList: List) {
        savedShoppingLists.append(shoppingList)
        print("added new shopping list!!")
    }
    
    //this function will remove the farmers market from saved
    func removeFarmersMarket(_ farmersMarket: FarmersMarket) {
        if let index = savedFarmersMarkets.index(where: { (savedMarket) -> Bool in
            return savedMarket.facilityname == farmersMarket.facilityname && savedMarket.latitude == farmersMarket.latitude && savedMarket.longitude == farmersMarket.longitude
        }) {
            savedFarmersMarkets.remove(at: index)
            print("removed market!!")
        } else {
            print("couldn't delete market!!")
        }
    }
    
    //this function will remove the shopping list from saved
    func removeShoppingList(_ shoppingList: List) {
        if let index = savedShoppingLists.index(where: { (savedShoppingList) -> Bool in
            return savedShoppingList.title == shoppingList.title
        }) {
            savedShoppingLists.remove(at: index)
            print("removed shopping list!")
        } else {
            print("couldn't delete shopping list!!")
        }
    }
    
    //this function will retrieve the farmersMarket
    func retrieveSavedFarmersMarket() -> [FarmersMarket] {
        return savedFarmersMarkets
    }
    //this function will retrieve the shoppingLists
    func retrieveSavedShoppingLists() -> [List] {
        return savedShoppingLists
    }
    //this function will save farmersMarkets
    private func saveFarmersMarket() {
        let propertyListEncoder = PropertyListEncoder()
        do {
            let encodedData = try propertyListEncoder.encode(savedFarmersMarkets)
            let phoneURL = dataFilePath(withPathName: farmersMarketSavedDataPath)
            try encodedData.write(to: phoneURL, options: .atomic)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    // this function will save shopping list to the phone
    private func saveShoppingLists(){
        let propertyListEncoder = PropertyListEncoder()
        do{
            let encodedData = try propertyListEncoder.encode(savedShoppingLists)
            let phoneURL = dataFilePath(withPathName: shoppingListDataPath)
            try encodedData.write(to: phoneURL, options: .atomic)
        }catch{
            print(error.localizedDescription)
        }
    }
    //this function will load the farmersMarkets from the phone
    func loadSavedFarmersMarket() {
        let propertyListDecoder = PropertyListDecoder()
        do {
            let phoneURL = dataFilePath(withPathName: farmersMarketSavedDataPath)
            let encodedData = try Data(contentsOf: phoneURL)
            let storedModelArray = try propertyListDecoder.decode([FarmersMarket].self, from: encodedData)
            savedFarmersMarkets = storedModelArray
        }
        catch {
            print(error.localizedDescription)
        }
    }
    //this function will load the shoppingLists from the phone
    func loadSavedShoppingLists(){
        let propertyListDecoder = PropertyListDecoder()
        do{
        let phoneURL = dataFilePath(withPathName: shoppingListDataPath)
        let encodedData = try Data(contentsOf: phoneURL)
        let storedModelArray =  try propertyListDecoder.decode([List].self, from: encodedData)
        savedShoppingLists = storedModelArray
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    private func dataFilePath(withPathName path: String) -> URL {
        return FileManagerHelper.manager.documentsDirectory().appendingPathComponent(path)
    }
    //Helper function for the dataFilePath method
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

