//
//  ViewController.swift
//  Browser
//
//  Created by Andreas Ziemer on 14.10.15.
//  Copyright © 2015 drui. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var myWebViewDelegate: UIWebViewDelegate!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var tableView: UITableView!

    let zechTags = ["Oktoberfest","München"]
    var favourites = [FavouritesModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        myWebViewDelegate = WebViewDelegate()
        myWebView.delegate = myWebViewDelegate
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadLink(sender: UITextField) {
        var murl = sender.text
        
        if (!validateUrl(murl!))
        {
                murl = "https://www.google.de/webhp?hl=de&q=yxc#hl=de&q=" + murl!
        }
        
        let url = NSURL(string: murl!)
        let request = NSURLRequest(URL: url!)
        print(request)
        myWebView.loadRequest(request)
        myWebView.scalesPageToFit = true
    }
    
    func validateUrl (stringURL : NSString) -> Bool
    {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluateWithObject(stringURL)
    }
    
    func validateWWW (stringURL : NSString) -> Bool
    {
        let urlRegEx = "(((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluateWithObject(stringURL)
    }

    @IBAction func favouriteButton(sender: AnyObject)
    {
        let alertSheetController = UIAlertController(title: "Favoriten hinzufügen", message: "Geben Sie den Titel ein", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
        {
            action-> Void in
            print("Cancel")
                
        }
        
        alertSheetController.addAction(cancelAction)
        
        let enterAction = UIAlertAction(title: "Enter", style: .Default)
        {
                action-> Void in
            
            let textfield : UITextField = alertSheetController.textFields![0]
            let fav = FavouritesModel()

            self.favourites.append(fav)

            fav.title = textfield.text!
            fav.url = self.addressBar.text!
            
        }

        alertSheetController.addAction(enterAction)
        
        let editBookmarks = UIAlertAction(title: "Lesezeichen verwalten", style: .Default)
        {
                action-> Void in
            
            self.performSegueWithIdentifier("editBookmarks",sender:self)
                
                
        }
        
        alertSheetController.addAction(editBookmarks)
        
        alertSheetController.addTextFieldWithConfigurationHandler
        {
            textField -> Void in
            textField.placeholder="Titel"
        }
        
        alertSheetController.addTextFieldWithConfigurationHandler
        {
                textField -> Void in
                textField.placeholder="URL"
                textField.text = self.addressBar.text
        }

        self.presentViewController(alertSheetController, animated: true) {}
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "editBookmarks"
        {
            let destVC = segue.destinationViewController as! FavouriteTableViewController
            destVC.favourites = favourites
        }
    }
    
    @IBAction func reloadButton(sender: AnyObject)
    {
         myWebView.reload()
    }
    
    @IBAction func forwardButton(sender: AnyObject)
    {
        myWebView.goForward()
    }

    @IBAction func backButton(sender: AnyObject)
    {
        myWebView.goBack()
    }
  
    
    @IBAction func homeBtn(sender: AnyObject)
    {
        let homeUrl = "https://www.google.de"
        let url = NSURL(string: homeUrl)
        let request = NSURLRequest(URL: url!)
        myWebView.loadRequest(request)
        myWebView.scalesPageToFit = true
    }
    
    //Table View Methods:
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return zechTags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ZechCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = zechTags[indexPath.row]
        
        return cell
    }
    
    //forward SechTag to other Group
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        print("Zech Tag:   \(zechTags[row]) ")
    }
    
}

