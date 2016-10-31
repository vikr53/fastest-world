//
//  FastestProductsVC.swift
//  fastest.world
//
//  Created by RamR on 10/27/16.
//  Copyright © 2016 VikramR. All rights reserved.
//

import UIKit
import StoreKit

class FastestProductsVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @IBOutlet weak var buy5Btn: UIButton!
    @IBOutlet weak var buy10Btn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buy5Btn.isEnabled = false
        buy10Btn.isEnabled = false
        
        //Set IAPS
        if (SKPaymentQueue.canMakePayments()) {
            print("VIKP: IAP is enabled, loading")
            let productID: Set<String> = Set(["com.vikios.fastestworld.addTest","com.vikios.addSome"])
            
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
            request.delegate = self
            request.start()
        } else {
            print("VIKP: please enable IAPS")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buy5AttemptsTapped(_ sender: AnyObject) {
        for product in list {
            let prodID = product.productIdentifier
            if (prodID == "com.vikios.fastestworld.add5Attempts") {
                p = product
                buyProduct()
                break;
            }
        }
    }
    
    func add5Attempts() {
        DataService.ds.attempts5Renew()
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyProduct() {
        print("VIKP: buy \(p.productIdentifier)")
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.invalidProductIdentifiers.isEmpty {
            print("VIKP: \(response.invalidProductIdentifiers)")
        }
        print("VIKP: Products request - \(response.products)")
        let myProduct = response.products
        
        for product in myProduct {
            print("VIKP: product added")
            print("VIKP: product - \(product.productIdentifier)")
            print("VIKP: \(product.localizedTitle)")
            print("VIKP: \(product.localizedDescription)")
            print("VIKP: \(product.price)")
            
            list.append(product as SKProduct)
        }
        
        buy5Btn.isEnabled = true
        buy10Btn.isEnabled = true
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("VIKP: add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print("VIKP: \(trans.error)")
            
            switch trans.transactionState {
            case .purchased:
                print("VIKP: buy, ok unlock iap here")
                print("VIKP: \(p.productIdentifier)")
                
                let prodID = p.productIdentifier as String
                switch prodID {
                    case "com.vikios.fastestworld.add5Attempts":
                        print("VIKP: added 5 attempts")
                        add5Attempts()
                default:
                    print("VIKP: IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .failed:
                print("VIKP: buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("VIKP: default")
                    break;
            }
        }
    }
    
    func finishTransaction(trans: SKPaymentQueue) {
        print("VIKP: finish trans")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
