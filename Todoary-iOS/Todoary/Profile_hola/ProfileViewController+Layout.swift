//
//  ProfileViewController+Layout.swift
//  Todoary
//
//  Created by 송채영 on 2022/07/11.
//

import UIKit

extension ProfileViewController {
    
    func setUpView(){
        
        self.view.addSubview(navigationView)
        
        self.view.addSubview(profileImage)
        self.view.addSubview(imagePicker)
        self.view.addSubview(nickNameTitle)
        self.view.addSubview(nickNameTf)
        self.view.addSubview(introduceTitle)
        self.view.addSubview(introduceTf)
        


    
    }
    
    func setUpConstraint(){
        
        //navigation bar
        navigationView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }

        //profile
        profileImage.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(124)
            make.centerX.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(85)
        }
        
        imagePicker.snp.makeConstraints{ make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        nickNameTitle.snp.makeConstraints{ make in
            make.top.equalTo(imagePicker.snp.bottom).offset(31)
            make.leading.equalToSuperview().offset(31)
        }
        
        nickNameTf.snp.makeConstraints{ make in
            make.top.equalTo(nickNameTitle.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(32)
            make.width.equalTo(327)
            make.height.equalTo(45)
        }
        
        introduceTitle.snp.makeConstraints{ make in
            make.top.equalTo(nickNameTf.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(31)
        }
        
        introduceTf.snp.makeConstraints{ make in
            make.top.equalTo(introduceTitle.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(32)
            make.width.equalTo(327)
            make.height.equalTo(45)
        }
        
        
    }
}

