//
//  ViewController.swift
//  MIDemo
//
//  Created by William Chang on 17/2/2.
//  Copyright © 2017年 Initial-C. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let offsetH : CGFloat = 406.0;
    let turnOffsetH : CGFloat = 214.0;
    let kScreenW : CGFloat = UIScreen.main.bounds.width
    let cellID : String = "CellID"
    fileprivate lazy var headTopView : UIView = {
        let headTopView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 406.0))
        headTopView.backgroundColor = UIColor.init(red: 60/255.0, green: 68/255.0, blue: 79/255.0, alpha: 1.0)
        return headTopView;
    }()
    fileprivate lazy var dataTableView : UITableView = {
        let dataTableView = UITableView.init(frame: self.view.bounds, style: .plain)
        return dataTableView
    }()
    fileprivate lazy var tipsView : UIView = {
        let tipsView = UIView.init()
        tipsView.backgroundColor = UIColor.clear
        return tipsView
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let tipsLabel = UILabel.init()
        tipsLabel.text = "下拉同步数据"
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = UIFont.systemFont(ofSize: 12)
        return tipsLabel
    }()
    fileprivate lazy var tipsImageView : UIImageView = {
        let tipsImageView = UIImageView.init(image: UIImage.init(named: "tip_pull_down"))
        tipsImageView.contentMode = .scaleAspectFit
        return tipsImageView
    }()
    fileprivate lazy var dataImageView : UIImageView = {
        let dataImageView = UIImageView.init(image: UIImage.init(named: "step_image"))
        dataImageView.frame.size = CGSize.init(width: 264, height: 264)
        dataImageView.contentMode = .scaleAspectFill
        return dataImageView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel.init()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "小米运动"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: 50, height: 30)
        self.navigationItem.titleView = titleLabel
        dataTableView.contentInset = UIEdgeInsets.init(top: offsetH - 64, left: 0, bottom: 0, right: 0)
        dataTableView.scrollIndicatorInsets = dataTableView.contentInset
        dataTableView.delegate = self
        dataTableView.dataSource = self
        dataTableView.separatorStyle = .none
        self.view.addSubview(dataTableView)
        self.view.addSubview(headTopView)
        // tipsView
        headTopView.addSubview(tipsView)
        tipsView.snp.makeConstraints { (make) in
            make.bottom.equalTo(headTopView.snp.bottom)
            make.height.equalTo(45)
            make.width.equalTo(headTopView.snp.width)
            make.centerX.equalTo(headTopView.snp.centerX)
        }
        // tipsLabel
        tipsLabel.frame = CGRect.init(x: 0, y: 0, width: headTopView.frame.width, height: 20)
        tipsView.addSubview(tipsLabel)
        // tipsImageView
        tipsView.addSubview(tipsImageView)
        tipsImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(headTopView.snp.centerX)
            make.top.equalTo(tipsLabel.snp.bottom).offset(3)
        }
        // dataImageView
        headTopView.addSubview(dataImageView)
        dataImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(headTopView.snp.centerX)
            make.centerY.equalTo((headTopView.frame.size.height - 64) * 0.5 + 64)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "爱你一万年"
        cell?.textLabel?.textAlignment = NSTextAlignment.center;
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor.init(red: 39/255.0, green: 176/255.0, blue: 108/255.0, alpha: 1.0)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var slideH = -dataTableView.contentOffset.y
        var slideMaxH : CGFloat = 0.0
        var slideAlpha : CGFloat = 0.0
        var isSlideMax : Bool = false
        print("滑动距离: \(slideH)")
        if slideH <= 196 {
            slideH = 196
        }
        headTopView.frame.size.height = slideH
        dataImageView.snp.updateConstraints { (make) in
            make.centerY.equalTo((slideH - 64) * 0.5 + 64)
        }
        print("旋转: \(((offsetH - slideH)/210))")
        if ((offsetH - slideH)/210) > 0 {
            dataImageView.layer.transform = CATransform3DMakeRotation(((offsetH - slideH) / 210) * CGFloat(M_PI_2), 0.3, 0, 0)
        }
        if slideH > offsetH {
            slideMaxH = slideH
            if slideMaxH >= 456 {
                slideMaxH = 456
            }
            if slideH >= 456 {
                isSlideMax = true
            } else {
                isSlideMax = false
            }
            slideAlpha = (slideMaxH - offsetH) / 50.0
            if slideAlpha >= 0.99 {
                slideAlpha = 0.99
            }
        }
        print("透明度: \(slideAlpha)")
        tipsView.alpha = slideAlpha
        if isSlideMax {
            tipsLabel.text = "松手开始同步"
//            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//            animation.fromValue = NSNumber(value: 0.0)
//            animation.toValue = NSNumber(value: M_PI)
//            animation.duration = 0.8
//            animation.autoreverses = false
//            animation.fillMode = kCAFillModeForwards
//            animation.repeatCount = 1
//            tipsImageView.layer.add(animation, forKey: nil)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tipsImageView.transform = CGAffineTransform.init(rotationAngle:CGFloat(NSNumber(value: M_PI)))
            })
        } else {
            tipsLabel.text = "下拉同步数据"
            UIView.animate(withDuration: 0.3, animations: {
                self.tipsImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(NSNumber(value: M_PI * 2)))
            })
        }
    }
    
}

