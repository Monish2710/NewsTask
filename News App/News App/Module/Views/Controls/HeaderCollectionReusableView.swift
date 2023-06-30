//
//  HeaderCollectionReusableView.swift
//  News App
//
//  Created by Monish Kumar on 30/06/23.
//

import SDWebImage
import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    let collectionView = Helper.makeCollectionView()
    let pageControl = UIPageControl()
    var timer = Timer()
    var counter = 0
    var isLoaded = false
    var callBack: ((String) -> Void)?
    fileprivate var dataArray: [TendingResponse]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
    }

    @objc func changeImage() {
        if counter < dataArray?.count ?? 0 {
            let index = IndexPath(item: counter, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }

    func setupUI() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        collectionView.allowsSelection = true
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(HeaderCollectionViewCell.self))

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pageControl.currentPage = 0
        pageControl.numberOfPages = dataArray?.count ?? 0
    }

    func configueHeader(_ array: [TendingResponse]?, completion: ((String) -> Void)?) {
        dataArray = array
        callBack = completion
        if dataArray?.count ?? 0 > 0 {
            pageControl.numberOfPages = dataArray?.count ?? 0
            if !isLoaded {
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                isLoaded = true
            }
        }
    }
}

extension HeaderCollectionReusableView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let dataArray else { return 0 }
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(HeaderCollectionViewCell.self), for: indexPath) as? HeaderCollectionViewCell, let dataArray
        else { preconditionFailure("Failed to load collection view cell") }
        let image = dataArray[indexPath.row].media.first?.mediaMetadata.first?.url ?? ""
        cell.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "nycTime"))
        cell.titleLabel.text = dataArray[indexPath.row].adxKeywords
        cell.tapButton.tag = indexPath.row
        cell.tapButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return cell
    }

    @objc func handleRegister(sender: UIButton) {
        if let urlString = dataArray?[sender.tag].url {
            callBack?(urlString)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = dataArray?[indexPath.row].url {
            callBack?(urlString)
        }
    }
}

extension HeaderCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height - 40)
    }
}
