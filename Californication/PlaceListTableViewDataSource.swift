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
import HCSStarRatingView
import AlamofireImage

// MARK: Types

private enum PlaceListIdentifier: String {
  case placeCell = "PlaceCell"
}

private enum DataSourceState {
  case empty, `default`
}

// MARK: - PlaceListTableViewDataSource: NSObject

final class PlaceListTableViewDataSource: NSObject {
  
  // MARK: Properties
  
  var places: [Place]?
  
  fileprivate var dataSourceState = DataSourceState.default
  
  // MARK: Public Methods
  
  func place(for indexPath: IndexPath) -> Place? {
    return places?[indexPath.row]
  }
  
}

// MARK: - PlaceListTableViewDataSource: UITableViewDataSource -

extension PlaceListTableViewDataSource: UITableViewDataSource {
  
  // MARK: UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    let isEmpty = (places == nil)
    
    dataSourceState = isEmpty ? .empty : .default
    configure(tableView)
    
    return isEmpty ? 0 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PlaceListIdentifier.placeCell.rawValue) as! PlaceTableViewCell
    configure(cell, at: indexPath)
    return cell
  }
  
  // MARK: Helpers
  
  private func configure(_ tableView: UITableView) {
    switch dataSourceState {
    case .default:
      tableView.backgroundView = nil
      tableView.separatorStyle = .singleLine
    case .empty:
      let messageLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: tableView.bounds.size))
      messageLabel.text = "No data is currently available. Please pull down to refresh."
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = .center
      messageLabel.font = .systemFont(ofSize: 18)
      messageLabel.textColor = .lightGray
      messageLabel.sizeToFit()
      
      tableView.backgroundView = messageLabel
      tableView.separatorStyle = .none
    }
  }
  
  private func configure(_ cell: PlaceTableViewCell, at indexPath: IndexPath) {
    let selectedPlace = place(for: indexPath)!
    
    cell.placeTitleLabel.text = selectedPlace.name
    cell.placeSummaryLabel.text = selectedPlace.summary
    cell.placeRatingView.value = CGFloat(selectedPlace.rating)
    
    weak var weakCell = cell
    ImageDownloadManager.shared.image(for: selectedPlace.image.thumbnailURL) { (image, error) in
      guard error == nil else { return print("Failed to load thumbnail: \(error!.localizedDescription)") }
      weakCell?.placeImageView.image = image
    }
  }
  
}
