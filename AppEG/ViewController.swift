//
//  ViewController.swift
//  AppEG
//
//  Created by Eléonore Goumy on 21/04/2017.
//  Copyright © 2017 Eléonore Goumy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        bbcApi.getBBCSportsArticles()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

