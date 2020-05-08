//
//  DetailCharacterViewController.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//

import UIKit
import JewFeatures

protocol DetailCharacterViewControllerInterface: class {
    func display(series: ReloadableSectionSeriesItem)
    func display(comics: ReloadableSectionComicsItem)
    func displaySeries(error: String)
    func displayComics(error: String)
}

class DetailCharacterViewController: UIViewController {
    
    //MARK: Properties
    var interactor: DetailCharacterInteractorInterface?
    var router: DetailCharacterRouterInterface?
    var dataSource = ReloadableDataSource()
    var tableViewHeightConstraint = NSLayoutConstraint()
    var items = [ReloadableItem]()
    
    //MARK: UI Properties
    var scrollableStackView = ScrollableStackView(frame: .zero)
    var headerView = HeaderDetailCharacterView(frame: .zero)
    var tableView = UITableView.init(frame: .zero)
    var popupMessage: JEWPopupMessage?
    var seriesLoadingView = LoadingView(frame: .zero)
    var comicsLoadingView = LoadingView(frame: .zero)
    var seriesErrorLabel = UILabel(frame: .zero)
    var comicsErrorLabel = UILabel(frame: .zero)
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = interactor?.character?.name
        view.backgroundColor = .groupTableViewBackground
        setupView()
        seriesLoadingView.start()
        comicsLoadingView.start()
        interactor?.fetchSeries()
        interactor?.fetchComics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
    }
    
}

extension DetailCharacterViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(scrollableStackView)
    }
    
    func setupConstraints() {
        seriesLoadingView.backgroundColor = .white
        seriesLoadingView.height = 15
        comicsLoadingView.backgroundColor = .white
        comicsLoadingView.height = 15
        scrollableStackView.setupEdgeConstraints(parent: view)
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 100)
        tableViewHeightConstraint.isActive = true
        seriesErrorLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        comicsErrorLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.layoutIfNeeded()
    }
    
    func setupAdditionalConfiguration() {
        popupMessage  = JEWPopupMessage(parentViewController: self)
        if let interactor = interactor, let character = interactor.character {
            headerView.setup(with: character)
            scrollableStackView.setup(subViews: [headerView, seriesLoadingView, comicsLoadingView, tableView], axis: .vertical, spacing: 16, alwaysBounce: true)
            setupTableView()
        }
        
        
        
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.delegate = self
    }
    
    
}

extension DetailCharacterViewController: ReloadableDelegate {
    func apply(changes: SectionChanges) {
        self.tableView.beginUpdates()
        
        self.tableView.deleteSections(changes.deletes, with: .fade)
        self.tableView.insertSections(changes.inserts, with: .fade)
        
        self.tableView.reloadRows(at: changes.updates.reloads, with: .fade)
        self.tableView.insertRows(at: changes.updates.inserts, with: .fade)
        self.tableView.deleteRows(at: changes.updates.deletes, with: .fade)
        
        self.tableView.endUpdates()
        view.layoutIfNeeded()
        self.tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    func didSelected(indexpath: IndexPath, cell: ReloadableCellProtocol?) {
        
    }
    
    func didAction(editItem: ReloadableEditItem, indexPath: IndexPath, cell: UITableViewCell?) {
        
    }
    
    func didRefresh() {
        
    }
    
    func top(section: IndexPath) {
        
    }
    
    func reachBottomEnd() {
        
    }
    
    
}

extension DetailCharacterViewController: DetailCharacterViewControllerInterface {
    func display(series: ReloadableSectionSeriesItem) {
        tableView.isHidden = false
        seriesLoadingView.stop()
        seriesLoadingView.isHidden = true
        items.append(series)
        dataSource.setup(newItems: items, in: tableView, hasRefreshControl: false)
    }
    
    func display(comics: ReloadableSectionComicsItem) {
        tableView.isHidden = false
        comicsLoadingView.stop()
        comicsLoadingView.isHidden = true
        items.append(comics)
        dataSource.setup(newItems: items, in: tableView, hasRefreshControl: false)
    }
    
    func displaySeries(error: String) {
        seriesLoadingView.stop()
        seriesLoadingView.isHidden = true
        popupMessage?.show(withTextMessage: error, title: AppConstants.alertTitleWithBreakLine, popupType: .error, shouldHideAutomatically: true)
    }
    
    func displayComics(error: String) {
        comicsLoadingView.stop()
        comicsLoadingView.isHidden = true
        popupMessage?.show(withTextMessage: error, title: AppConstants.alertTitleWithBreakLine, popupType: .error, shouldHideAutomatically: true)
    }
    
    
}
