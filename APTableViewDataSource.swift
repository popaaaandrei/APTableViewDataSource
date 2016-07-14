//
//  APTableViewDataSource.swift
//  generic table view data source
//
//  Created by Andrei on 06/07/16.
//  Copyright © 2016 Andrei Popa. All rights reserved.
//

import Foundation
import RxSwift


// conform your cells to this protocol
protocol APCellConfigurable {
    associatedtype ItemType
    static var identifier: String { get }
    func setupWith(model model: ItemType)
}

// protocol extension for default implementation of identifier
extension APCellConfigurable where Self : UITableViewCell {
    static var identifier: String {
        let classFullName = NSStringFromClass(self)
        let className = classFullName.componentsSeparatedByString(".").last
        return className ?? classFullName
    }
}


class APTableViewDataSource<T, C : UITableViewCell where C : APInstantiable, C : APCellConfigurable, C.ItemType == T> : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias Element = T
    typealias Cell = C
    
    
    let rx_tableRowClicked = PublishSubject<NSIndexPath>()
    let rx_tableReloadData = PublishSubject<Void>()
    
    
    private let disposeBag = DisposeBag()
    private var items = [Element]()
    
    /*
    override init() {
        super.init()
    }
    */
    
    func populate(withItems withItems: [Element]) {
        items.removeAll()
        items.appendContentsOf(withItems)
        rx_tableReloadData.onNext()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.identifier) as? Cell ?? Cell()
        
        // assign model
        cell.setupWith(model: items[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rx_tableRowClicked.onNext(indexPath)
    }
}


