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
        button.imageView?.contentMode = .scaleAspectFit
//        button.titleEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
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
    
    
    var emojiView: UIImageView?
    
    var emojiContainerView : UIView = {
        
        let emojiPadding: CGFloat = 6
        let emojiHeight: CGFloat = 38
        
        let arrangedSubviews = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")].map { (image) -> UIImageView in
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: emojiHeight, height: emojiHeight)
            imageView.isUserInteractionEnabled = true
            return imageView
        }
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.spacing = CGFloat(emojiPadding)
        stackView.layoutMargins = UIEdgeInsetsMake(emojiPadding, emojiPadding, emojiPadding, emojiPadding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let width = (emojiPadding + emojiHeight) * CGFloat(arrangedSubviews.count) + emojiPadding
        let height = emojiHeight + (2 * emojiPadding)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        stackView.frame = view.frame
        stackView.layer.cornerRadius = 25
        stackView.clipsToBounds = true
        
        view.addSubview(stackView)
        view.backgroundColor = .white
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        
        return view
    }()
    
    @objc fileprivate func reactionHandler(_ imageView: UIImageView) {
        resetAnimatedEmoji(remove: true)
        likeButton.setImage(imageView.image, for: .normal)
    }
    
    @objc func tapHandler() {
        resetAnimatedEmoji(remove: true)
    }
    
    fileprivate func removeEmojiContainer() {
        emojiContainerView.removeFromSuperview()
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
        
    }
    
    @objc func longPressGestureHandler (_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            
            handleGestureBegan(gesture)
            
        } else if gesture.state == .ended {
            if let imageView = emojiView {
                reactionHandler(imageView)
            }
            resetAnimatedEmoji(remove: true)
            
        }else if gesture.state == .changed {
            
            handleGestureChanged(gesture)
            
        }
    }
    
    fileprivate func resetAnimatedEmoji(remove: Bool) {
       
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let stackView = self.emojiContainerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            if remove == true {
                self.emojiContainerView.alpha = 0
                self.emojiContainerView.transform = self.emojiContainerView.transform.translatedBy(x: 0, y: 50)
            }
        }, completion: { (_) in
            if remove == true {
                self.removeEmojiContainer()
            }
        })
    }
    
    fileprivate func handleGestureChanged (_ gr: UILongPressGestureRecognizer) {
        
        let pressedLocation = gr.location(in: emojiContainerView)
        
        let hitTestView = emojiContainerView.hitTest(CGPoint(x: pressedLocation.x, y: emojiContainerView.frame.height / 2), with: nil)
        if let hitTestView = hitTestView as? UIImageView {
            emojiView = hitTestView
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.resetAnimatedEmoji(remove: false)
                
                hitTestView.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
        
    }
    
    func handleGestureBegan(_ gesture: UILongPressGestureRecognizer) {
        contentView.addSubview(emojiContainerView)
        
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

