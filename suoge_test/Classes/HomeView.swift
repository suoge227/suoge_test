//
//  HomeView.swift
//  MVCDemo
//
//  Created by sg on 2022/6/29.
//

import UIKit

protocol TableViewInputCellDelegate {
    func inputCHanged(cell: TableViewInputCell,text: String)
}

public class TableViewInputCell: UITableViewCell{
    
    var delegate: TableViewInputCellDelegate?
    
    lazy var textfield: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入待办事项"
        field.delegate = self
        field.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .editingChanged)
        return field
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textfield)
        textfield.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width-40, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TableViewInputCell: UITextFieldDelegate {
    
    @objc func textfieldValueChanged(_ textfield: UITextField) {
        delegate?.inputCHanged(cell: self, text: textfield.text ?? "")
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func getTest() {
        print("Test Test")
    }
}

struct State {
    let todos: [String]
    let text: String
    
}


public class HomeView: UIView, TableViewInputCellDelegate{
    lazy var addButton: UIButton = {
        let item = UIButton()
        item.backgroundColor = .systemPink
        item.setTitle("添加", for: .normal)
        item.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        return item
    }()
    
    
    //我们的TableView 有两个 section，一个负责输入新的待办，另一个负责展示现有的条目。
    enum Section: Int {
        case input = 0,todos,max
    }
    
    var todos: [String] = []


    var state = State(todos: [], text: "") {
        didSet{
            if oldValue.todos != state.todos {
                tableView.reloadData()
            }
            if oldValue.text != state.text {
                
                let inputIndexPath = IndexPath(row: 0, section:  Section.input.rawValue)
                let inputCell = tableView.cellForRow(at: inputIndexPath) as? TableViewInputCell
                inputCell?.textfield.text = state.text
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.register(TableViewInputCell.classForCoder(), forCellReuseIdentifier: "inputTableViewCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        return tableView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("111111")
        addSubview(tableView)
        addSubview(addButton)
        tableView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
        addButton.frame = CGRect(x: UIScreen.main.bounds.width-80, y: 66, width: 60, height: 30)
        ToDoStore.shared.getToDoItems(completionHandler: { data in
//            self.todos += data
//            self.title = "TODO - (\(self.todos.count))"
//            self.tableView.reloadData()
            
            self.state = State(todos: self.state.todos+data, text: self.state.text)
        })
       
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addTodo() {
//        let inputIndex = IndexPath(row: 0, section: Section.input.rawValue)
//        guard let inputCell = tableView.cellForRow(at: inputIndex) as? TableViewInputCell,let text = inputCell.textfield.text else {
//            return
//        }
//        todos.insert(text, at: 0)
//        inputCell.textfield.text = ""
//        title = "TODO - (\(self.todos.count))"
//        self.tableView.reloadData()
        
        
        state = State(todos: state.todos + [state.text], text: "")
    }

    public func inputCHanged(cell: TableViewInputCell, text: String) {
//        let isItemLength = text.count >= 3
//        navigationItem.rightBarButtonItem?.isEnabled = isItemLength
        
        state = State(todos: state.todos, text: text)
    }

}

extension HomeView: UITableViewDelegate,UITableViewDataSource{
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Section.max.rawValue
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            return 1
        case .todos:
            return todos.count
        case .max:
            fatalError()
        }
    }

  
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputTableViewCell",for: indexPath) as! TableViewInputCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel?.text = todos[indexPath.row]
            return cell
        case .max:
            fatalError()
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.todos.rawValue else {
            return
        }
//        todos.remove(at: indexPath.row)
//        title = "TODO - (\(self.todos.count))"
//        self.tableView.reloadData()
         
         let newToDos = Array(state.todos[..<indexPath.row] + state.todos[(indexPath.row + 1)...])
         state = State(todos: newToDos, text: state.text)
    }
}






