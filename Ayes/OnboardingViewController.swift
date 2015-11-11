//
//  OnboardingViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
  
  @IBOutlet weak var pageViewControllerContainer: UIView!
  @IBOutlet weak var skipButton: UIButton!
  
  private let numberOfPages = 4
  
  struct PageContent {
    var imageName: String
    var text: String
    var image: UIImage? {
      return UIImage(named: imageName)
    }
  }
  
  let content = [
    PageContent(imageName: "tutorial1", text: "Вы можете отвечать на интересные вопросы и видеть, как ответили другие люди, похожие на вас и не очень."),
    PageContent(imageName: "tutorial2", text: "Один вопрос - один клик \"да\" или \"нет\". Ответы людей могут удивить вас"),
    PageContent(imageName: "tutorial3", text: "Что думают люди? Много ли у вас единомышленников? Один клик и вы получите ответ.")
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
  }
  
  //MARK - IBActions
  
  @IBAction func skipButtonAction(sender: AnyObject) {
//    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? UIPageViewController
        where segue.identifier == "embedSegue" {
          
      destination.dataSource = self
      destination.delegate = self
      
      if let initialViewController = viewControllerAtIndex(0) {
        destination.setViewControllers([initialViewController],
            direction: .Forward, animated: false, completion: nil)
      }
    }
  }
}

//MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
  
  func viewControllerAtIndex(index: Int) -> UIViewController? {
    
    if index < 0 || index >= numberOfPages {
      return nil
    }
    
    if index == numberOfPages - 1 {
      let finalViewController = storyboard?.instantiateViewControllerWithIdentifier("FinalViewController") as! FinalViewController
      finalViewController.index = index
      return finalViewController
    }
    
    let viewContoller = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
    viewContoller.index = index
    viewContoller.view.backgroundColor = UIColor.tutorialBackgroundColor()

    let pageContent = content[index]
    viewContoller.contentImageView.image = pageContent.image
    viewContoller.contentLabel.text = pageContent.text
    
    return viewContoller
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    guard let page = viewController as? OnboardingPageContent else {
      return nil
    }
    
    return viewControllerAtIndex(page.index + 1)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    guard let page = viewController as? OnboardingPageContent else {
      return nil
    }
    
    return viewControllerAtIndex(page.index - 1)
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return numberOfPages
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
}

//MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
}