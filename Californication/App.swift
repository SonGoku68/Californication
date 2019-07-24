/**
 * Copyright (c) 2016 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

final class App {
  
  // MARK: Instance Properties
  
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let tabBarController: UITabBarController
  let placeListViewController: PlaceListViewController
  let mapViewController: MapViewController
  
  let placeDirector: PlaceDirector
  
  // MARK: - Init
  
  init(_ window: UIWindow) {
    let firebaseDirector = FirebaseDirector(
      builder: FirebaseBuilderImpl(),
      databaseManager: FirebaseManagerImpl(authManager: FirebaseAuthManagerImpl())
    )
    let googleMapsDirector = GoogleMapsDirector(networkManager: GoogleMapsNetworkManagerImpl())
    placeDirector = PlaceDirector(
      firebaseDirector: firebaseDirector,
      googleMapsDirector: googleMapsDirector,
      cacheManager: PlaceCacheManagerImpl()
    )
    
    tabBarController = window.rootViewController as! UITabBarController
    
    mapViewController = tabBarController.viewControllers![1] as! MapViewController
    mapViewController.placeDirector = placeDirector
    
    let navigationController = tabBarController.viewControllers![0] as! UINavigationController
    placeListViewController = navigationController.topViewController as! PlaceListViewController
    placeListViewController.placeDirector = placeDirector
    
    placeListViewController.didSelect = push(place:)
    mapViewController.didSelect = present(place:)
  }
  
  // MARK: Navigation
  
  func push(place: Place) {
    let detailVC = placeDetailsViewController(with: place)
    detailVC.title = "Detail"
    placeListViewController.navigationController!.pushViewController(detailVC, animated: true)
  }
  
  func present(place: Place) {
    let detailVC = placeDetailsViewController(with: place)
    tabBarController.present(detailVC, animated: true, completion: nil)
  }
  
  fileprivate func placeDetailsViewController(with place: Place) -> PlaceDetailsViewController {
    let controller = storyboard
      .instantiateViewController(withIdentifier: "PlaceDetails") as! PlaceDetailsViewController
    controller.place = place
    return controller
  }
  
}
