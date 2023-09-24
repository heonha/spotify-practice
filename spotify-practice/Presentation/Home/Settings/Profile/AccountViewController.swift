//
//  AccountViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import UIKit
import SnapKit

final class AccountViewController: UIViewController {

    private let viewModel: AccountViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections: [Section] = []
    
    init(viewModel: AccountViewModel = AccountViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = .systemBackground
        self.setNavigationBatTitle(title: "계정")
        configureTableView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func failToGetProfile(errorMessage: String?) {
        let label = UILabel()
        self.view.bounds = label.frame
        label.text = "프로필을 로드할 수 없습니다.\n\(errorMessage ?? "")"
        label.sizeToFit()
        self.view.addSubview(label)
    }
    
    private func getProfile() {
        viewModel.getProfile { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.configureSections(data: profile)
                }
            case .failure(let error):
                self?.failToGetProfile(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func configureSections(data: UserProfile) {
        self.sections.removeAll()
        
        let userName = Section(title: "사용자이름", cells: [.init(title: data.displayName, handler: {
            
        })])
        let email = Section(title: "이메일", cells: [.init(title: data.email, handler: {
            
        })])
        let subscription = Section(title: "요금제", cells: [.init(title: data.product, handler: {
            
        })])
        
        self.sections.append(userName)
        self.sections.append(email)
        self.sections.append(subscription)
        print(sections)
        updateUI()
    }
    
    private func updateUI() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    private func layout() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView.numberOfSections != 0 else { return 0 }
        return sections[section].cells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = sections[indexPath.section]
        let cellData = section.cells[indexPath.row]
        cell.textLabel?.text = cellData.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !sections.isEmpty else { return nil }
        
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.getProfile()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
