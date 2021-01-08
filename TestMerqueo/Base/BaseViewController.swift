//
//  BaseViewController.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 7/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func alertWithHandler(title:String ,message:String, completionHandler: @escaping () -> Void ) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (alert) in
                completionHandler()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}
