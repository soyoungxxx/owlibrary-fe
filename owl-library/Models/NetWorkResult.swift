//
//  NetWorkResult.swift
//  owl-library
//
//  Created by 하소영 on 3/31/25.
//

enum NetworkResult<T> {
    case success(T) // 서버 통신 성공
    case requestErr(T) // 요청 에러 발생
    case pathErr // 경로 에러
    case serverErr // 서부 내부 에러
    case networkFail // 네트워크 연결 실패
    // 아이디/비밀번호 오류도 체크해야함
}
