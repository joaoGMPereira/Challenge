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
    let tableViewHeight: CGFloat = 400
    var items = [ReloadableItem]()
    
    //MARK: UI Properties
    var scrollableStackView = ScrollableStackView(frame: .zero)
    var headerView = HeaderDetailCharacterView(frame: .zero)
    var tableView = UITableView.init(frame: .zero)
    var popupMessage: JEWPopupMessage?
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        setupView()
        interactor?.fetchSeries()
        interactor?.fetchComics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension DetailCharacterViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(scrollableStackView)
    }
    
    func setupConstraints() {
        scrollableStackView.setupEdgeConstraints(parent: view)
        tableView.setupConstraints(parent: scrollableStackView, height: tableViewHeight)
        //        characterImageView.setupConstraints(parent: view, height: view.frame.height/3)
        // characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: 9/16).isActive = true
        view.layoutIfNeeded()
    }
    
    func setupAdditionalConfiguration() {
        popupMessage  = JEWPopupMessage(parentViewController: self)
        if let interactor = interactor, let character = interactor.character {
            headerView.setup(with: character)
            scrollableStackView.setup(subViews: [headerView, tableView], axis: .vertical, spacing: 16, alwaysBounce: true)
            setupTableView()
            
            //            if let series = character.series {
            //                let seriesItem = ReloadableSectionSeriesItem.init(series: series, heightParent: tableViewHeight/2)
            //                    items.append(seriesItem)
            //            }
            //
            //            if let comics = character.comics {
            //                let comicsItem = ReloadableSectionComicsItem.init(comics: comics, heightParent: tableViewHeight/2)
            //                items.append(comicsItem)
            //            }
            
        }
        
        
        
    }
    
    private func setupTableView() {
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
        items.append(series)
        dataSource.setup(newItems: items, in: tableView, hasRefreshControl: false)
    }
    
    func display(comics: ReloadableSectionComicsItem) {
        items.append(comics)
        dataSource.setup(newItems: items, in: tableView, hasRefreshControl: false)
    }
    
    func displaySeries(error: String) {
        popupMessage?.show(withTextMessage: error, title: AppConstants.alertTitleWithBreakLine, popupType: .error, shouldHideAutomatically: true)
    }
    
    func displayComics(error: String) {
        
    }
    
    
}
