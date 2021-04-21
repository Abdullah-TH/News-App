//
//  NewsListViewController.swift
//  News App
//
//  Created by Abdullah Althobetey on 21/04/2021.
//

import UIKit

class NewsListViewController: UIViewController {
    
    let tableView = UITableView()
    var allNews: [News] = []
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadNews()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "cell")
        tableView.refreshControl = UIRefreshControl()
    }
    
    private func loadNews() {
        tableView.refreshControl?.beginRefreshing()
        URLSession.shared.dataTask(with: URL(string: "https://www.abdullahth.com/api/news.json")!) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.showAlert(message: error.localizedDescription)
                }
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.showAlert(message: "Error with status code: \(statusCode)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.showAlert(message: "No data found")
                }
                return
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsRootResponse.self, from: data)
                self.allNews = newsResponse.articles
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.showAlert(message: error.localizedDescription)
                }
            }
            
        }.resume()
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
        let news = allNews[indexPath.row]
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        return cell
    }
}

extension NewsListViewController: UITableViewDelegate {}
