//
//  MovieCardCVC.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit
import RxSwift

final class MovieCardCVC: UICollectionViewCell, ReuseIdentifying {

    var disposeBag = DisposeBag()

    private let gradientView = UIView()
        .backgroundColor(.clear).with {
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.layer.cornerRadius = 20
        }

    private let bannerView = UIImageView()
        .backgroundColor(.gray.withAlphaComponent(0.3)).with {
            $0.layer.cornerRadius = 20
        }

    private let titleLabel = UILabel()
        .numberOfLines(2)
        .textColor(.white)
        .font(.boldSystemFont(ofSize: 16))

    private let typeLabel = UILabel()
        .numberOfLines(1)
        .textColor(.white)
        .font(.systemFont(ofSize: 12))

    private let yearLabel = UILabel()
        .numberOfLines(1)
        .textColor(.white)
        .font(.systemFont(ofSize: 12))

    private lazy var typeYearSV = UIStackView()
        .axis(.horizontal)
        .distribution(.fillEqually)
        .spacing(4)
        .addArrangedSubviews {
            typeLabel
            yearLabel
        }

    private lazy var mainSV = UIStackView()
        .axis(.vertical)
        .distribution(.fill)
        .spacing(4)
        .addArrangedSubviews {
            titleLabel
            typeYearSV
        }

    lazy var cardView = UIView {
            bannerView
            gradientView
            mainSV
        }
        .backgroundColor(.black)
        .cornerRadius(20)


    var viewModel: MovieCardCVCViewModel! {
        didSet {
            updateViewValues()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        DispatchQueue.main.async {
            let gradient = CAGradientLayer().with {
                $0.frame = self.gradientView.bounds
                $0.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                $0.cornerRadius = 20
            }
            self.gradientView.layer.insertSublayer(gradient, at: 0)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setuplayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helper Views
extension MovieCardCVC {

    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubviews {
            cardView
        }
    }

    private func setuplayouts() {
        bannerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
        }

        mainSV.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(cardView).inset(12)
            make.bottom.equalTo(cardView).inset(16)
        }

        gradientView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(cardView)
            make.top.equalTo(mainSV).offset(-100)
        }

        cardView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(contentView)
        }
        
        layoutIfNeeded()
    }

    /// Update values used by view
    private func updateViewValues() {
        titleLabel.text(viewModel.title)
        typeLabel.text(viewModel.type)
        yearLabel.text(viewModel.year)
        bannerView.loadImageFrom(url: viewModel.posterUrl, onSuccess: { [weak self] in
            self?.bannerView.layer.masksToBounds = true
            self?.bannerView.contentMode(.scaleAspectFill)
        }) { [weak self] in
            self?.bannerView.layer.masksToBounds = true
            self?.bannerView.contentMode(.center)
            self?.bannerView.tintColor = .gray
        }
    }
}
