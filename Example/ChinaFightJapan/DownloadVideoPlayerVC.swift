//
//  DownloadVideoPlayerVC.swift
//  ChinaFightJapan_Example
//
//  Created by mac on 2019/10/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ChinaFightJapan

class DownloadVideoPlayerVC: UIViewController {

    
    /// 播放本地文件的时候，状态栏颜色样式与是否全屏无关 （默认全屏）
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let orirntation = UIApplication.shared.statusBarOrientation
        if  orirntation == UIInterfaceOrientation.landscapeLeft || orirntation == UIInterfaceOrientation.landscapeRight {
            return .lightContent
        }
        return .default
    }
    
    fileprivate lazy var videoPlayer: NicooPlayerView = {
        let player = NicooPlayerView(frame: self.view.frame, bothSidesTimelable: true)
        player.delegate = self
        return player
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        let fileUrl = Bundle.main.path(forResource: "hubblecast", ofType: ".m4v")
        videoPlayer.playLocalVideoInFullscreen(fileUrl, "hubblecast", view, sinceTime: 0)
        videoPlayer.playLocalFileVideoCloseCallBack = { [weak self] (playValue) in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}


// MARK: - User Actions

extension DownloadVideoPlayerVC {
    
    
}

// MARK: - NicooPlayerDelegate

extension DownloadVideoPlayerVC: NicooPlayerDelegate {
    
    func retryToPlayVideo(_ player: NicooPlayerView , _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        
    }
    
    
}
