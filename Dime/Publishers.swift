//
//
//  Created by Zain Nadeem on 11/05/16.
//

import UIKit

class PublishersStore
{
    // MARK: - Public API
    
    var numberOfPublishers: Int {
        return publishers.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    init() {
        publishers = createPublishers()
        sections = ["My Favorites", "Politics", "Travel", "Technology"]
    }
    
    func numberOfPublishers(inSection section: Int) -> Int {
        let publishers = self.publishers(forSection: section)
        return publishers.count
    }
    
    func publisherForItem(atIndexPath indexPath: IndexPath) -> Publisher?
    {
        if indexPath.section > 0 {
            let publishers = self.publishers(forSection: indexPath.section)
            return publishers[indexPath.item]
        } else {
            return publishers[indexPath.item]
        }
    }
    
    func titleForSection(atIndexPath indexPath: IndexPath) -> String?
    {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        
        return nil
    }
    
    // MARK: - Private
    // Collection View / Table View - section & cells
    private var publishers = [Publisher]()
    private var sections = [String]()
    
    private func createPublishers() -> [Publisher]
    {
        var newPublishers = [Publisher]()
        
        newPublishers += MyFavorites.publishers()
        newPublishers += Politics.publishers()
        newPublishers += Travel.publishers()
        newPublishers += Technology.publishers()
        
        return newPublishers
    }
    
    private func publishers(forSection section: Int) -> [Publisher]
    {
        let section = sections[section]
        let publishersInSection = publishers.filter { (publisher: Publisher) -> Bool in
            return publisher.section == section
        }
        
        return publishersInSection
    }
}

class MyFavorites
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "TIME", url: "http://time.com", image: UIImage(named: "t1")!, section: "My Favorites"))
        publishers.append(Publisher(title: "The New York Times", url: "http://www.nytimes.com", image: UIImage(named: "t2")!, section: "My Favorites"))
        publishers.append(Publisher(title: "TED", url: "https://www.ted.com", image: UIImage(named: "t3")!, section: "My Favorites"))
        publishers.append(Publisher(title: "Re/code", url: "http://recode.net", image: UIImage(named: "t4")!, section: "My Favorites"))
        publishers.append(Publisher(title: "WIRED", url: "http://www.wired.com", image: UIImage(named: "t5")!, section: "My Favorites"))
        return publishers
    }
}

class Politics
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "The Atlantic", url: "http://www.theatlantic.com", image: UIImage(named: "t1")!, section: "Politics"))
        publishers.append(Publisher(title: "The Hill", url: "http://thehill.com", image: UIImage(named: "t2")!, section: "Politics"))
        publishers.append(Publisher(title: "Daily Intelligencer", url: "http://nymag.com/daily/intelligencer/", image: UIImage(named: "t3")!, section: "Politics"))
        publishers.append(Publisher(title: "Vanity Fair", url: "http://recode.net", image: UIImage(named: "t4")!, section: "Politics"))
        publishers.append(Publisher(title: "TIME", url: "http://time.com", image: UIImage(named: "t5")!, section: "Politics"))
        publishers.append(Publisher(title: "The Huffington Post", url: "http://www.huffingtonpost.com", image: UIImage(named: "t6")!, section: "Politics"))
        return publishers
    }
}

class Travel
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "AFAR", url: "http://www.afar.com", image: UIImage(named: "t1")!, section: "Travel"))
        publishers.append(Publisher(title: "The New York Times", url: "http://www.nytimes.com", image: UIImage(named: "t2")!, section: "Travel"))
        publishers.append(Publisher(title: "Men’s Journal", url: "http://www.mensjournal.com", image: UIImage(named: "t3")!, section: "Travel"))
        publishers.append(Publisher(title: "Smithsonian", url: "http://www.smithsonianmag.com/?no-ist", image: UIImage(named: "t4")!, section: "Travel"))
        publishers.append(Publisher(title: "Wallpaper", url: "http://www.wallpaper.com", image: UIImage(named: "t5")!, section: "Travel"))
        publishers.append(Publisher(title: "Sunset", url: "http://www.sunset.com", image: UIImage(named: "t6")!, section: "Travel"))
        return publishers
    }
}

class Technology
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "WIRED", url: "http://www.wired.com", image: UIImage(named: "t1")!, section: "Technology"))
        publishers.append(Publisher(title: "Re/code", url: "http://recode.net", image: UIImage(named: "t2")!, section: "Technology"))
        publishers.append(Publisher(title: "Quartz", url: "http://qz.com", image: UIImage(named: "t5")!, section: "Technology"))
        publishers.append(Publisher(title: "Daring Fireball", url: "http://daringfireball.net", image: UIImage(named: "t3")!, section: "Technology"))
        publishers.append(Publisher(title: "MIT Technology Review", url: "http://www.technologyreview.com", image: UIImage(named: "t4")!, section: "Technology"))
        return publishers
    }
}















