import UIKit
import CoreData

class ItemDisplay : UIViewController
{
    var items : Item
    
    init(itemselected : Item)
    {
        self.items = itemselected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let skuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        return label
    }()
    
    let imageLabel: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    func setupUI()
    {
        view.addSubview(nameLabel)
        view.addSubview(skuLabel)
        view.addSubview(rateLabel)
        view.addSubview(descLabel)
        view.addSubview(imageLabel)
        view.addSubview(editButton)
        view.addSubview(backButton)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, skuLabel, rateLabel, descLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        editButton.addTarget(self, action: #selector(edit_tapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(back_tapped), for: .touchUpInside)
    }
    
    @objc func edit_tapped()
    {
        let viewcontroller = ViewController()
        present(viewcontroller, animated: true)
        
    }
    
    @objc func back_tapped()
    {
        dismiss(animated: true, completion: nil)
    }
}

