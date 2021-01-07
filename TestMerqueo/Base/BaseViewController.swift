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
    
    func showAlert(title: String , message: String) {
        alert(title: title, text: message)
            .subscribe()
            .disposed(by: disposeBag)
        

    }
    
    func alert(title: String, text: String?) -> Completable {
        return Completable.create { [weak self] completable in
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                completable(.completed)
            }))
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        }
    }

}
