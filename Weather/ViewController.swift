//
//  ViewController.swift
//  Weather
//
//  Created by Grant Maloney on 9/17/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let days:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "List")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.showCities))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "World")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.showCities))
        
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Chicago"
        imageView.image = UIImage(named: "TestBackground")
        
        self.collectionView.backgroundColor = UIColor.clear
        
        let snow = false
        
        if(snow) {
            let flakeEmitterCell = CAEmitterCell()
            flakeEmitterCell.contents = UIImage(named: "snowFlake")?.cgImage
            flakeEmitterCell.scale = 0.06
            flakeEmitterCell.scaleRange = 0.3
            flakeEmitterCell.emissionRange = .pi
            flakeEmitterCell.lifetime = 20.0
            flakeEmitterCell.birthRate = 40
            flakeEmitterCell.velocity = -30
            flakeEmitterCell.velocityRange = -20
            flakeEmitterCell.yAcceleration = 30
            flakeEmitterCell.xAcceleration = 5
            flakeEmitterCell.spin = -0.5
            flakeEmitterCell.spinRange = 1.0
            
            let snowEmitterLayer = CAEmitterLayer()
            snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
            snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
            snowEmitterLayer.emitterShape = kCAEmitterLayerLine
            snowEmitterLayer.beginTime = CACurrentMediaTime()
            snowEmitterLayer.timeOffset = 10
            snowEmitterLayer.emitterCells = [flakeEmitterCell]
            view.layer.addSublayer(snowEmitterLayer)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func showCities() {
        self.performSegue(withIdentifier: "showCities", sender: self)
    }
    
}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath) as? DayCell
        cell?.titleLabel.text = days[indexPath.row]
        cell?.degreeLabel.text = "70°"
        cell?.image.image = UIImage(named: "Sun")
        return cell!
    }
}

