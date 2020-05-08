//
//  DetailCharacterViewController.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//

import UIKit
import JewFeatures

protocol DetailCharacterViewControllerInterface: class {
    
}

class DetailCharacterViewController: UIViewController {
    
    //MARK: Properties
    var interactor: DetailCharacterInteractorInterface?
    var router: DetailCharacterRouterInterface?
    var scrollableStackView = ScrollableStackView(frame: .zero)
    var headerView = HeaderDetailCharacterView(frame: .zero)
    var tableView = UITableView.init(frame: .zero)
    var dataSource = ReloadableDataSource()
    let tableViewHeight: CGFloat = 400
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        setupView()
        if let interactor = interactor, let character = interactor.character {
            DetailCharacterWorker().fetchComics(with: character.id ?? -1)
            DetailCharacterWorker().fetchSeries(with: character.id ?? -1)
        }
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
        if let interactor = interactor, let character = interactor.character {
            headerView.setup(with: character)
             scrollableStackView.setup(subViews: [headerView, tableView], axis: .vertical, spacing: 16, alwaysBounce: true)
            setupTableView()
            var items = [ReloadableItem]()
//            if let series = character.series {
//                let seriesItem = ReloadableSectionSeriesItem.init(series: series, heightParent: tableViewHeight/2)
//                    items.append(seriesItem)
//            }
//            
//            if let comics = character.comics {
//                let comicsItem = ReloadableSectionComicsItem.init(comics: comics, heightParent: tableViewHeight/2)
//                items.append(comicsItem)
//            }
            dataSource.setup(newItems: items, in: tableView, hasRefreshControl: false)
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
    
}
