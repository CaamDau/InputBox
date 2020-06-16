//Created  on 2019/8/22 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import UIKit


extension InputBoxPopping {
    public struct Model {
        ///
        
    }
}

extension InputBoxPopping {
    @discardableResult
    public class func show(_ placeholder:String = "请输入",
                           cache key:String = "",
                           custom:((InputBoxPopping)->Void)? = nil,
                           completion:((String)->Void)? = nil) -> InputBoxPopping {
        let list = CD.window?.subviews.filter{$0.isKind(of: InputBoxPopping.self)}.compactMap{$0}
        if let list = list, !list.isEmpty {
            return list.first as! InputBoxPopping
        }
        let view = InputBoxPopping.cd_loadNib(from: "CaamDauInputBox")?.first as! InputBoxPopping
        //let view = InputBoxPopping.cd_loadNib()?.first as! InputBoxPopping
        view.placeholder = placeholder
        view.cachekey = key
        view.completion = completion
        CD.window?.addSubview(view)
        view.snp.makeConstraints{$0.edges.equalToSuperview()}
        custom?(view)
        return view
    }
}


public class InputBoxPopping: UIView {
    @IBOutlet open weak var view_bg: UIView!
    @IBOutlet open weak var stack_bg: UIStackView!
    @IBOutlet open weak var stack_bg_L: NSLayoutConstraint!
    @IBOutlet open weak var stack_bg_T: NSLayoutConstraint!
    @IBOutlet open weak var stack_title: UIStackView!
    @IBOutlet open weak var stack_titleHeight: NSLayoutConstraint!
    @IBOutlet open weak var stack_text: UIStackView!
    @IBOutlet open weak var stack_textHeight: NSLayoutConstraint!
    @IBOutlet open weak var stack_num: UIStackView!
    @IBOutlet open weak var stack_numHeight: NSLayoutConstraint!
    @IBOutlet open weak var stack_custom: UIStackView!
    @IBOutlet open weak var stack_customHeight: NSLayoutConstraint!
    
    @IBOutlet open weak var view_titleLeft: UIView!
    @IBOutlet open weak var view_titleRight: UIView!
    @IBOutlet open weak var btn_titleLeft: UIButton!
    @IBOutlet open weak var btn_titleLeftWidth: NSLayoutConstraint!
    @IBOutlet open weak var lab_title: UIButton!
    @IBOutlet open weak var btn_titleRight: UIButton!
    @IBOutlet open weak var btn_titleRightWidth: NSLayoutConstraint!
    
    @IBOutlet open weak var text_view: TextView!
    @IBOutlet open weak var btn_textRight: UIButton!
    @IBOutlet open weak var btn_textRightWidth: NSLayoutConstraint!
    @IBOutlet open weak var btn_textRightHeight: NSLayoutConstraint!
    
    @IBOutlet open weak var lab_num: UILabel!
    @IBOutlet open weak var btn_numRight: UIButton!
    @IBOutlet open weak var btn_numRightWidth: NSLayoutConstraint!
    
    @IBOutlet open weak var btn_customRight: UIButton!
    @IBOutlet open weak var btn_customRightWidth: NSLayoutConstraint!
    
    /// 输入限制
    open var _maxTextNum:Int = 1000
    open var _minTextHeight:CGFloat = 40
    open var _maxTextHeight:CGFloat = 120
    var keyboard:Keyboard?
    public override func awakeFromNib() {
        super.awakeFromNib()
        /// 默认情况下
        do{
            let list = [stack_title, stack_num, stack_custom]
            list.forEach{$0?.cd.isHidden(true)}
        }
        do{
            let list = [btn_titleLeft, btn_titleRight, btn_textRight, btn_numRight, btn_customRight]
            list.forEach{
                $0?.cd
                    .background(UIColor.clear)
                    .text(UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium))
                    .text(UIColor.darkText)
            }
        }
        text_view.placeholder = "请输入"
        text_view.blockEditing = { [weak self](t, e)in
            switch e {
            case .editingChanged:
                self?.textEditingChanged()
            default:
                break
            }
        }
        keyboard = Keyboard(view: view_bg)
        text_view.textContainerInset = UIEdgeInsets(t: 10, l: 5, b: 10, r: 5)
        text_view.placeColor = UIColor.cd_hex("d3", dark:"f0")
        text_view.textView.backgroundColor = UIColor.cd_hex("f0f0f0").cd_alpha(0.8)
        text_view.font = UIFont.systemFont(ofSize: 14)
        
        text_view.textView.becomeFirstResponder()
    }
    
    var placeholder:String  {
        set{
            text_view.placeholder = newValue
        }
        get{
            return text_view.placeholder
        }
    }
    
    var cachekey:String = "" {
        didSet{
            text_view.text = InputBox.Cache.read(cachekey)
        }
    }
    var completion:((String)->Void)?
    
    @IBAction func hiddenClick(_ sender: UIButton) {
        switch sender {
        case btn_titleLeft:
            break
        default:
            break
        }
        self.removeFromSuperview()
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        completion?(text_view.text)
        self.removeFromSuperview()
    }
}



extension InputBoxPopping {
    func textEditingChanged(){
        if text_view.text.count > _maxTextNum {
            text_view.text = text_view.text[0..<_maxTextNum]
        }
        InputBox.Cache.save(cachekey, value: text_view.text)
        self.changeTextViewHeight()
    }
    func changeTextViewHeight(){
        let h = text_view.textView.contentSize.height - text_view.textContainerInset.top*2
        if h >= _maxTextHeight {
            stack_textHeight.constant = _maxTextHeight
        }
        else if h <= _minTextHeight {
            stack_textHeight.constant = _minTextHeight
        }
        else {
            stack_textHeight.constant = h
        }
    }
}
