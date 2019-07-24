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

import Foundation
import Firebase
import GoogleMaps

final class AppConfigurator {
  
  func initServices() {
    assert(Constants.googleMapsAPIKey.rawValue != "REPLACE_WITH_YOUR_API_KEY",
           "Please goto Constants.swift and replace Google Maps API key with your own.")
    FirebaseApp.configure()
    GMSServices.provideAPIKey(Constants.googleMapsAPIKey.rawValue)
  }
  
  func theme(with window: UIWindow) {
    // Mexican red color.
    window.tintColor = UIColor(red:0.64, green:0.11, blue:0.16, alpha:1.00)
    
    // Kaitoke green.
    let appearance = UINavigationBar.appearance()
    appearance.barTintColor = UIColor(red:0.13, green:0.32, blue:0.23, alpha:1.00)
    appearance.tintColor = UIColor.white
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
  }
  
}
