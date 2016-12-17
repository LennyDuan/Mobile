//
//  GuideViewSecond.swift
//  ViewDemo
//
//  Created by 段鸿易 on 3/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class GuideViewSecond: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var urlText: UITextField!
    
    @IBAction func urlConfirm(sender: AnyObject) {
        let url : String
        url = urlText.text!
        downloadJson(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Download Json from a url and save to core data
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    func downloadJson(url: String) {
        print(url)
    
        let requestURL: NSURL = NSURL(string: url)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")

                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let words = json["wordpairs"] as? [[String: AnyObject]] {
                        let context = self.context
                        let ent = NSEntityDescription.entityForName("WordPhrasePair", inManagedObjectContext: context)
                        
                        for word in words {
                            if let english = word["wordPhraseOne"] as? String {
                                if let welsh = word["wordPhraseTwo"] as? String {
                                    if let note = word["note"] as? String {
                                        if let type = word["type"] as? String {
                                            print(english + " " + welsh + " " + note + " " + type + " ")

                                            var nItem = WordPhrasePair(entity: ent!, insertIntoManagedObjectContext: context)
                                            
                                            nItem.setValue(english, forKey: "english")
                                            nItem.setValue(welsh, forKey: "welsh")
                                            nItem.setValue(note, forKey: "note")
                                            nItem.setValue(type, forKey: "type")
                                            do {
                                                try context.save()
                                            }
                                            catch {
                                            }

                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
       
            }
            
        }
        
        task.resume()
        urlText.text = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
