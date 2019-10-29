//
//  ViewController.swift
//  ChinaFightJapan
//
//  Created by jiruxue82@gmail.com on 10/28/2019.
//  Copyright (c) 2019 jiruxue82@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playInFullScreen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func playInView(_ sender: UIButton) {
        let vc = PlayVideoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func playInCell(_ sender: UIButton) {
        
        let vc = PlayCellVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /// 下载完成的文件播放
    @IBAction func palyInFullScreenClick(_ sender: UIButton) {
        let localPlayVC = DownloadVideoPlayerVC()
        navigationController?.pushViewController(localPlayVC, animated: true)
    }
}

