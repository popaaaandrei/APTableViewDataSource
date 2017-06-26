//
//  APTableViewDataSource.swift
//  generic table view data source
//
//  Created by Andrei on 06/07/16.
//  Copyright © 2016 Andrei Popa. All rights reserved.
//

import Foundation
import RxSwift

// comment master 1
// add comment 1

// conform your cells to this protocol
protocol APCellConfigurable {
    associatedtype ItemType
    static var identifier: String { get }
    func setupWith(model: ItemType)
}


// protocol extension for default implementation of identifier
extension APCellConfigurable where Self : UITableViewCell {
    static var identifier: String {
        let classFullName = NSStringFromClass(self) as String
        let className = classFullName.components(separatedBy: ".").last
        return className ?? classFullName
    }
}


class APTableViewDataSource<T, C : UITableViewCell> : NSObject, UITableViewDataSource, UITableViewDelegate where C : APInstantiable, C : APCellConfigurable, C.ItemType == T {
    
    typealias Element = T
    typealias Cell = C
    
    
    let rx_tableRowClicked = PublishSubject<IndexPath>()
    let rx_tableModelClicked = PublishSubject<Element>()
    let rx_tableReloadData = PublishSubject<Void>()
    
    
    private let disposeBag = DisposeBag()
    private var items = [Element]()
    
    /*
    override init() {
        super.init()
    }
    */
    
    func populate(withItems: [Element]) {
        items.removeAll()
        items.append(contentsOf: withItems)
        rx_tableReloadData.onNext()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell ?? Cell()
        
        // assign model
        cell.setupWith(model: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        rx_tableRowClicked.onNext(indexPath)
        rx_tableModelClicked.onNext(items[indexPath.row])
    }
}


