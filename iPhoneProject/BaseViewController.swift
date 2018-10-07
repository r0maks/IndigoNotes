//
//  BaseViewController.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/25/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onInit(arg: Any) {
        
    }
    
    func presentViewController<TViewControllerType>(_ viewControllerType: TViewControllerType, arg: Any? = nil) {
        let storyBoard : UIStoryboard = self.storyboard!;
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: viewControllerType)) as! BaseViewController
        
        if let a = arg {
            nextViewController.onInit(arg: a)
        }
        
        self.present(nextViewController, animated:true, completion:nil)
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
