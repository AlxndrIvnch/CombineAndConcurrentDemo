//
//  UploadingStatisticView.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 28.03.2023.
//

import UIKit

class StatisticView: BaseView {
    @IBOutlet weak var uploadedCountLabel: UILabel!
    @IBOutlet weak var allCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    private var viewModel: StatisticVM!
    
    func setup(with viewModel: StatisticVM) {
        uploadedCountLabel.text = viewModel.uploadedCount
        allCountLabel.text = viewModel.allCount
        timeLabel.text = viewModel.time
    }
}
