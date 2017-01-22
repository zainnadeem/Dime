//
//  ChatViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 1/12/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SAMCache
import OneSignal

class ChatViewController: JSQMessagesViewController {
    
    var chat: Chat!
    var currentUser: User!
    
    var messagesReference = DatabaseReference.messages.reference()
    
    var messages = [Message]()
    var jsqMessages = [JSQMessage]()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var outgoingAvatarImageView: JSQMessagesAvatarImage!
    var incomingAvatarImageView: JSQMessagesAvatarImage!
    
    let cache = SAMCache.shared()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "iconFeed"), leftButtonImage: #imageLiteral(resourceName: "icon-home"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chat.title
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.setUpBubbleImages()
        self.setUpAvatarImages()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.observeMessages()
        downloadProfileImages()
    }
    
    func back(_ sender: UIBarButtonItem){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if self.presentingViewController == ContactsPickerViewController(){
            self.navigationController?.popToViewController(ChatsTableViewController(), animated: true)
        }
        
            self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Download Images for Avatars
    func downloadProfileImages(){
        
        for chatMember in chat.users{
        
        //profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")

        let profileImageViewKey = "\(chatMember.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageViewKey) as? UIImage  {
            
           let jsqImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            if chatMember == self.currentUser{ self.outgoingAvatarImageView = jsqImage }else{
                self.incomingAvatarImageView = jsqImage
            }
      
            //self.profileImageView.image = image
       
        }else{
            
            chatMember.downloadProfilePicture { (image, error) in
                let jsqImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
                if chatMember == self.currentUser{ self.outgoingAvatarImageView = jsqImage }else{
                    self.incomingAvatarImageView = jsqImage
                }
                self.cache?.setObject(image, forKey: profileImageViewKey)
  
            }
            
        }
        
        }
    }
    

    // MARK: - Avatar
    
    func setUpBubbleImages(){
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.black)
        incomingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
    }
    
    func setUpAvatarImages(){
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


// MARK: - JSQMessagesViewControllerDataSource

extension ChatViewController{
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            cell.textView?.textColor = UIColor.white
            
        }else{
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId{
            return outgoingBubbleImageView
        }else{
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {

        
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            return outgoingAvatarImageView
            
        }else{
            return incomingAvatarImageView
        }

    }
    
    
}

// MARK: - Send Messages

extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if chat.messageIds.count == 0 {
            chat.save()
            
            for account in chat.users{
                account.save(new: chat)
            }
        }
    
    let newMessage = Message(senderUID: currentUser.uid, senderDisplayName: currentUser.fullName, type: "text", text: text)
        newMessage.save()
        chat.send(message: newMessage)
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        finishSendingMessage()
    
    

    let recipientUsers = chat.users.filter() { $0 != self.currentUser }
    
        for recipient in recipientUsers {
    
    for id in recipient.deviceTokens{
        OneSignal.postNotification(["contents" : ["en" :"\(self.currentUser.username): \(newMessage.text)"], "headings" : ["en" : "Message"], "include_player_ids" : [id]])
            }
        }
    }
    
}

extension ChatViewController
{
    
  func observeMessages(){
        
        let chatMessageIdsRef = chat.ref.child("messageIds")
        chatMessageIdsRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.value as! String
            DatabaseReference.messages.reference().child(messageId).observe(.value, with: { (snapshot) in
                let message = Message(dictionary: snapshot.value as! [String : Any])
                self.messages.append(message)
                self.add(message)
                self.finishReceivingMessage()
            })
        })
        
    }
    
    func add(_ message: Message){
        if message.type == MessageType.text{
            let jsqMessage = JSQMessage(senderId: message.senderUID, displayName: message.senderDisplayName, text: message.text)
            jsqMessages.append(jsqMessage!)
        }
    }
    
    
}


    










