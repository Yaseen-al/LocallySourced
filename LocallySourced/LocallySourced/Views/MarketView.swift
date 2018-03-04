//
//  TestMarketView.swift
//  LocallySourced
//
//  Created by C4Q on 3/4/18.
//  Copyright © 2018 TeamLocallySourced. All rights reserved.
//

import UIKit

class MarketView: UIView {

    lazy var marketCollectionView: UICollectionView = {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let cellSpacing: CGFloat = 10
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth * 0.30, height: screenHeight * 0.18)
        layout.sectionInset = UIEdgeInsetsMake(cellSpacing - 5 , cellSpacing + 5, cellSpacing - 5, cellSpacing + 5)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.scrollDirection = .horizontal
        let cView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cView.backgroundColor = .white
        cView.register(CityCell.self, forCellWithReuseIdentifier: "TestCell")
        return cView
    }()
    
    lazy var marketTableView: UITableView = {
        let tv = UITableView()
        tv.register(MarketCell.self, forCellReuseIdentifier: "MarketCell")
        tv.backgroundColor = .clear
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }
    private func setupViews() {
        let viewObjects = [marketTableView, marketCollectionView] as! [UIView]
        viewObjects.forEach{addSubview($0)}
        
        marketCollectionView.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalTo(self)
            view.height.equalTo(self).multipliedBy(0.25)
        }
        
        marketTableView.snp.makeConstraints { (view) in
            view.centerX.equalTo(self)
            //            view.height.equalTo(self.snp.height).multipliedBy(0.5)
            view.top.equalTo(marketCollectionView.snp.bottom).offset(10)
            view.leading.trailing.bottom.equalTo(self)
        }
    }
}