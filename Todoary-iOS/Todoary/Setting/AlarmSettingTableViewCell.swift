//
//  AlarmSettingTableViewCell.swift
//  Todoary
//
//  Created by 박지윤 on 2022/07/10.
//

import UIKit

class AlarmSettingTableViewCell: UITableViewCell {
    
    let backView = UIView()
    
    let cellTitle = UILabel().then{
        $0.labelTypeSetting(type: .tableCell)
        $0.text = "Todoary 알림"
        
        $0.font = UIFont.nbFont(ofSize: 11, weight: .semibold)
    }
    
    let alarmSwitch = UISwitch()
//        .then{
//
//    }
    
    let separatorLine = UIView().then{
        $0.backgroundColor = .silver_225
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
    
        self.contentView.addSubview(backView)
        
        self.backView.addSubview(cellTitle)
        
        self.backView.addSubview(alarmSwitch)
        
        self.backView.addSubview(separatorLine)
    }
    
    func setUpConstraint(){
        
        self.contentView.snp.makeConstraints{ make in
            make.height.equalTo(50)
        }
        
        backView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        cellTitle.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(31)
            make.centerY.equalToSuperview()
        }
        
        alarmSwitch.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-31)
            make.height.equalTo(27)
            make.width.equalTo(44)
        }
        
        separatorLine.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(31)
            make.trailing.equalToSuperview().offset(-31)
            make.height.equalTo(1)
        }
    }
}
