//  HADropDown.swift

import UIKit

protocol HADropDownDelegate: class {
    func didSelectItem(dropDown: HADropDown, at index: Int)  
    func didShow(dropDown: HADropDown) 
    func didHide(dropDown: HADropDown) 
    
}

extension HADropDownDelegate {
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        
    }
    func didShow(dropDown: HADropDown)  {
        
    }
    func didHide(dropDown: HADropDown)  {
        
    }
}

@IBDesignable
class HADropDown: UIView {

    var delegate: HADropDownDelegate!
   
    @IBInspectable
    var textAllignment : NSTextAlignment {
        set {
            textAllignment1 = newValue
        }
        get {
            return textAllignment1
        }
    }
    
    
    @IBInspectable
    var titleFontSize : CGFloat {
        set {
            titleFontSize1 = newValue
        }
        get {
            return titleFontSize1
        }
    }
    fileprivate var titleFontSize1 : CGFloat = 12.0
    
    
    @IBInspectable
    var itemHeight : Double {
        get {
            return itemHeight1
        }
        set {
            itemHeight1 = newValue
        }
    }
    
     fileprivate var cellHeights = 30.0
    
    @IBInspectable
    var cellHeight : Double {
        get {
            return cellHeights
        }
        set {
            cellHeights = newValue
        }
    }
    
    @IBInspectable
    var itemBackground : UIColor {
        set {
            itemBackgroundColor = newValue
        }
        get {
            return itemBackgroundColor
        }
    }
    
    fileprivate var itemBackgroundColor : UIColor = .indian_red
    
    @IBInspectable
    var itemTextColor : UIColor {
        set {
            itemFontColor = newValue
        }
        get {
            return itemFontColor
        }
    }
    fileprivate var itemFontColor = UIColor.white
    
    fileprivate var itemHeight1 = 30.0
    
    
    @IBInspectable
    var itemFontSize : CGFloat {
        set {
            itemFontSize1 = newValue
        }
        get {
            return itemFontSize1
        }
    }
    fileprivate var itemFontSize1 : CGFloat = 14.0
    fileprivate var textAllignment1:NSTextAlignment = .left
    
    var itemFont = UIFont.systemFont(ofSize: 14)
    
    var font : UIFont {
        set {
            selectedFont = newValue
        }
        get {
            return selectedFont
        }
    }
    fileprivate var selectedFont = UIFont.boldSystemFont(ofSize: 12)
    var items = [String]()
    fileprivate var selectedIndex = -1
    
    var isCollapsed = true
    private var table = IntrinsicTableView() // UITableView()
    
    var getSelectedIndex : Int {
        get {
            return selectedIndex
        }
    }
    
    private var tapGestureBackground: UITapGestureRecognizer!
    private var panGestureBackground:UIPanGestureRecognizer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        textAllignment = .left
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        self.addGestureRecognizer(tapGesture)
        table.delegate = self
        table.dataSource = self
        var rootView = self.superview
        
        // here we getting top superview to add table on that.
        while rootView?.superview != nil {
        rootView = rootView?.superview
       }
      
       let newFrame: CGRect = self.superview!.convert(self.frame, to: rootView)
      self.tableFrame = newFrame
      self.table.frame = CGRect(x: self.frame.origin.x, y: (self.frame.origin.y) + (self.frame.height), width: (self.frame.width), height: 0)     
        
        table.backgroundColor = itemBackgroundColor
    }
      // Default tableview frame
      var tableFrame = CGRect.zero

    @objc func didTapBackground(gesture: Any) {
        isCollapsed = true
        collapseTableView()
        
    }
    func reloadData() {
        table.reloadData()
        didTapBackground(gesture: "")
        didTap(gesture: "")
    }
    @objc func didTap(gesture: Any) {
        isCollapsed = !isCollapsed
        if !isCollapsed {
            uncollapseTableView()
        }
        else {
            collapseTableView()
        }
    }
    func uncollapseTableView() {
        self.table.layer.zPosition = 1
        self.table.removeFromSuperview()
        self.table.layer.borderColor = UIColor.lightGray.cgColor
        self.table.layer.borderWidth = 1
        self.table.layer.cornerRadius = 10
        var rootView = self.superview
        
        while rootView?.superview != nil {
            rootView = rootView?.superview
        }
        rootView?.addSubview(self.table)
        let newFrame: CGRect = self.superview!.convert(self.frame, to: rootView)
        self.tableFrame = newFrame
        let numberOfCells = Int((UIScreen.main.bounds.height - (self.tableFrame.origin.y + self.frame.height))/CGFloat(itemHeight))
        let height : CGFloat = CGFloat(items.count > numberOfCells ? itemHeight*Double(numberOfCells) : itemHeight*Double(items.count))
        self.table.reloadData()
        self.table.frame = CGRect(x: self.tableFrame.origin.x, y: self.tableFrame.origin.y + self.frame.height, width: self.frame.width, height: height)
        if items.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.table.scrollToRow(at:
                indexPath, at: .top
                , animated: false)
        }
        if delegate != nil {
            delegate.didShow(dropDown: self)
        }
        let view = UIView(frame: UIScreen.main.bounds)
        view.tag = 99121
        // self.superview?.insertSubview(view, belowSubview: table)
        rootView?.insertSubview(view, belowSubview: table)
        tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(gesture:)))
        panGestureBackground = UIPanGestureRecognizer(target: self, action: #selector(didTapBackground(gesture:)))
        view.addGestureRecognizer(tapGestureBackground)
        view.addGestureRecognizer(panGestureBackground)
    }
    func collapseTableView() {
        if isCollapsed {
            // removing tableview from rootview
        UIView.animate(withDuration: 0.25, animations: { 
                self.table.frame = CGRect(x: self.tableFrame.origin.x, y: self.tableFrame.origin.y+self.frame.height, width: self.frame.width, height: 0)
            })
          var rootView = self.superview
          
          while rootView?.superview != nil {
             rootView = rootView?.superview
          }
          
          rootView?.viewWithTag(99121)?.removeFromSuperview()
            self.superview?.viewWithTag(99121)?.removeFromSuperview()
            if delegate != nil {
                delegate.didHide(dropDown: self)
            }
        }
    }
}
extension HADropDown : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.textAlignment = textAllignment
        cell?.textLabel?.text = items[indexPath.row]
        let font = UIFont(descriptor: itemFont.fontDescriptor, size: itemFontSize)
        
        cell?.textLabel?.font = font
        
        cell?.textLabel?.textColor = itemTextColor
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
       /* if indexPath.row == selectedIndex {
            cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }*/
        
        cell?.backgroundColor = itemBackgroundColor
        
        cell?.selectionStyle = .none
        cell?.tintColor = self.tintColor
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeights)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        isCollapsed = true
        collapseTableView()
        if delegate != nil {
            delegate.didSelectItem(dropDown: self, at: selectedIndex)
        }
    }
}
class IntrinsicTableView:UITableView{
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height + 5)
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
