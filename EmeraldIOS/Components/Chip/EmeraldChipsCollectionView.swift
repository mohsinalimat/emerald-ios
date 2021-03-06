//
//  EmeraldChipsUICollectionView.swift
//  EmeraldIOS
//
//  Created by Sergio Giraldo on 7/24/19.
//  Copyright © 2019 Condor Labs. All rights reserved.
//

import UIKit

public protocol EmeraldChipDelegate: AnyObject {
    func dissmisableChipDidTaped()
}

public protocol EmeraldChipCollectionViewType {
    func addNewChip(with viewModel: ChipViewModel)
    func getValues() -> [String]
    func isEmpty() -> Bool
    func setDelegate(_ delegate: EmeraldChipDelegate)
}

public struct ChipViewModel {
    var text: String
    var type: EmeraldChipStyle

    public init(text: String, type: EmeraldChipStyle) {
        self.text = text
        self.type = type
    }
}

public class EmeraldChipsCollectionView: UICollectionView {

    struct InnerConstant {
        static let reuseIdentifier = "Cell"
    }

    weak var chipDelegate: EmeraldChipDelegate?
    private var chips: [ChipViewModel] = []

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func updateView() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionViewLayout = layout

        self.delegate = self
        self.dataSource = self
        self.register(EmeraldChipCollectionViewCell.self, forCellWithReuseIdentifier: InnerConstant.reuseIdentifier)
    }
}

extension EmeraldChipsCollectionView: EmeraldChipCollectionViewType {
    public func getValues() -> [String] {
        return self.chips.map({ $0.text })
    }

    public func isEmpty() -> Bool {
        return self.chips.isEmpty
    }

    public func addNewChip(with viewModel: ChipViewModel) {
        chips.append(viewModel)
        self.updateView()
    }
    
    public func setDelegate(_ delegate: EmeraldChipDelegate) {
        self.chipDelegate = delegate
    }
}

extension EmeraldChipsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chips.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InnerConstant.reuseIdentifier, for: indexPath) as! EmeraldChipCollectionViewCell

        let chipViewModel = self.chips[indexPath.row]
        cell.setupChip(with: chipViewModel.text, and: chipViewModel.type)
        cell.delegate = self
        return cell
    }
}

extension EmeraldChipsCollectionView: ChipCellDismissable {
    func chipDismissTapped(_ cell: EmeraldChipCollectionViewCell) {
        guard let indexPath = self.indexPath(for: cell) else {
            return
        }

        self.chips.remove(at: indexPath.row)
        self.deleteItems(at: [indexPath])
        self.chipDelegate?.dissmisableChipDidTaped()
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0

        attributes?.forEach({ layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        })

        return attributes
    }
}
