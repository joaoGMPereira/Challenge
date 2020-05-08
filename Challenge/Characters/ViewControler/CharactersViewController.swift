//
//  CharactersViewController.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import UIKit
import JewFeatures
import PodAsset

protocol CharactersViewControllerInterface: class {
    func display(characters: [ReloadableCellCharacterItem])
    func display(error: String, alertType: JEWPopupMessageType)
    func displayDisconnected()
    func displayStopLoading()
    func displayStartLoading()
}

class CharactersViewController: UIViewController {
    
    //MARK: Properties
    var interactor: CharactersInteractorInterface?
    var router: CharactersRouterInterface?
    var datasource = ReloadableDataSource()
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    //MARK: UI Properties
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var popupMessage: JEWPopupMessage?
    var notFoundImage = UIImageView(frame: .zero)
    var errorMessageLabel = UILabel(frame: .zero)
    var retryButton = UIButton(frame: .zero)
    let loadingView = LoadingView(frame: .zero)
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        JEWReachability.recheability.config = JEWReachabilityConfig(title: AppConstants.reachabilityTitle, message: AppConstants.reachabilityMessage, alertType: .custom(messageColor: .white, backgroundColor: .JEWPallete(red: 241, green: 174, blue: 47)))
        JEWReachability.recheability.enable()
        setupView()
        interactor?.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
        interactor?.updateFavoriteCharacters()
        
    }
    
}

extension CharactersViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(notFoundImage)
        view.addSubview(errorMessageLabel)
        view.addSubview(retryButton)
        view.addSubview(loadingView)
    }
    
    func setupConstraints() {
        loadingView.setupConstraints(parent: view, top: 0, leading: 0, trailing: 0)
        collectionView.setupConstraints(parent: loadingView, top: 0)
        collectionView.setupConstraints(parent: view, bottom: 0, leading: 0, trailing: 0)
        notFoundImage.setupConstraints(parent: view, top: 32, centerX: 0, width: 80, height: 80, useSafeLayout: true)
        errorMessageLabel.setupConstraints(parent: notFoundImage, topBottom: 8)
        errorMessageLabel.setupConstraints(parent: view, leading: 16, trailing: -16)
        retryButton.setupConstraints(parent: errorMessageLabel, topBottom: 16, leading: 32, trailing: -32, height: 50)
        
        
        view.layoutIfNeeded()
    }
    
    func setupAdditionalConfiguration() {
        loadingView.backgroundColor = .white
        loadingView.height = 5
        setupAppearance()
        setupPopup()
        setupCollectionView()
        setupErrorInfo()
        
    }
    
    private func setupAppearance() {
        collectionView.backgroundView = imageView
        self.title = CharactersConstants.title
        view.backgroundColor = .groupTableViewBackground
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupPopup() {
        popupMessage = JEWPopupMessage(parentViewController: self)
        popupMessage?.popupLayout = .top
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        datasource.delegate = self
        collectionView.register(UINib(nibName: CharacterCell.className, bundle: Bundle.main), forCellWithReuseIdentifier: CharacterCell.className)
        if let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize.init(width: 1, height: 1)
        }
    }
    
    private func setupErrorInfo() {
        if let bundle = PodAsset.bundle(forPod: JEWConstants.Resources.podsJewFeature.rawValue) {
            notFoundImage.image = UIImage(named: AppConstants.notFound, in: bundle, compatibleWith: nil)
        }
        errorMessageLabel.text = CharactersConstants.getCharacterError
        errorMessageLabel.textColor = .JEWBlack()
        errorMessageLabel.font = .JEW32Bold()
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        retryButton.setTitle(AppConstants.tryAgain, for: .normal)
        retryButton.setTitleColor(.JEWDefault(), for: .normal)
        retryButton.roundAllCorners(borderColor: .JEWDefault(), cornerRadius: retryButton.frame.height/2)
        retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        notFoundImage.isAnimated(isHidden: true)
        errorMessageLabel.isAnimated(isHidden: true)
        retryButton.isAnimated(isHidden: true)
    }
    
    @objc private func retryAction() {
        self.retryButton.layer.animate()
        interactor?.fetchCharacters()
    }
    
    private func showErrorInfo() {
        notFoundImage.isAnimated(isHidden: false)
        errorMessageLabel.isAnimated(isHidden: false)
        retryButton.isAnimated(isHidden: false)
        collectionView.isAnimated(isHidden: true)
    }
    
    private func showCharactersInfo() {
        notFoundImage.isAnimated(isHidden: true)
        errorMessageLabel.isAnimated(isHidden: true)
        retryButton.isAnimated(isHidden: true)
        collectionView.isAnimated(isHidden: false)
    }
}


extension CharactersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(CharactersViewController.reload),
            userInfo: searchText,
            repeats: false)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor?.fetchCharacters(searchName: String())
    }
    
    @objc func reload(timer: Timer) {
        if let searchName = timer.userInfo as? String {
            interactor?.fetchCharacters(searchName: searchName)
        }
    }
}

extension CharactersViewController: ReloadableDelegate {
    func apply(changes: SectionChanges) {
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteSections(changes.deletes)
            self.collectionView.insertSections(changes.inserts)
            
            self.collectionView.reloadItems(at: changes.updates.reloads)
            self.collectionView.insertItems(at: changes.updates.inserts)
            self.collectionView.deleteItems(at: changes.updates.deletes)
        })
    }
    
    func didSelected(indexpath: IndexPath, cell: ReloadableCellProtocol?) {
        
    }
    
    func didAction(editItem: ReloadableEditItem, indexPath: IndexPath, cell: UITableViewCell?) {
        
    }
    
    func didRefresh() {
        self.interactor?.refreshCharacters()
    }
    
    func top(section: IndexPath) {
        
    }
    
    func reachBottomEnd() {
    }
    
    
    
}

extension CharactersViewController: CharactersViewControllerInterface {
    
    func displayStartLoading() {
        loadingView.start()
    }
    
    func displayStopLoading() {
        loadingView.stop()
    }
    
    func display(characters: [ReloadableCellCharacterItem]) {
        showCharactersInfo()
        datasource.refreshControl.endRefreshing()
        datasource.setup(newItems: characters, in: self.collectionView, hasRefreshControl: true)
    }
    
    func display(error: String, alertType: JEWPopupMessageType) {
        switch alertType {
        case .error:
            showErrorInfo()
            break
        default:
            break
        }
        popupMessage?.show(withTextMessage: error, title: AppConstants.alertTitleWithBreakLine, popupType: alertType, shouldHideAutomatically: true)
    }
    
    func displayDisconnected() {
        showErrorInfo()
    }
}
