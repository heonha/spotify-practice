//
//  SettingsViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import UIKit
import SnapKit
import SDWebImage

final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureSections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {        
        self.setNavigationBatTitle(title: "설정")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .black
    }
    
    private func configureSections() {
        var section = Section(title: "", cells: [])
        let accountCell = CellData(title: "계정") {
            let accountVC = AccountViewController()
            self.push(accountVC)
        }
        section.cells.append(accountCell)
        self.sections.append(section)
    }
    
    private func layout() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellData = self.sections[0].cells[indexPath.row]
        cell.textLabel?.text = cellData.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.sections[indexPath.section].cells[indexPath.row]
        cell.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
    
}

#if DEBUG
import SwiftUI

struct SettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SettingsViewController()
        }
        .ignoresSafeArea()
    }
}
#endif

