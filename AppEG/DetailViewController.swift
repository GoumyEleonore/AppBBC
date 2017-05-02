//
//  DetailViewController.swift
//  AppEG
//
//  Created by Eléonore Goumy on 22/04/2017.
//  Copyright © 2017 Eléonore Goumy. All rights reserved.
//

import UIKit
import MRArticleViewController
import QuickRippleButton
import CoreData
import Foundation

class DetailViewController: ArticleViewController {

    
    var articleTitle = String()
    var articleAbstract = String()
    var articleAuthor = String()
    var articleUrlImage = String()
    var articleUrl = String()
    var articleDate = NSDate()
    var mainController = UINavigationController()
    
    
    override func viewDidLoad() {
        
        if ((articleUrlImage as NSString) != nil) {
            bbcApi.downloadImage(url: self.articleUrlImage) {
                (result: UIImage) in
                self.autoColored = true
                self.imageView.image = result
                self.headline = self.articleTitle
                self.author = self.articleAuthor
                self.date = self.articleDate as Date
                self.body = "\(self.articleAbstract) \("\n") \("\n") \(self.articleUrl)"
                super.viewDidLoad()
            }
            
            let favButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.bookmarks,
                                                 target: self,
                                                 action: #selector(save(_:)))
            
            let shareButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                   target: self,
                                                   action: #selector(share(_:)))
            self.navigationItem.rightBarButtonItems = [favButton, shareButton]

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(_ sender: UIButton) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate!
        let managedObject = appDelegate?.persistentContainer.viewContext
        let article = NSEntityDescription.insertNewObject(forEntityName: "Article", into: managedObject!) as! Article
        article.abstract = self.articleAbstract
        article.author = self.articleAuthor
        article.url = self.articleUrl
        article.title = self.articleTitle
        article.date = self.articleDate
        article.image = self.articleUrlImage
        do {
            appDelegate?.saveContext()
            try managedObject?.save()
            print("OK")
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func share(_ sender: UIButton) {
        let textToShare = [ self.articleUrl ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
