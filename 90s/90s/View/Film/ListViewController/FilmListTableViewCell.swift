//
//  FilmListCollectionViewCell.swift
//  90s
//
//  Created by 성다연 on 2021/02/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// 필름 리스트를 보여주는 테이블 셀
class FilmListTableViewCell: UITableViewCell {
    static let cellId = "filmListCell"
    
    private var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.showsHorizontalScrollIndicator = false
        cv.isUserInteractionEnabled = false
        cv.backgroundColor = UIColor.colorRGBHex(hex: 0x2B2B2E)
        return cv
    }()
    
    private var FilmTitleLabel : UILabel = {
        return LabelType.bold_16.create()
    }()
    
    private var FilmCount_DateLabel : UILabel = {
        return LabelType.normal_gray_13.create()
    }()
    
    /// 필름 상태를 보여주는 이미지 뷰
    private var FilmTypeImageView : UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// 필름 대표 이미지 뷰
    private var FilmTitleImageView : UIImageView = {
        let iv = UIImageView(frame: .zero)
        return iv
    }()
    
    /// 필름 배경 이미지 뷰
    private var FilmBackgroudImageView : UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.image = UIImage(named: "film_preview_roll")
        return iv
    }()
    
    /// 필름 삭제 선택 버튼
    private var FilmDeleteButton : UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(named: "film_edit_unselect"), for: .normal)
        btn.backgroundColor = .black
        btn.isHidden = true
        return btn
    }()
    
    private var disposeBag = DisposeBag()
    private var testFilmValue : Film?
    var isDeleteBtnClicked : Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        FilmDeleteButton.setImage(UIImage(named: "film_edit_unselect"), for: .normal)
    }

    private func setUpSubViews(){
        addSubview(FilmBackgroudImageView)
        addSubview(FilmTitleImageView)
        addSubview(collectionView)
        addSubview(FilmTitleLabel)
        addSubview(FilmCount_DateLabel)
        addSubview(FilmTypeImageView)
        addSubview(FilmDeleteButton)
        
        backgroundColor = .clear
        collectionView.dataSource = self
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.register(FilmListCollectionViewCell.self, forCellWithReuseIdentifier: FilmListCollectionViewCell.cellId)
       
        FilmTitleImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(140)
            $0.left.equalTo(18)
            $0.top.equalTo(18)
        }
        
        FilmBackgroudImageView.snp.makeConstraints {
            $0.left.equalTo(FilmTitleImageView.snp.right).offset(-2)
            $0.height.equalTo(110)
            $0.right.equalTo(-28)
            $0.top.equalTo(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.left.equalTo(FilmTitleImageView.snp.right).offset(10)
            $0.right.equalTo(FilmBackgroudImageView.snp.right)
            $0.top.equalTo(FilmBackgroudImageView.snp.top).offset(15)
            $0.bottom.equalTo(FilmBackgroudImageView.snp.bottom).offset(-15)
        }
        
        FilmTitleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(FilmTitleImageView.snp.bottom).offset(8)
        }
        
        FilmCount_DateLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(FilmTitleLabel.snp.bottom).offset(2)
        }
        
        FilmTypeImageView.snp.makeConstraints {
            $0.height.equalTo(29)
            $0.width.equalTo(110)
            $0.bottom.equalTo(-22)
            $0.right.equalTo(-18)
        }
        
        FilmDeleteButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(140)
            $0.centerY.equalTo(FilmBackgroudImageView.snp.centerY)
            $0.right.equalTo(0)
        }
    }
    
    func bindViewModel(film: Film){
        testFilmValue = film
        
        DispatchQueue.main.async { [weak self] in
            self?.FilmTitleImageView.image = UIImage(named: film.filterType.image())
            self?.FilmTypeImageView.image = UIImage(named: film.state.image())
        }
        
        FilmTitleLabel.text = film.name
        FilmCount_DateLabel.text = "\(film.count)/\(film.maxCount) · \(film.createDate)" // 전체 개수 리턴하는 함수 필요
        collectionView.reloadData()
        
        //MARK: TODO - Rx로 아래대로 하면 스크롤 시 멈춤
//        BehaviorRelay(value: film.photos).bind(to: collectionView.rx.items(cellIdentifier: FilmListCollectionViewCell.filmListCCellId, cellType: FilmListCollectionViewCell.self)) { index, item, cell in
//            cell.bindViewModel(item: item)
//        }
//        .disposed(by: disposeBag)
    }
    
    func isEditStarted(value: Bool){
        FilmTypeImageView.isHidden = value
        FilmDeleteButton.isHidden = !value
    }
    
    func isEditCellSelected(value: Bool) {
        let image = value ? UIImage(named: "film_edit_select") : UIImage(named: "film_edit_unselect")
        FilmDeleteButton.setImage(image, for: .normal)
    }
}

extension FilmListTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let item = testFilmValue {
            return item.photos.count
        }
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmListCollectionViewCell.cellId, for: indexPath) as! FilmListCollectionViewCell
        
        if let item = testFilmValue {
            cell.bindViewModel(item: item.photos[indexPath.row])
        }
        return cell
    }
}


extension FilmListTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

extension FilmListTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
