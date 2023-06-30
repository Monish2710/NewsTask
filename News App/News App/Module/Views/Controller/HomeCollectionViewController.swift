//
//  HomeCollectionViewController.swift
//  News App
//
//  Created by Monish Kumar on 28/06/23.
//

import Alamofire
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended
import SafariServices
import UIKit

class HomeCollectionViewController: UICollectionViewController, NVActivityIndicatorViewable {
    private var viewModel = NewsViewModel()
    var currentPage: Int = 0
    var isLoaded = true
    var dialogMessageController: UIAlertController?

    fileprivate var dataArray: [Doc]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    fileprivate var headerdataArray: [TendingResponse]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    fileprivate func setupUI() {
        startAnimating(.init(width: 100, height: 100), message: "Loading...", type: .ballClipRotatePulse, fadeInAnimation: nil)
        prepareNavigationBar()
        prepareCollectionView()
        prepareDataSource()
    }

    private func trendingAPI() {
        viewModel.fetchTrendingAPI { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                self.headerdataArray = data.results
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let dialogController = UIAlertController(title: "OOPS !", message: "Something went wrong, Try again 😀", preferredStyle: .alert)
                    dialogController.addAction(.init(title: "ǾƘ", style: .default))
                    self.present(dialogController, animated: true, completion: nil)
                }
            }
            self.getNewsApi()
        }
    }

    private func getNewsApi() {
        viewModel.fetchNews { [weak self] result in
            guard let self else { return }
            self.stopAnimating()
            switch result {
            case let .success(data):
                self.dataArray = data.response.docs
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let dialogController = UIAlertController(title: "OOPS !", message: "Something went wrong, Try again 😀", preferredStyle: .alert)
                    dialogController.addAction(.init(title: "ǾƘ", style: .default))
                    self.present(dialogController, animated: true, completion: nil)
                }
            }
        }
    }

    fileprivate func prepareDataSource() {
        trendingAPI()
    }

    fileprivate func prepareCollectionView() {
        collectionView.collectionViewLayout = ColumnFlowLayout()
        // Register cell classes
        collectionView.register(NewsListCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(NewsListCollectionViewCell.self))
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HeaderCollectionReusableView.self))
    }

    fileprivate func prepareNavigationBar() {
        guard let navController = navigationController else { return }
        // Customize navigation bar.
        title = "News"
        navigationItem.largeTitleDisplayMode = .always
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: AvatarView())
        let imageBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "repeat.1.circle.fill.ar"), style: .plain, target: self, action: #selector(imageButtonTapped))
        navigationItem.rightBarButtonItem = imageBarButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Add a gesture recognizer to the presenting view controller's view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)

        // Check if the alert controller is visible and the tap is outside of it
        if dialogMessageController?.isBeingPresented == true && !dialogMessageController!.view.frame.contains(location) {
            dialogMessageController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func imageButtonTapped() {
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let dataArray else { return 0 }
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NewsListCollectionViewCell.self), for: indexPath) as? NewsListCollectionViewCell, let dataArray
        else { preconditionFailure("Failed to load collection view cell") }
        cell.tapButton.tag = indexPath.row
        cell.configue(dataArray[indexPath.row]) { [weak self] in
            self?.safariController(dataArray[indexPath.row].webURL)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(HeaderCollectionReusableView.self), for: indexPath) as! HeaderCollectionReusableView
            header.configueHeader(headerdataArray) { [weak self] urlString in
                guard let self else { return }
                self.safariController(urlString)
            }
            return header
        }
        return UICollectionReusableView()
    }

    fileprivate func safariController(_ urlString: String) {
        let controller = SFSafariViewController(url: URL(string: urlString)!)
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = dataArray?[indexPath.row].webURL {
            safariController(urlString)
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height)
        {
            if viewModel.totalPage >= currentPage {
                if isLoaded {
                    isLoaded = false
                    currentPage = currentPage + 1
                    viewModel.fetchMoreNews(currentPage) { [weak self] result in
                        guard let self else { return }
                        self.isLoaded = true
                        switch result {
                        case let .success(data):
                            self.dataArray?.append(contentsOf: data.response.docs)
                        case .failure:
                            // Handle the error
                            break
                        }
                    }
                }
            }
        }
    }
}
