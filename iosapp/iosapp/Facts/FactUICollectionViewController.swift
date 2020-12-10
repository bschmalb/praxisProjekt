//
//  CustomUICollectionView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.12.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import Foundation
import SwiftUI


class FactUICollectionViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @EnvironmentObject var filterString: FilterStringFacts
    
    var cardColors: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var facts: [Fact] = []
    var offlineFacts: [Fact] = []
    var user: User = User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    var filter: [String] = []
    var loaded: Bool = false
    let group = DispatchGroup()
    var count = 0
    
    var collectionView: UICollectionView!
    
    
    convenience init(filter: [String]) {
        print(filter)
        self.init(nibName:nil, bundle:nil)
        do {
            let storedObjTipp = UserDefaults.standard.object(forKey: "offlineFacts")
            if storedObjTipp != nil {
                self.facts = try JSONDecoder().decode([Fact].self, from: storedObjTipp as! Data)
                print("Retrieved Tipps: filteredFacts")
            }
        } catch let err {
            print(err)
        }
        
        FactApi().fetchApproved(filter: filter) { (facts) in
            self.facts = facts
            UserApi().fetchUser { user in
                self.user = user
                self.collectionView.reloadData()
                
                for (i, _) in facts.enumerated() {
                    if (i < 10 && (facts.count > i)) {
                        self.offlineFacts.append(facts[i])
                    }
                    else {
                        break
                    }
                }
                if let encoded = try? JSONEncoder().encode(self.offlineFacts) {
                    UserDefaults.standard.set(encoded, forKey: "offlineFacts")
                    print("Tipps saved")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "factCell", for: indexPath) as! HostingTableViewCell<FactCard>
        collectionCell.prepareForReuse()
        collectionCell.host(
            FactCard(
                fact: facts[indexPath.row],
                color: cardColors[indexPath.row % cardColors.count],
                user: user
                ), parent: self)
        return collectionCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView2 = scrollView as? UICollectionView {
            for cell in collectionView2.visibleCells as! [HostingTableViewCell<FactCard>] {
                let indexPath = collectionView2.indexPath(for: cell)!
                let attributes = collectionView2.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView2.convert(attributes.frame, to: view)
                
//                let translationX = CGFloat(12.0)
//                cell.transform = CGAffineTransform(translationX: translationX, y: 0)
                
                let angleFromX = Double((-cellFrame.origin.x) / 5)
                let angle = CGFloat((angleFromX * Double.pi) / 180.0)
                var transform = CATransform3DIdentity
                transform.m34 = -1.0/500
                let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
                cell.layer.transform = rotation
                
//                var scaleFromX = (1000 - (cellFrame.origin.x)) / 1000
//                let scaleMax: CGFloat = 1.0
//                let scaleMin: CGFloat = 0.1
//                if scaleFromX > scaleMax {
//                    scaleFromX = scaleFromX - (2 * (scaleFromX - 1))
//                }
//                if scaleFromX < scaleMin {
//                    scaleFromX = scaleMin
//                }
////                let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
//                let scale = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
//                cell.layer.transform = CATransform3DConcat(rotation, scale)
            }
        }
    }
    
    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: UIScreen.main.bounds.height/2.1 + 20)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(HostingTableViewCell<FactCard>.self, forCellWithReuseIdentifier: "factCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2.1 + 20).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

struct FactUICollectionViewWrapper<Content: View>: UIViewControllerRepresentable {
    
    @EnvironmentObject var filterString: FilterStringFacts
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> FactUICollectionViewController {
        let vc = FactUICollectionViewController(filter: filterString.filterString)
        vc.hostingController.rootView = AnyView(self.content().environmentObject(FilterStringFacts()))
        return vc
    }
    
    func updateUIViewController(_ viewController: FactUICollectionViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(self.content().environmentObject(FilterStringFacts()))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
