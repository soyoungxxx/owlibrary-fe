//
//  LoginService.swift
//  owl-library
//
//  Created by 하소영 on 3/31/25.
//
import Foundation
import Alamofire

class LoginService {
    static let shared = LoginService() // 싱글톤 객체 추가
    private init() {}
    func login(email: String, password: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstants.loginURL // API 주소
        // request header
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        // request body
        let body : Parameters = [
            "username" : email,
            "password" : password
        ]
        // request
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        // start request
        dataRequest.responseData {
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case ..<300 : return isVaildData(data: data)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    //통신이 성공하고 원하는 데이터가 올바르게 들어왔을때 처리하는 함수
    private func isVaildData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder() //서버에서 준 데이터를 Codable을 채택
        guard let decodedData = try? decoder.decode(LoginResponseData.self, from: data)
        //데이터가 변환이 되게끔 Response 모델 구조체로 데이터를 변환해서 넣고, 그 데이터를 NetworkResult Success 파라미터로 전달
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}
