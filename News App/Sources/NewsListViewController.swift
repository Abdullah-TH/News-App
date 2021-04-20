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
    }
    
    private func loadNews() {
        URLSession.shared.dataTask(with: URL(string: "https://www.abdullahth.com/api/news.json")!) { data, response, error in
            let newsResponse = try! JSONDecoder().decode(NewsRootResponse.self, from: data!)
            self.allNews = newsResponse.articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
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
