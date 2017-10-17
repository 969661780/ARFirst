//
//  ViewController.swift
//  firstArKit
//
//  Created by mt y on 2017/10/17.
//  Copyright © 2017年 mt y. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBOutlet weak var enterARCon: UIButton!
    
    @IBAction func enterAR(_ sender: UIButton) {
        self.present(ARFirstViewController(), animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

