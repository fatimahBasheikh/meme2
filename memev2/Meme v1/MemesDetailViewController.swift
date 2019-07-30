//
//  MemesDetailViewController.swift
//  Meme v1
//
//  Created by fatoom on 14/10/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class MemesDetailViewController: UIViewController {

    var memeToShow: Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeToShow.memeImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

