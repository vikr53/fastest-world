//
//  FastestProducts.swift
//  fastest.world
//
//  Created by RamR on 10/27/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import Foundation

public struct FastestProducts {
    public static let add5Attempts = "com.vikios.fastestworld.add5Attempts"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [FastestProducts.add5Attempts]
    
    public static let store = IAPHelper(productIds: FastestProducts.productIdentifiers)
}
