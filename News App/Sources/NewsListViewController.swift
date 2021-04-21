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
        API.loadNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedNews):
                self.allNews = fetchedNews
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            self.tableView.refreshControl?.endRefreshing()
        }
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
