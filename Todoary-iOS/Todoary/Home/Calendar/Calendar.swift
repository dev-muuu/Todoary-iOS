//
//  CalendarViewController.swift
//  Todoary
//
//  Created by 송채영 on 2022/07/16.
//

import UIKit

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: - UIcomponents
    func initView() {
        dateFormatterYear.dateFormat = "yyyy"
        dateFormatterMonth.dateFormat = "MM"
        dateFormatterDate.dateFormat = "dd"
        self.year = Int(dateFormatterYear.string(from: now))!
        self.month = Int(dateFormatterMonth.string(from: now))!
        self.today = Int(dateFormatterDate.string(from: now))!
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        select = -1

        self.calculation()
        
        GetCalendataManager().getCalendataManager(self, yearMonth: "\(dateFormatterYear.string(from: now))-\(dateFormatterMonth.string(from: now))")
        GetDiaryDataManager().getDiaryDataManager(self, yearMonth: "\(dateFormatterYear.string(from: now))-\(dateFormatterMonth.string(from: now))")
        
        HomeViewController.bottomSheetVC.todoDate = ConvertDate(year: self.year, month: self.month, date: String(self.today))
    }

    
    func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        emptyDay = 0 - weekdayAdding
        
        self.month_component = Int(dateFormatterMonth.string(from: firstDayOfMonth!))!
        self.year_component = Int(dateFormatterYear.string(from: firstDayOfMonth!))!
        self.year_Month.setTitle(dateFormatterYear.string(from: firstDayOfMonth!)+"년 "+String(self.month_component)+"월", for: .normal)
        
        
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width/8.5, height: 30)
        default:
            return CGSize(width: view.frame.width/8.5, height: view.frame.width/8.7)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return self.days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekCell
            if indexPath.row == 0 {
                cell.weekLabel.textColor = .sunday
            } else if indexPath.row == 6 {
                cell.weekLabel.textColor = .saturday
            } else {
                cell.weekLabel.textColor = .black
            }
            cell.weekLabel.text = weeks[indexPath.row]
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
            cell.dateLabel.text = days[indexPath.row]
            cell.dateLabel.layer.backgroundColor = UIColor.transparent.cgColor
            cell.dateLabel.textColor = .black
            cell.dateLabel.layer.shadowRadius = 0
            cell.dateLabel.layer.shadowColor = UIColor.transparent.cgColor
            cell.dateLabel.layer.shadowOpacity = 0
            cell.diary.isHidden = true
            
            if (indexPath.row - emptyDay) >= 1 && (indexPath.row - emptyDay) < 32 {
                if HomeViewController.calendarRecord[indexPath.row-emptyDay] != 0{
                    cell.dateLabel.layer.backgroundColor = UIColor.calendarExistColor.cgColor
                    cell.dateLabel.textColor = .black
                }
                if HomeViewController.diaryRecord[indexPath.row-emptyDay] != 0{
                    cell.diary.isHidden = false
                }
            }
            
            
            if select == -1 {
                if self.year == year_component && self.month == month_component {
                    if today == (indexPath.row - emptyDay) {
                        collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
                        cell.isSelected = true
                    }else {
                        cell.dateLabel.textColor = .black
                    }
                }else {
                    if indexPath.row - emptyDay == 1 {
                        collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
                        cell.isSelected = true
                    }
                }
            }else {
                if select == (indexPath.row - emptyDay){
                collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
                cell.isSelected = true
                }
            }
            
            
            
            return cell
        }
    }
    
    //셀 선택o
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else{
            fatalError()
        }
        
        select = indexPath.row - emptyDay
        
        cell.dateLabel.layer.backgroundColor = UIColor.calendarSelectColor.cgColor
        cell.dateLabel.textColor = .white
        cell.dateLabel.layer.shadowRadius = 4.0
        cell.dateLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cell.dateLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.dateLabel.layer.shadowOpacity = 1
        cell.dateLabel.layer.masksToBounds = false
        
        //선택한 날짜에 맞는 투두 리스트 불러오기
        
        let convertDate = ConvertDate(year: year_component, month: month_component, date: days[indexPath.row])
        
        HomeViewController.bottomSheetVC.todoDate = convertDate
                                                      
        GetTodoDataManager().gets(convertDate.dateSendServer)
        DiaryDataManager().gets(convertDate.dateSendServer)
    }
    
    //셀 선택x
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else{
            fatalError()
        }
        
        if HomeViewController.calendarRecord[indexPath.row-emptyDay] != 0 {
            cell.dateLabel.layer.backgroundColor = UIColor.calendarExistColor.cgColor
            cell.dateLabel.textColor = .black
            cell.dateLabel.layer.shadowRadius = 0
            cell.dateLabel.layer.shadowColor = UIColor.transparent.cgColor
            cell.dateLabel.layer.shadowOpacity = 0
        }else {
            cell.dateLabel.layer.backgroundColor = UIColor.transparent.cgColor
            cell.dateLabel.textColor = .black
            cell.dateLabel.layer.shadowRadius = 0
            cell.dateLabel.layer.shadowColor = UIColor.transparent.cgColor
            cell.dateLabel.layer.shadowOpacity = 0
        }
        
        if HomeViewController.diaryRecord[indexPath.row-emptyDay] != 0 {
            cell.diary.isHidden = false
        }else {
            cell.diary.isHidden = true
        }
        
    }
    
    
    
    @objc func prevBtnDidTap() {
 
        select = -1
        components.month = components.month! - 1
        self.calculation()
        let date = cal.date(from: components)
        HomeViewController.calendarRecord = [Int](repeating: 0, count: 32)
        HomeViewController.diaryRecord = [Int](repeating: 0, count: 32)
        GetCalendataManager().getCalendataManager(self, yearMonth: "\(dateFormatterYear.string(from: date!))-\(dateFormatterMonth.string(from: date!))")
        GetDiaryDataManager().getDiaryDataManager(self, yearMonth: "\(dateFormatterYear.string(from: date!))-\(dateFormatterMonth.string(from: date!))")
        HomeViewController.collectionView.reloadData()
        
        requestTodoFirstDayOfMonth()
    }
    
    @objc func nextBtnDidTap() {

        select = -1
        components.month = components.month! + 1
        self.calculation()
        let date = cal.date(from: components)
        HomeViewController.calendarRecord = [Int](repeating: 0, count: 32)
        HomeViewController.diaryRecord = [Int](repeating: 0, count: 32)
        GetCalendataManager().getCalendataManager(self, yearMonth: "\(dateFormatterYear.string(from: date!))-\(dateFormatterMonth.string(from: date!))")
        GetDiaryDataManager().getDiaryDataManager(self, yearMonth: "\(dateFormatterYear.string(from: date!))-\(dateFormatterMonth.string(from: date!))")
        HomeViewController.collectionView.reloadData()
        
        requestTodoFirstDayOfMonth()
    }
    
    func requestTodoFirstDayOfMonth(){
        
        if self.year == year_component && self.month == month_component {
            let convertDate = ConvertDate(year: self.year, month: self.month, date: String(self.today))
            HomeViewController.bottomSheetVC.todoDate = convertDate
                                                          
            GetTodoDataManager().gets(convertDate.dateSendServer)
            DiaryDataManager().gets(convertDate.dateSendServer)
        }else {
            let convertDate = ConvertDate(year: year_component, month: month_component, date: "1")
            HomeViewController.bottomSheetVC.todoDate = convertDate
                                                          
            GetTodoDataManager().gets(convertDate.dateSendServer)
            DiaryDataManager().gets(convertDate.dateSendServer)
        }
    }
    
    
}
