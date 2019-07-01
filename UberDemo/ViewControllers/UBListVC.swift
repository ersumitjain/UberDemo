//
//  UBListVC.swift
//  UberDemo
//
//  Created by Sumit Jain on 30/06/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import UIKit

class UBListVC: UIViewController, AlertDisplayer {
    
    //MARK: CellIdentifiers
    private enum CellIdentifiers {
        static let ImageCell = "ImageCell"
    }
    
    //MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: UBListVM?
    var searchString: String?
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.color = #colorLiteral(red: 0.8431372549, green: 0.3058823529, blue: 0.1764705882, alpha: 1)
        indicatorView.startAnimating()
        guard let searchText = searchString else {
            return
        }
        title = NSLocalizedString(searchText, comment: "")
        let request = UBRequest.from(text: searchText)
        viewModel = UBListVM(request: request, delegate: self)
        viewModel?.fetchPhotos()
    }
}

//MARK: Tableview Datasource Methods
extension UBListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.totalCount{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ImageCell, for: indexPath) as! ImageCell
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel?.photo(at: indexPath.row))
        }
        return cell
    }
}

extension UBListVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel?.fetchPhotos()
        }
    }
}

//MARK: Tableview Delegate Methods
extension UBListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/3
    }
}

//MARK: ViewModel Delegate Methods
extension UBListVC: ListVMDelegate{
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.tableView.reloadData()
            }
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

private extension UBListVC {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if let count = viewModel?.currentCount{
            return indexPath.row >= count
        }
        return false
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
