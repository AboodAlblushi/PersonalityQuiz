import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var history: [QuizResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz History"
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        history = QuizHistoryManager.shared.fetchHistory().reversed()
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = history[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "\(item.result) • \(formatDate(item.date))"
        
        return cell
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
