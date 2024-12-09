import UIKit
import CoreData

protocol ViewControllerDelegate {
    func dataUpdated(itemsent : Item)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate : ViewControllerDelegate?
    
    var itemToEdit : Item?
    
    var nameField = UITextField()
    let descField = UITextField()
    let skuField = UITextField()
    let rateField = UITextField()
    let imageField = UIImageView()
    var imageDisplayed = UIImage()
    let selectImageButton = UIButton()
    let saveButton = UIButton()
    let goBackButton = UIButton()
    
    var imagePath : String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpUI()
    }
    
    func setUpUI()
    {
        goBackButton.setTitle("Back", for: .normal)
        goBackButton.tintColor = .systemBlue
        goBackButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.addTarget(self, action: #selector(goBackButtonPressed), for: .touchUpInside)
        view.addSubview(goBackButton)
        
        imageField.translatesAutoresizingMaskIntoConstraints = false
        imageField.contentMode = .scaleAspectFit
        imageField.layer.cornerRadius = 10
        imageField.layer.masksToBounds = true
        view.addSubview(imageField)
        
        imageField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        [nameField, descField, skuField, rateField].forEach
        {
            textfield in
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.backgroundColor = .white
            textfield.textColor = .black
            textfield.textAlignment = .center
            textfield.layer.cornerRadius = 10
            textfield.layer.borderWidth = 0.7
            textfield.layer.borderColor = UIColor.black.cgColor
            view.addSubview(textfield)
        }
        
        nameField.placeholder = "Item Name"
        descField.placeholder = "Item Description"
        skuField.placeholder = "Item SKU"
        rateField.placeholder = "Item Rate"
        
        [selectImageButton, saveButton].forEach
        {
            button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 10
            if button == selectImageButton
            {
                button.setTitle("Select Image", for: .normal)
                button.backgroundColor = .systemGray3
                button.tintColor = .black
                button.addTarget(self, action: #selector(selectImageButtonPressed), for: .touchUpInside)
            }
            else
            {
                button.setTitle("Submit", for: .normal)
                button.backgroundColor = .systemBlue
                button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
                button.tintColor = .magenta
            }
            view.addSubview(button)
        }
    
        let stackView = UIStackView(arrangedSubviews: [selectImageButton, nameField, descField, skuField, rateField, saveButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
                
        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
        NSLayoutConstraint.activate([
            goBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
    }
    
    @objc func selectImageButtonPressed()
    {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        imagePath = getDocumentsDirectory().appendingPathComponent(imageName).path

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
                do {
                    try jpegData.write(to: URL(fileURLWithPath: imagePath))
                } catch {
                    print("Failed to save image: \(error)")
                }
        }
        
        imageDisplayed = image
        imageField.image = imageDisplayed
        
        if(imageDisplayed != nil)
        {
            selectImageButton.setTitle("Update Image", for: .normal)
            selectImageButton.backgroundColor = .systemBlue
            selectImageButton.tintColor = .black
        }
        
        dismiss(animated: true, completion: nil)
    }

    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func saveButtonPressed()
    {
        if let itemToEdit = itemToEdit
        {
            itemToEdit.name = nameField.text
            itemToEdit.desc = descField.text
            if let skuText = skuField.text, let skuValue = Int64(skuText)
            {
                itemToEdit.sku = skuValue
            }

            if let rateText = rateField.text, let rateValue = Int64(rateText)
            {
                itemToEdit.rate = rateValue
            }
            itemToEdit.image = imagePath
            
            try! manageObjectContext.save()
            
            delegate?.dataUpdated(itemsent: itemToEdit)
        }
        else{
            let itemToBeAdded = Item(context: manageObjectContext)
            itemToBeAdded.name = nameField.text
            itemToBeAdded.desc = descField.text
            
            if let skuText = skuField.text, let skuValue = Int64(skuText)
            {
                itemToBeAdded.sku = skuValue
            }

            if let rateText = rateField.text, let rateValue = Int64(rateText)
            {
                itemToBeAdded.rate = rateValue
            }
            
            itemToBeAdded.image = imagePath
            
            try! manageObjectContext.save()
            
        }
        
        let items = try! manageObjectContext.fetch(Item.fetchRequest())
        
        dismiss(
            animated: true,
            completion: nil
        )
    }
    
    @objc func goBackButtonPressed()
    {
        dismiss(
            animated: true,
            completion: nil
        )
    }
}
