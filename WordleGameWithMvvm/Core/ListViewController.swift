//
//  ListViewController.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 16.08.2022.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let database = GameDatabase()
    
    private var items: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = database.retrieveGames()
        print(items)
        tableView.register(UITableView.self, forCellReuseIdentifier: "Game")
        
    }
    

   

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game", for: indexPath)
        let game = items[indexPath.row]
        cell.textLabel?.text = "\(game.date)- \(game.words) - \(game.isSuccess)"
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
