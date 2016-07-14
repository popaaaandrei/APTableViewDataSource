# APTableViewDataSource
This is a generic table view data source using RxSwift &amp; generics. To satisfy deeper requirements, feel encouraged to more `PublishSubject(s)`, add more complexity to the data store, maybe implement more delegates.


#### Discussion
So the pure MVVM recommendations are to avoid putting UIKit code inside your ViewModel. While I agree with that, I don't agree with respecting this at all costs. It's a thin line between doing things the proper way and over-engineering, so one has to choose carefully. The essential character of MVVM is the decoupling of responsabilities. And this solution is all about decoupling.

For the more curious types 🤓, Ash Furrow's POV can be found [here](http://artsy.github.io/blog/2015/09/24/mvvm-in-swift/) and [here](https://ashfurrow.com/blog/mvvm-is-exceptionally-ok/).


## Typical usage

#### 1) Add the dataSource to your ViewModel
A typical usage would be the following:


```
struct ViewModel {
	// your data store
	var items = [MyElement]()
	
	// table view data source & delegate
    let dataSource = APTableViewDataSource<MyElement, MyTableViewCell>()
    
    ...
}
```

#### 2) Conform your cell to `APCellConfigurable`

```
extension MyTableViewCell : APCellConfigurable {
	// 1) you don't need to specify typealias ItemType MyElement
	// implementing setupWith is enough, the compiler has all the info
	
	// 2) identifier is already implemented for you by protocol extensions
	// it's just the class name :)

	func setupWith(model model: MyElement) {
		// configure your cell
	}
	
}
```

#### 3) Use the dataSource inside your `UIViewController`

```
// datasource & delegate
tableView.dataSource = viewModel.dataSource  
tableView.delegate = viewModel.dataSource

viewModel  
    .dataSource
    .rx_tableReloadData
    .subscribeNext { [weak self] _ in
    	// the dataSource informs us that it has new data
        self?.tableView.reloadData()
    }
    .addDisposableTo(disposeBag)

viewModel  
    .dataSource
    .rx_tableRowClicked
    .subscribeNext { indexPath in
        // cell @ indexPath has been clicked
        // do something here like call a segue
    }
    .addDisposableTo(disposeBag)
```

Any of you has something to say, please create a new issue and we'll update the code together.
Don't forget to have fun! :]

XO,
Andrei
@popaaaandrei