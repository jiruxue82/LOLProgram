//
//  PlayCellVC.swift
//  ChinaFightJapan_Example
//
//  Created by mac on 2019/10/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ChinaFightJapan

class PlayCellVC: UIViewController {
    
    /// 这里重写系统方法，为了让 StatusBar 跟随播放器的操作栏一起 隐藏或显示，且在全屏播放时， StatusBar 样式变为 lightContent
    /// 全屏播放时，让状态栏变为 lightContent
    /// 1.如果整个项目的状态栏已经为 lightContent，则不需要这些操作，直接播放就好。
    /// 2.如果整个项目状态栏为default，则需要在添加播放器的页面加上一个bool判断， 再重写preferredStatusBarStyle属性,将状态栏样式与播放器的横竖屏关联，plist文件中添加: Status bar is initially hidden = YES
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let orirntation = UIApplication.shared.statusBarOrientation
        if  orirntation == UIInterfaceOrientation.landscapeLeft || orirntation == UIInterfaceOrientation.landscapeRight {
            return .lightContent
        }
        return .default
    }
    
    private let urlStrings = ["https://me.guiji365.com/20180616/LQfzeEFU/index.m3u8","http://api.gfs100.cn/upload/20180201/201802011423168057.mp4","http://aliyun36001.baomihua.com/23cb24d3f9974acc8f72e93f5bd62d71/5c4b0c68/3917/39169227_7_d7d4eedd1c7bf7965d15ff422c82ef0a.mp4","http://api.gfs100.cn/upload/20171218/201712181643211975.mp4","http://api.gfs100.cn/upload/20180201/201802011423168057.mp4","http://api.gfs100.cn/upload/20180201/201802011423168057.mp4","http://api.gfs100.cn/upload/20180201/201802011423168057.mp4"]

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "NicooVideoCell", bundle: Bundle.main), forCellReuseIdentifier: NicooVideoCell.cellIdentifier)
        return table
    }()
    
    ///当前正在播放的cell所在indexPath
    var playerCellIndex: IndexPath?
    ///当前添加播放器的cell
    var lastPlayerCell:  NicooVideoCell?
    
    
    ///Cell上播放需要添加deinit,移除播放器。释放播放器
    deinit {
        print("视图播放器被释放了")
        
    }
    
    /// 移除播放器
    func removePlayer() {
        if self.lastPlayerCell != nil && lastPlayerCell!.isPlayerExist {
            for view in lastPlayerCell!.backGroundImage.subviews {
                if view is NicooPlayerView {
                    view.removeFromSuperview()
                    lastPlayerCell!.isPlayerExist = false
                    playerCellIndex = nil
                    lastPlayerCell = nil
                }
            }
        }
    }
    
    /// 跳转到详情
    ///
    /// - Parameter indexPath: 点击的indexPath
    func pushToDetailPage(_ indexPath: IndexPath) {
        let next = PlayDetailVC()
        if playerCellIndex == nil {
            /// 这里要播第几个，根据tableView 点击第几个cell来确定。
            next.videoUrl = urlStrings[indexPath.row]
            navigationController?.pushViewController(next, animated: true)
            return
        }
        /// 当前正在播放，点击当前播放的cell
        if playerCellIndex! == indexPath {
            if self.lastPlayerCell != nil && lastPlayerCell!.isPlayerExist {
                for view in lastPlayerCell!.backGroundImage.subviews {
                    if view is NicooPlayerView {
                        next.playerView = (view as! NicooPlayerView)
                        lastPlayerCell!.isPlayerExist = false
                        playerCellIndex = nil
                        lastPlayerCell = nil
                        (view as! NicooPlayerView).interfaceOrientation(UIInterfaceOrientation.portrait)  // 先回到竖屏状态
                        navigationController?.pushViewController(next, animated: true)
                    }
                }
            }
        } else {
            
            /// 当前正在播放, 点击 非 正在播放的cell ，先移除正在播放的播放器
            if lastPlayerCell != nil && playerCellIndex != nil  {
                for view in lastPlayerCell!.backGroundImage.subviews {
                    if view is NicooPlayerView {
                        view.removeFromSuperview()
                        lastPlayerCell!.isPlayerExist = false
                    }
                }
            }
            /// 这里要播第几个，根据tableView 点击第几个cell来确定。
            next.videoUrl = urlStrings[indexPath.row]
            navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "视频列表播放"
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension PlayCellVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NicooVideoCell.cellIdentifier, for: indexPath) as! NicooVideoCell
        cell.playButtonClickBlock = { [weak self] (sender) in
            guard let strongSelf = self else { return }
            ///当前页面已经存在一个播放器，并且本次点击不是上次同一个cell,先移除上一个播放器
            if strongSelf.lastPlayerCell != nil && strongSelf.playerCellIndex != nil && strongSelf.playerCellIndex! != indexPath {
                for view in strongSelf.lastPlayerCell!.backGroundImage.subviews {
                    if view is NicooPlayerView {
                        view.removeFromSuperview()
                        strongSelf.lastPlayerCell!.isPlayerExist = false
                    }
                }
            }
            
            ///cell上没有播放器，才添加（不加这个，循环引用）
            if !cell.isPlayerExist {
                let player = NicooPlayerView(frame: cell.bounds)
                player.videoLayerGravity = .resizeAspect
                player.delegate = self
                //player.customViewDelegate = self //这个是用于右上角按钮的显示
                let url = URL(string: strongSelf.urlStrings[indexPath.row])
                player.playVideo(url, "VideoName", cell.backGroundImage)
                cell.isPlayerExist = true
                strongSelf.playerCellIndex = indexPath
                strongSelf.lastPlayerCell = cell
            } else {
                print("player not exsit")
            }
            
            cell.goDetailClick = { [weak self] (sender) in
                self?.pushToDetailPage(indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width * 9/16 + 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


// MARK: - 代理方法： 1. 网络不好，点击重试的操作。   2、 自定义操作栏

extension PlayCellVC: NicooPlayerDelegate, NicooCustomMuneDelegate {
    
    // NicooPlayerDelegate 网络重试
    
    func retryToPlayVideo(_ player: NicooPlayerView , _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        }else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
    
    func currentVideoPlayToEnd(_ videoModel: NicooVideoModel?, _ isPlayingDownLoadFile: Bool) {
        print("CellPlayVC ---> currentVideoPlayToEnd")
    }
    
    //    /// 自定义操作控件代理  ：NicooCustomMuneDelegate,   customTopBarActions 和 showCustomMuneView的优先级为  后者优先， 实现后者， 前者不起效
    //
    //        func showCustomMuneView() -> UIView? {
    //
    //            if self.index%2 == 0 {
    //                let view = CustomMuneView(frame: self.view.bounds)
    //                view.itemClick = { [weak self] in
    //                    print("itemClick ===== ?>>>>>>>>")
    //                }
    //                 return view
    //            }else {
    //                let view1 = CustomMuneView11(frame: self.view.bounds)
    //                view1.itemClick = { [weak self] in
    //                     print("itemClick ===== ?>>>>>>>>")
    //                }
    //                return view1
    //            }
    //
    //        }
    
}
