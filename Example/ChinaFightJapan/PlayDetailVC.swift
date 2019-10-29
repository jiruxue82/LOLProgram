//
//  PlayDetailVC.swift
//  ChinaFightJapan_Example
//
//  Created by mac on 2019/10/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ChinaFightJapan

class PlayDetailVC: UIViewController {

    lazy var fatherView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*9/16)
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    private lazy var barButton: UIBarButtonItem = {
        let barBtn = UIBarButtonItem(title: "跳转下页", style: .plain, target: self, action: #selector(PlayDetailVC.barButtonClick))
        return barBtn
    }()
    
    var playerViewExist = false
    var videoUrl: String?
    var playerView: NicooPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(fatherView)
    }
    
    ///创建或者接收播放器
    private func createOrRecivePlayer() {
        if !playerViewExist {
            if playerView != nil {
                ///接受列表页面传过来的播放器
                recivePlayerFromLastPage()
            } else {
                ///创建一个播放器
                playerView = NicooPlayerView.init(frame: fatherView.bounds, bothSidesTimelable: true)
                playerView?.delegate = self
                let url = URL(string: videoUrl ?? "")
                playerView?.playVideo(url, "i am new player", fatherView)
            }
            playerViewExist = true
        }
    }
    
    ///接受上个页面的播放器
    private func recivePlayerFromLastPage() {
        if playerView != nil {
            playerView!.changeVideoContainerView(fatherView)
            playerView!.delegate = self
        }
    }
    
    @objc func barButtonClick() {
        /// 离开视频详情播放页面，push进入别的页面，只支持竖屏
        
        //(这里，如果有网络监听，要将网络监听取消掉，否则在4G切换到wifi 时视频会自动播放，导致，页面在下一级页面，而播放器却在播放声音)
        /// 移除监听 ： 详情页面会有
        NotificationCenter.default.removeObserver(self)
        
        playerView!.playerStatu = PlayerStatus.Pause
        orientationSupport = NicooPlayerOrietation.orientationPortrait
        let next = UIViewController()
        next.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(next, animated: true)
    }
}

// MARK: - NicooPlayerDelegate
extension PlayDetailVC: NicooPlayerDelegate {
    
    func retryToPlayVideo(_ player: NicooPlayerView , _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        
    }
    
    func currentVideoPlayToEnd(_ videoModel: NicooVideoModel?, _ isPlayingDownLoadFile: Bool) {
        print("NextViewController -->> currentVideoPlayToEnd")
    }
}
