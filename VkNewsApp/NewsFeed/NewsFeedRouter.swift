

import UIKit

@objc protocol NewsFeedRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}
protocol NewsFeedDataStore {

}

protocol NewsFeedDataPassing {
  var dataStore: NewsFeedDataStore? { get }
}

class NewsFeedRouter: NSObject, NewsFeedRoutingLogic, NewsFeedDataPassing
{
  weak var viewController: NewsFeedViewController?
  var dataStore: NewsFeedDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: NewsFeedViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: NewsFeedDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
