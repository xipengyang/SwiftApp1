//
//  ProductDao.swift
//  we sale assistant
//
//  Created by xipeng yang on 8/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit


var productDao:ProductDao = ProductDao()

class ProductDao: NSObject {
    
    var products:[ProductD] = [ProductD]()
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    func saveProduct(var pProduct: ProductD) {
        appDel.saveProductAction(pProduct)
    }
    
    func newProduct() -> ProductD {
        return appDel.newProductAction()
    }
    
    
    func getProducts() -> [ProductD] {
        return products
    }
    
}

