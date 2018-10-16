//
//  CommandView.swift
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

import UIKit

let commandCellID = "commandCell"

class CommandModel {
    var title: String
    var imageName: String
    var action: () -> ()
    
    init(title: String, imageName: String, action: @escaping () -> ()) {
        self.title = title
        self.imageName = imageName
        self.action = action
    }
}

protocol CommandViewDelegate {
    func closeButtonClickCallback()
}

class CommandView: UIView {
    
    var dataSource: [CommandModel]
    var delegate: CommandViewDelegate

    init(frame: CGRect, dataSource: [CommandModel], delegate: CommandViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //colse button
        let closeButton: UIButton = {
            let closeBtnW = CGFloat(50)
            let closeBtnH = CGFloat(50)
            let closeBtnX = (self.bounds.size.width - closeBtnW) * 0.5
            let closeBtnY = self.bounds.size.height - closeBtnH
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: closeBtnX, y: closeBtnY, width: closeBtnW, height: closeBtnH)
            button.addTarget(self, action: #selector(closeButtonClick), for: UIControlEvents.touchUpInside)
            button.setImage(UIImage(named: "close"), for: UIControlState.normal)
            self.addSubview(button)
            return button
        }()
        
        //collection view
        let _: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 145, height: 145)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            
            let collectionViewW = self.bounds.size.width
            let collectionViewH = self.bounds.size.height - closeButton.frame.size.height
            let collectionViewX = CGFloat(0)
            let collectionViewY = CGFloat(0)
            let collectionViewFrame = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewW, height: collectionViewH)
            
            let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(CommandCollectionViewCell.self, forCellWithReuseIdentifier: commandCellID)
            collectionView.backgroundColor = UIColor.white
            self.addSubview(collectionView)
            return collectionView
        }()
        
    }
    
    @objc func closeButtonClick() {
        delegate.closeButtonClickCallback()
    }
}

extension CommandView: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: CommandCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: commandCellID, for: indexPath) as? CommandCollectionViewCell
        
        if cell == nil {
            cell = CommandCollectionViewCell()
        }
        
        cell?.model = dataSource[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataSource[indexPath.row]
        model.action()
    }
}

class CommandCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    var model: CommandModel! {
        didSet {

            if let image = UIImage(named: model.imageName) {
                imageView.image = image
            }
            label.text = model.title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //add label
        label = {
            let labelW = self.frame.size.width - 20
            let labelH = CGFloat(20.0)
            let labelX = CGFloat(10.0)
            let labelY = self.frame.size.height - 10 - labelH
            
            let _label = UILabel()
            _label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            _label.textAlignment = .center
            self.contentView.addSubview(_label)
            return _label
        }()
        
        //add imageView
        imageView = {
            let imageViewH = self.frame.size.width - 20 - label.frame.size.height
            let imageViewW = imageViewH
            let imageViewX = CGFloat(10.0)
            let imageViewY = CGFloat(10.0)
            
            let _imageView = UIImageView()
            _imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
            self.contentView.addSubview(_imageView)
            return _imageView
        }()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
