//
//  TodoDeleteDataManager.swift
//  Todoary
//
//  Created by 박지윤 on 2022/07/27.
//

import Foundation
import Alamofire

class TodoDeleteDataManager{

    func delete(todoId: Int, indexPath: IndexPath){
        
        let headers : HTTPHeaders = [.authorization(UserDefaults.standard.string(forKey: "accessToken")!)]
        
        AF.request("http://todoary.com/todo/\(todoId)",
                   method: .delete,
                   parameters: [:],
                   headers: headers)
            .validate()
            .responseDecodable(of: UserDeleteModel.self) { response in
                switch response.result {
                case .success(let result):
                    HomeViewController.bottomSheetVC.checkDeleteApiResultCode(result.code, indexPath)
                    return
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
