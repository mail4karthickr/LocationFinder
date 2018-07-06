//
//  LocationsListViewController.swift
//  LocationFinder
//
//  Created by karthick on 6/28/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class LocationsListViewController: UIViewController, BindableType {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationsListView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    private let messageView = MessageView()
    var viewModel: LocationsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add fotterview to hide empty rows
        locationsListView.tableFooterView = UIView(frame: .zero)
        
        // set parent view to show "No Results" message view
        messageView.useContainerView(view: locationsListView)
        messageView.showMessageView(with: "No Results")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // Bind all the UI elements to the viewmodel
    func bindViewModel() {
        
        // datasource for the tableview.
        // multipleSectionModel is a struct responsible for dealing with multiple sections
        let dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { (sectionModel, table, indexPath, element) in
                let cell = table.dequeueReusableCell(withIdentifier: "locationsListViewCell", for: indexPath)
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                switch sectionModel[indexPath] {
                case .NavigateToMapsSectionItem(let rowName):
                    cell.textLabel?.text = rowName
                case .LocationsSectionItem(let location):
                    cell.textLabel?.text = location.address
                }
                return cell
        })
        
        dataSource.titleForHeaderInSection = { _, index in
            let section = dataSource[index]
            return section.title
        }
        
        // For handling tableview item tap action
        locationsListView
            .rx
            .modelSelected(SectionItem.self)
            .subscribe(onNext:{ sectionItem in
                self.viewModel.itemTapped(sectionItem: sectionItem)
            })
            .disposed(by: disposeBag)
        
        // Observer for text change in the search bar and start searching as user types.
        let searchTextObservable = searchBar
            .rx.text
            .orEmpty  // make it non optional.
            .debounce(0.5, scheduler: MainScheduler.instance) // wait for 0.5 seconds for changes.
            .distinctUntilChanged() // check if the new value is the same as old, if it's same don't pass though.
            .subscribeOn(globalScheduler) // use background queue to execute the api call.
            .flatMapLatest { [unowned self] in
                self.viewModel.getLocations(searchText: $0) // Get the locations.
                    .asDriver(onErrorJustReturn: []) // Make sure the observable dose not error out and the subscriber for the resposne will be called on main thread.
            }
            .share()
            .asDriver(onErrorJustReturn: []) // When there is any error just return an emty array.

        // Show "No Results" message when result is empty
        searchTextObservable
            .filter { $0.isEmpty }
            .map { _ in "No Results" }
            .drive(messageView.rx.showMessageView)
            .disposed(by: disposeBag)
        
        // Bind tableview to the datasource when the result is received.
        searchTextObservable
            .filter { !$0.isEmpty }
            .do(onNext: { _ in self.messageView.hide() })
            .drive(locationsListView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        locationsListView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension LocationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        default:
            return 30
        }
    }
}








