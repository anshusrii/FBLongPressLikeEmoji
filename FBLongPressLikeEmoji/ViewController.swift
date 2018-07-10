//
//  ViewController.swift
//  FBLongPressLikeEmoji
//
//  Created by Sudhanshu Srivastava on 10/07/18.
//  Copyright © 2018 Sudhanshu Srivastava. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 244)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionLayout)
        collectionView?.dataSource = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        
        view.addSubview(collectionView!)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 244)
    }
    
}

enum ReactionButtonTag: Int {
    case blueLike
    case redHeart
    case laugh
    case surprised
    case cry
    case angry
}


class FeedCell: UICollectionViewCell {
    static var identifier = {
        return String.init(describing: self)
    }()
    
    
    let imageView : UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let likeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.gray, for: .normal)
        button.setTitle("Like", for: .normal)
        button.titleLabel?.textColor = .gray
        button.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        return button
    }()
    
    let commentButton : UIButton = {
        let button = UIButton(type: .custom)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.gray, for: .normal)
        button.setTitle("Comment", for: .normal)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        return button
    }()
    
    let blueLikeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.tag = ReactionButtonTag.blueLike.rawValue
        button.setImage(#imageLiteral(resourceName: "blue_like"), for: .normal)
        return button
    }()
    
    let redHeartButton : UIButton = {
        let button = UIButton(type: .custom)
        button.tag = ReactionButtonTag.redHeart.rawValue
        button.setImage(#imageLiteral(resourceName: "red_heart"), for: .normal)
        return button
    }()
    
    let laughButton : UIButton = {
        let button = UIButton(type: .custom)
        button.tag = ReactionButtonTag.laugh.rawValue
        button.setImage(#imageLiteral(resourceName: "cry_laugh"), for: .normal)
        return button
    }()
    
    let surprisedButton : UIButton = {
        let button = UIButton(type: .custom)
        button.tag = ReactionButtonTag.surprised.rawValue
        button.setImage(#imageLiteral(resourceName: "surprised"), for: .normal)
        return button
    }()
    
    let cryButton : UIButton = {
        let button = UIButton(type: .custom)
        button.tag = ReactionButtonTag.cry.rawValue
        button.setImage(#imageLiteral(resourceName: "cry"), for: .normal)
        return button
    }()
    
    let angryButton : UIButton = {
        let button = UIButton(type: .custom)
        button.tag = ReactionButtonTag.angry.rawValue
        button.setImage(#imageLiteral(resourceName: "angry"), for: .normal)
        return button
    }()
    
    var emojiContainerView : UIStackView!
    var overlayView: UIView!
    
    fileprivate func setupEmojiContainer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        overlayView = UIView(frame: contentView.frame)
        overlayView.isUserInteractionEnabled = true
        overlayView.backgroundColor = .clear
        overlayView.addGestureRecognizer(tapGesture)
        
        blueLikeButton.addTarget(self, action: #selector(reactionHandler), for: .touchUpInside)
        redHeartButton.addTarget(self, action: #selector(reactionHandler), for: .touchUpInside)
        laughButton.addTarget(self, action: #selector(reactionHandler), for: .touchUpInside)
        surprisedButton.addTarget(self, action: #selector(reactionHandler), for: .touchUpInside)
        cryButton.addTarget(self, action: #selector(reactionHandler), for: .touchUpInside)
        angryButton.addTarget(self, action: #selector(reactionHandler), for: .touchUpInside)
        
        
        
        emojiContainerView = UIStackView(arrangedSubviews: [blueLikeButton, redHeartButton, laughButton, surprisedButton, cryButton, angryButton])
        
        emojiContainerView.backgroundColor = .white
        emojiContainerView.distribution = .fillProportionally
        emojiContainerView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        
        emojiContainerView.layer.cornerRadius = 25
        emojiContainerView.clipsToBounds = true
    }
    
    @objc fileprivate func reactionHandler(_ button: UIButton) {
        removeEmojiContainer()
        print("button.tag: \(button.tag)")
        likeButton.setImage(button.currentImage, for: .normal)
    }
    
    @objc func tapHandler() {
        removeEmojiContainer()
    }
    
    fileprivate func removeEmojiContainer() {
        emojiContainerView.removeFromSuperview()
        overlayView.removeFromSuperview()
    }
    
    fileprivate func setupFooterView() {
        likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler))
        likeButton.addGestureRecognizer(longPressGesture)
        
        commentButton.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton])
        stackView.backgroundColor = .white
        stackView.frame = CGRect(x: 0,y: 200,width: contentView.frame.width,height: 44)
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        contentView.addSubview(stackView)
    }
    
    func configureCell () {
        
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 200)
        contentView.addSubview(imageView)
        
        setupFooterView()
        setupEmojiContainer()
        
    }
    
    @objc func longPressGestureHandler (_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture)
        } else if gesture.state == .ended {
//            emojiContainerView.removeFromSuperview()
//            overlayView.removeFromSuperview()
        }
    }
    
    func handleGestureBegan(_ gesture: UILongPressGestureRecognizer) {
        contentView.addSubview(overlayView)
        overlayView.addSubview(emojiContainerView)
        
        let pressedLocation = gesture.location(in: contentView)
        let centeredX = (contentView.frame.width - emojiContainerView.frame.width) / 2
        
        emojiContainerView.alpha = 0
        emojiContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.emojiContainerView.alpha = 1
            self.emojiContainerView.transform = CGAffineTransform(translationX: centeredX, y: (pressedLocation.y - self.emojiContainerView.frame.height))
        })
    }
    
    @objc func likeAction()  {
        
    }
    
    @objc func commentAction()  {
        
    }
}

