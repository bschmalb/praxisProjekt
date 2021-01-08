//
//  CustomUICollectionView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 09.12.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import Foundation
import SwiftUI


class TippUICollectionViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cardColors: [String]  = [
        "cardgreen2", "cardblue2", "cardyellow2", "cardpurple2", "cardorange2", "cardred2", "cardturqouise2", "cardyelgre2", "cardpink2"
    ]
    
    var tipps: [Tipp] = []
    var offlineTipps: [Tipp] = []
    var user: User = User(_id: "", phoneId: "", checkedTipps: [], savedTipps: [], savedFacts: [], log: [])
    var filter: [String] = []
    var firstLoad: Bool = true
    var loading = true
    
    var noTippsAvailable = true
    
    var collectionView: UICollectionView!
    
    convenience init(filter: [String], firstLoad: Bool) {
        self.init(nibName:nil, bundle:nil)
        
        do {
            let storedObjTipp = UserDefaults.standard.object(forKey: "offlineTipps")
            if storedObjTipp != nil {
                self.tipps = try JSONDecoder().decode([Tipp].self, from: storedObjTipp as! Data)
                if firstLoad {
                    loading = false
                    self.noTippsAvailable = false
                }
                print("Retrieved Tipps: filteredTipps")
            }
        } catch let err {
            print(err)
        }
        
        TippApi().fetchApproved(filter: filter) { (filteredTipps) in
            self.tipps = filteredTipps
            UserApi().fetchUser { user in
                self.user = user
                if self.tipps.count > 0 {
                    self.noTippsAvailable = false
                }
                self.loading = false
                self.collectionView.reloadData()
                
                for (i, _) in filteredTipps.enumerated() {
                    if (i < 10 && (filteredTipps.count > i)) {
                        self.offlineTipps.append(filteredTipps[i])
                    }
                    else {
                        break
                    }
                }
                if let encoded = try? JSONEncoder().encode(self.offlineTipps) {
                    UserDefaults.standard.set(encoded, forKey: "offlineTipps")
                    print("Tipps saved")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loading ? 1 : tipps.count > 0 ? tipps.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! HostingTableViewCell<TippCard2>
        collectionCell.prepareForReuse()
        if loading {
            collectionCell.host(
                TippCard2(
                    user: user,
                    tipp: Tipp(_id: "", title: "Für deine ausgewählten Kategorien gibt es aktuell leider noch keine Tipps.\n\nWähle weitere Filter aus um Tipps zu sehen.", source: "", level: "", category: "", score: 300, postedBy: "", official: ""),
                    color: cardColors[indexPath.row % cardColors.count],
                    loaded: false),
                parent: self)
        } else {
            if !noTippsAvailable {
                collectionCell.host(
                    TippCard2(
                        user: user,
                        tipp: tipps[indexPath.row],
                        color: cardColors[indexPath.row % cardColors.count]),
                    parent: self)
            } else {
                collectionCell.host(
                    TippCard2(
                        user: user,
                        tipp: Tipp(_id: "", title: "Für deine ausgewählten Kategorien gibt es aktuell leider noch keine Tipps.\n\nWähle weitere Filter aus um Tipps zu sehen.", source: "", level: "", category: "", score: 300, postedBy: "", official: ""),
                        color: "background",
                        isTipp: false),
                    parent: self)
            }
        }
        return collectionCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView2 = scrollView as? UICollectionView {
            for cell in collectionView2.visibleCells as! [HostingTableViewCell<TippCard2>] {
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
        collectionView.register(HostingTableViewCell<TippCard2>.self, forCellWithReuseIdentifier: "collectionViewCell")
        
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

struct TippUICollectionViewWrapper<Content: View>: UIViewControllerRepresentable {
    
    @EnvironmentObject var filterString: FilterString
    @EnvironmentObject var firstLoad: FirstLoad
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> TippUICollectionViewController {
        let vc = TippUICollectionViewController(filter: filterString.filterString, firstLoad: firstLoad.firstLoad)
        vc.hostingController.rootView = AnyView(self.content().environmentObject(FilterString()))
        print(firstLoad.firstLoad)
        self.firstLoad.firstLoad = false
        return vc
    }
    
    func updateUIViewController(_ viewController: TippUICollectionViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(self.content().environmentObject(FilterString()))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
