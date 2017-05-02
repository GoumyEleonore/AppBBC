//
//  ArticlesTableViewController.swift
//  AppEG
//
//  Created by Eléonore Goumy on 21/04/2017.
//  Copyright © 2017 Eléonore Goumy. All rights reserved.
//

import UIKit


class ArticlesCell : UITableViewCell {
    
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    
    
    
}


class ArticlesTableViewController: UITableViewController {

 
    var listOfArticles = NSArray()
 
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        self.refreshControl?.addTarget(self,
                                       action:#selector(handleRefresh(refreshControl:)),
                                       for: UIControlEvents.valueChanged)

        bbcApi.getBBCSportsArticles() {
            (result: NSDictionary) in
            self.listOfArticles = result["articles"] as! NSArray
            print(self.listOfArticles.count)
            self.tableView.reloadData()
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        bbcApi.getBBCSportsArticles() {
            (result: NSDictionary) in
            self.listOfArticles = result["articles"] as! NSArray
            print(self.listOfArticles.count)
            self.tableView.reloadData()
            refreshControl.endRefreshing()

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Featured Articles"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(self.listOfArticles.count)
        return self.listOfArticles.count
    }

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ArticlesCell
        
        let myItem = self.listOfArticles[indexPath.row] as! NSDictionary
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = dateFormatter.date(from: myItem["publishedAt"] as! String)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            date = dateFormatter.date(from: myItem["publishedAt"] as! String)
            
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from:date!)
        
        cell.titleLabel.text = myItem["title"] as? String
        cell.DateLabel.text = dateString
        cell.abstractLabel.text = myItem["description"] as? String
        if ((myItem["urlToImage"] as? NSString) != nil) {
            bbcApi.downloadImage(url: (myItem["urlToImage"] as! String)) {
                (result: UIImage) in
                cell.imageArticle.image = result
            }
        }
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" ,
            let nextScene = segue.destination as? DetailViewController ,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedArticle = self.listOfArticles[indexPath.row] as! NSDictionary
                        
                nextScene.articleTitle = selectedArticle["title"] as! String
                nextScene.articleAuthor = selectedArticle["author"] as! String
                nextScene.articleAbstract = selectedArticle["description"] as! String
                nextScene.articleUrlImage = selectedArticle["urlToImage"] as! String
                nextScene.articleUrl = selectedArticle["url"] as! String
            
            /// date Formatter
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                var date = dateFormatter.date(from: selectedArticle["publishedAt"] as! String)
                if date == nil {
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    date = dateFormatter.date(from: selectedArticle["publishedAt"] as! String)
                }
                nextScene.articleDate = date! as NSDate
                nextScene.mainController = self.navigationController!
        }

    }
    

}
