//
//  PurchaseViewController.swift
//  Led Scroller Banner
//
//  Created by Raza on 23/10/2024.
//

import UIKit
import StoreKit
class PurchaseViewController: UIViewController ,  SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
       
    var product: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        SKPaymentQueue.default().add(self)
               activityIndicator.hidesWhenStopped = true
               activityIndicator.color = .white
               activityIndicator.isHidden = true

               NotificationCenter.default.addObserver(self, selector: #selector(updatePriceLabel), name: NSNotification.Name("ProductPriceUpdated"), object: nil)
               
               updatePriceLabel()
               
               priceLabel.layer.cornerRadius = 10
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func purchaseProduct(withProductIdentifier productIdentifier: String) {
        if SKPaymentQueue.canMakePayments() {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            let productRequest = SKProductsRequest(productIdentifiers: Set([productIdentifier]))
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("In-app purchases are disabled on this device.")
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
    }
    
    @objc func updatePriceLabel() {
           DispatchQueue.main.async {
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               if let product = appDelegate.product {
                   let formatter = NumberFormatter()
                   formatter.numberStyle = .currency
                   formatter.locale = product.priceLocale
                   self.priceLabel.text = formatter.string(from: product.price)
               }
           }
       }

    func initiatePurchase() {
           if let product = self.product {
               DispatchQueue.main.async {
                   self.activityIndicator.isHidden = true
                   self.activityIndicator.stopAnimating()
               }
               
               let payment = SKPayment(product: product)
               SKPaymentQueue.default().add(self)
               SKPaymentQueue.default().add(payment)
           }
       }

@IBAction func purchaseBtnTapped(_ sender: Any) {
           let productIdentifier = "removeads"
           purchaseProduct(withProductIdentifier: productIdentifier)
       }

@IBAction func restoreBtnTapped(_ sender: Any) {
           let productIdentifier = "removeads"
           purchaseProduct(withProductIdentifier: productIdentifier)
       }

@IBAction func cancelBtnTapped(_ sender: Any) {
           dismiss(animated: true, completion: nil)
       }
    
    // MARK: - SKProductsRequestDelegate

       func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
           if response.products.count > 0 {
               print("Product is available")
               self.product = response.products.first
               initiatePurchase()
           } else {
               activityIndicator.stopAnimating()
               activityIndicator.isHidden = true
               print("Product is not available")
           }
       }

       // MARK: - SKPaymentTransactionObserver

       func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
           print("Updated transactions called with \(transactions.count) transactions")
           var shouldHandleSuccessfulPurchase = false
           
           for transaction in transactions {
               print("Processing transaction with state: \(transaction.transactionState.rawValue)")
               switch transaction.transactionState {
               case .purchased:
                   print("Purchase successful!")
                   shouldHandleSuccessfulPurchase = true
                   UserDefaults.standard.set(true, forKey: "isProUser")
                   let syncSuccess = UserDefaults.standard.synchronize()
                   print("User defaults updated with isProUser = YES: \(syncSuccess ? "Success" : "Failed")")
                   SKPaymentQueue.default().finishTransaction(transaction)
                   
               case .failed:
                   print("Purchase failed with error: \(transaction.error?.localizedDescription ?? "Unknown error")")
                   SKPaymentQueue.default().finishTransaction(transaction)
                   
               case .restored:
                   print("Purchase restored")
                   shouldHandleSuccessfulPurchase = true
                   SKPaymentQueue.default().finishTransaction(transaction)
                   
               case .deferred:
                   print("Purchase deferred")
                   
               case .purchasing:
                   print("Purchasing")
                   
               @unknown default:
                   break
               }
           }
           
           if shouldHandleSuccessfulPurchase {
               handleSuccessfulPurchase()
           }
       }

       func handleSuccessfulPurchase() {
           print("handleSuccessfulPurchase called")
           
           UserDefaults.standard.set(true, forKey: "isProUser")
           let syncSuccess = UserDefaults.standard.synchronize()
           print("User defaults updated with isProUser = YES: \(syncSuccess ? "Success" : "Failed")")
           
           let isProUser = UserDefaults.standard.bool(forKey: "isProUser")
           print("isProUser value in user defaults: \(isProUser)")

           DispatchQueue.main.async {
               print("Stopping activity indicator and preparing to show alert")
               
               self.activityIndicator.stopAnimating()
               self.activityIndicator.isHidden = true
               
               if self.presentingViewController != nil {
                   self.dismiss(animated: true, completion: {
                       print("ViewController dismissed, showing success alert")
                       self.showPurchaseSuccessAlert()
                   })
               } else {
                   print("No presentingViewController, showing success alert directly")
                   self.showPurchaseSuccessAlert()
               }
           }
       }

       func showPurchaseSuccessAlert() {
           print("showPurchaseSuccessAlert called")
           
           let alert = UIAlertController(title: "Purchase Successful", message: "Your payment was successful.", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(okAction)
           
           DispatchQueue.main.async {
               print("Presenting success alert")
               self.present(alert, animated: true, completion: nil)
           }
       }
    
}


