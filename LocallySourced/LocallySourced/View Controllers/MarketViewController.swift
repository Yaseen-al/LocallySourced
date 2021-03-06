//
//  TestMarketViewController.swift
//  LocallySourced
//
//  Created by C4Q on 3/4/18.
//  Copyright © 2018 TeamLocallySourced. All rights reserved.
//

import UIKit
import SnapKit

class MarketViewController: UIViewController {
    
    private let cellSpacing: CGFloat = 10
    
    private let marketView = MarketView()
    
    // Animations
    private let launchScreenView = LaunchScreenView()
    
    public var markets = [FarmersMarket]() {
        didSet {
            animateMarketTV()
        }
    }
    private var filteredMarkets: [FarmersMarket] {
        guard filteredByCity != "All" else {return markets}
        if let city = filteredByCity {
            return markets.filter{
                guard let filteredCity = $0.facilitycity else {return false}
                if filteredCity.rawValue == city {
                    return true
                }
                return false
            }
        } else {
            return markets
        }
    }
    private var filteredByCity: String?
    
    private var cities = ["All", Facilitycity.bronx.rawValue, Facilitycity.brooklyn.rawValue, Facilitycity.manhattan.rawValue, Facilitycity.queens.rawValue, Facilitycity.statenIsland.rawValue]
    private var cityImages = [#imageLiteral(resourceName: "Above_Gotham"), #imageLiteral(resourceName: "bronximg"), #imageLiteral(resourceName: "brooklynimg"), #imageLiteral(resourceName: "manhattanimg"), #imageLiteral(resourceName: "queensimg"), #imageLiteral(resourceName: "statenimg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Access Green"
        marketView.marketTableView.dataSource = self; marketView.marketTableView.delegate = self
        marketView.marketCollectionView.dataSource = self; marketView.marketCollectionView.delegate = self
        constrainView()
        loadMarkets()
        configNavBar()
        view.addSubview(launchScreenView)
        launchScreenView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        launchScreenView.delegate = self
        navigationController?.navigationBar.alpha = 0.0
        tabBarController?.tabBar.alpha = 0.0
        UIView.animate(withDuration: 4.0, delay: 2.0, animations: {
            self.navigationController?.navigationBar.alpha = 1.0
            self.tabBarController?.tabBar.alpha = 1.0
            
        })
    }
    
    private func configNavBar(){
        navigationItem.title = "Access Green"
    }
    
    private func constrainView() {
        view.addSubview(marketView)
        marketView.snp.makeConstraints { (view) in
            view.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func loadMarkets() {
        FarmersMarketAPIClient.manager.getMarkets(completion: {self.markets = $0}, errorHandler: {print($0)})
    }
    
    private func animateMarketTV() {
        marketView.marketTableView.reloadData()
        let cells = marketView.marketTableView.visibleCells
        let tableViewHeight = marketView.marketTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight - 25)
        }
        var delayCounter:Double = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: delayCounter * 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 0.5
        }
    }
    
}
extension MarketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let market = filteredMarkets[indexPath.row]
        let detailVC = DetailViewController(market: market)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.20
    }
}
extension MarketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMarkets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let market = filteredMarkets[indexPath.row]
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: "customMarketTableViewCell", for: indexPath) as? MarketCustomTableViewCell else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketCell", for: indexPath) as! MarketCell
        cell.marketName.text = market.facilityname
        cell.marketCity.text = market.facilitycity?.rawValue
        return cell
        }
        customCell.marketLabel.text = market.facilityname
        customCell.boroughLabel.text = market.facilitycity?.rawValue
        guard let city = market.facilitycity else{
            return customCell
        }
        switch  city{
        case .bronx:
            customCell.containerView.image = UIImage(named: "bronximg")
        case .brooklyn:
            customCell.containerView.image = UIImage(named: "brooklynimg")
        case .manhattan:
            customCell.containerView.image = UIImage(named: "manhattanimg")
        case .queens:
            customCell.containerView.image = UIImage(named: "queensimg")
        case .statenIsland:
            customCell.containerView.image = UIImage(named: "statenimg")
        }
        return customCell
    }
}
extension MarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! CityCell
        let cityImage = cityImages[indexPath.row]
        let city = cities[indexPath.row]
        cell.testingImageView.image = cityImage
        cell.testingLabel.text = city.uppercased()
        return cell
    }
}
extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.height
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width * 0.30, height: height - (2 * cellSpacing))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(cellSpacing - 5 , cellSpacing + 5, cellSpacing - 5, cellSpacing + 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
extension MarketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }, completion: { finished in
                UIView.animate(withDuration: 0.06, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseIn, animations: { cell?.transform = CGAffineTransform(scaleX: 1, y: 1) }, completion: {(_) in
                    self.filteredByCity = self.cities[indexPath.row]
                    self.animateMarketTV()
                } )})
    }
}

extension MarketViewController: LaunchViewDelegate {
    public func animationEnded() {
        launchScreenView.removeFromSuperview()
    }
}

