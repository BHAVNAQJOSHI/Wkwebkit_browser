//
//  ViewController.swift
//  Trial
//
//  Created by sunarc on 8/20/21.
//

import UIKit
import WebKit


// life cycle and instance members
class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var searchHistoryItems = Set<String>()
    var click = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    
    
    
}





// All IBACtions
extension ViewController {
    @IBAction func searchBtnAction(_ sender: UIButton!) {
        click = true
        
        if let searchText = searchTextField.text {
            searchHistoryItems.insert(searchText)
        }
        
        historyTableView.isHidden = true
        webView.isHidden = false        //let btnclick = true
        //if (btnclick == true)
        print(searchHistoryItems)
        //searchTextField.text = webView.url?.absoluteString
        //historyTableView.isHidden = true
            
        
        func searchTextOnGoogle(text: String){
                    let textComponent = text.components(separatedBy: " ")
                    let searchString = textComponent.joined(separator: "+")
                    let url = URL(string: "https://www.google.com/search?q=" + searchString)
                    let urlRequest = URLRequest(url: url!)
                    webView.load(urlRequest)
                }
        
                if let urlString = searchTextField.text{
                    if urlString.starts(with: "http://") || urlString.starts(with: "https://"){
                        //webView.loadUrl(string: urlString)
                        webView.load(URLRequest( url: URL(string: urlString )!))
                    }else if urlString.contains("www"){
                        //webView.loadUrl(string: "http://\(urlString)")
                        webView.load(URLRequest(url: URL(string:"http://\(urlString)")!))
                    }else{
                        searchTextOnGoogle(text: urlString)
                    }
                }
        //self.historyTableView.isHidden = false
        //searchTextField.text = webView.url?.absoluteString
        
       // click = false
        
        searchTextField.resignFirstResponder()
        
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func refreshBtnAction(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func nextBtnaction(_ sender: Any) {
        webView.goForward()
    }

}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        historyTableView.reloadData()
        historyTableView.isHidden = false
        webView.isHidden = true
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//   // webView.isHidden = true
//
//     self.historyTableView.isHidden = false
//    // reloadInputViews()
//
//    }

}


extension ViewController: UIWebViewDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if click {
          
           // webView.isHidden = false
       if let urlStr = navigationAction.request.url?.absoluteString{
        
        searchTextField.text = urlStr
       }
        decisionHandler(.allow)
    }
    }

}


extension ViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Array(searchHistoryItems)[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            cell.textLabel?.text = Array(searchHistoryItems)[indexPath.row]
        searchTextField.text = cell.textLabel?.text
       searchBtnAction(nil)
        
    }
    
}
