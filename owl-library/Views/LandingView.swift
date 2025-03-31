import SwiftUI


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

struct SplashWrapperView: View {
    @State private var id: String = ""
    @State private var pwd: String = ""

    @State private var showLogin = false

    var body: some View {
        VStack(spacing: 20) {
            LandingView()
                .padding(.top, showLogin ? 0 : UIScreen.main.bounds.height / 3)
                .animation(.easeInOut(duration: 0.8), value: showLogin)

            
            LoginView(id: $id, pwd: $pwd)
                .opacity(showLogin ? 1 : 0)
                .offset(y: showLogin ? 0 : 40)
                .animation(.easeOut(duration: 0.8), value: showLogin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showLogin = true
                }
            }
        }
    }
}

struct LandingView: View {
    var body: some View {
        VStack {
            Text("부엉책방")
                .font(.system(size:44, weight: .heavy))
                .tracking(8)
                .padding(1)
            Text("부엉이 친구와 함께하는\n독서 기록 어플")
                .font(.system(size:17))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
}

struct LoginFormTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .font(.system(size:13))
        .padding(.leading, 12)
        .frame(width: 285, height: 47)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct LoginButton: View {
    var buttonLabel: String
    var buttonColor: String
    var buttonTextColor: String
    var height: CGFloat
    var imageName: String = ""
    var pwd: String = "test1234"
    var id: String = "testuser"
    
    var body: some View {
        Button(action: {
            LoginService.shared.login(email: id, password: pwd) { result in
                switch result {
                case .success(let data):
                    print("로그인 성공! \(data)")
                    // TODO: 토큰 저장 or 화면 전환

                case .pathErr:
                    print("요청 경로 오류")
                case .serverErr:
                    print("서버 오류")
                case .networkFail:
                    print("네트워크 실패")
                default:
                    print("기타 오류")
                }
            }
        }) {
            ZStack {
                // 가운데 정렬된 텍스트
                Text(buttonLabel)
                    .foregroundColor(Color(hex: buttonTextColor))
                    .font(.system(size: 13))
                    .frame(width: 224)
                            
                // 이미지가 있을 경우 좌측에 배치
                if !imageName.isEmpty {
                    HStack {
                        Image(imageName)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.leading, 10)
                        Spacer()
                    }
                }
            }
            .frame(width: 224, height: height)
            .background(Color(hex: buttonColor))
            .cornerRadius(3)
        }
    }
}

struct LoginView: View {
    @Binding var id: String
    @Binding var pwd: String
    var body: some View {
        VStack {
            LoginFormTextField(placeholder: "아이디를 입력해주세요", text: $id)
                .keyboardType(.emailAddress)
            LoginFormTextField(placeholder: "비밀번호를 입력해주세요", text: $pwd, isSecure: true)
            
            LoginButton(buttonLabel: "로그인", buttonColor: "#000000", buttonTextColor: "#FFFFFF", height: 34)
                .padding(15)
            
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                Text("또는")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            LoginButton(buttonLabel: "네이버 로그인", buttonColor: "#03C75A", buttonTextColor: "#FFFFFF", height: 40, imageName: "Naver-login")
                .padding(.top, 10)
            LoginButton(buttonLabel: "카카오 로그인", buttonColor: "#FEE500", buttonTextColor: "#000000", height: 40, imageName: "Kakao-login")
        }
        .padding()
        
        HStack(spacing: 5) {
            Text("아이디 찾기")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            Text("|")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            Text("비밀번호 찾기")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            Text("|")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            Button(action: {
                print("회원가입 클릭")
            }) {
                Text("회원가입")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    SplashWrapperView()
}

