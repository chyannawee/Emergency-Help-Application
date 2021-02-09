//
//  HelpViewController.swift
//  War
//
//  Created by Chyanna Wee on 11/06/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var setGif: UIImageView!
    @IBOutlet weak var touchGif: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setGif.loadGif(name: "set")
        touchGif.loadGif(name: "touch")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
