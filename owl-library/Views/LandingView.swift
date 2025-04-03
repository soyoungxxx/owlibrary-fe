import SwiftUI

// MARK: - Hex Color Extension
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

// MARK: - Splash Wrapper View
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
                withAnimation {
                    showLogin = true
                }
            }
        }
    }
}

// MARK: - Landing View
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

// MARK: - Login Form Input
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

// MARK: - 공통 스타일 버튼 컴포넌트
struct StyledLoginButton: View {
    var label: String
    var color: String
    var textColor: String
    var height: CGFloat
    var imageName: String = ""
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.leading, 10)
                }
                Spacer()
                Text(label)
                    .foregroundColor(Color(hex: textColor))
                    .font(.system(size: 13))
                Spacer()
            }
            .frame(width: 224, height: height)
            .background(Color(hex: color))
            .cornerRadius(3)
        }
    }
}

// MARK: - Login View
struct LoginView: View {
    @Binding var id: String
    @Binding var pwd: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            LoginFormTextField(placeholder: "이메일을 입력해주세요", text: $id)
                .keyboardType(.emailAddress)

            LoginFormTextField(placeholder: "비밀번호를 입력해주세요", text: $pwd, isSecure: true)

            // 일반 로그인 버튼
            StyledLoginButton(label: "로그인", color: "#000000", textColor: "#FFFFFF", height: 34) {
                LoginService.shared.login(email: id, password: pwd) { result in
                    switch result {
                    case .success(let data):
                        print("로그인 성공! \(data)")
                        // TODO: 화면 전환
                    case .serverErr:
                        alertMessage = "서버 오류 발생"
                        showAlert = true
                    case .networkFail:
                        alertMessage = "네트워크 연결을 확인해주세요"
                        showAlert = true
                    default:
                        alertMessage = "알 수 없는 오류"
                        showAlert = true
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("로그인 실패"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
            .padding(15)

            // 구분선
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

            // 소셜 로그인 버튼들
            StyledLoginButton(label: "네이버 로그인", color: "#03C75A", textColor: "#FFFFFF", height: 40, imageName: "Naver-login") {
                print("네이버 로그인 클릭됨")
                // TODO: 네이버 로그인 SDK 연동
            }

            StyledLoginButton(label: "카카오 로그인", color: "#FEE500", textColor: "#000000", height: 40, imageName: "Kakao-login") {
                print("카카오 로그인 클릭됨")
                // TODO: 카카오 로그인 SDK 연동
            }
        }
        .padding()

        // 하단 링크
        HStack(spacing: 5) {
            Text("아이디 찾기").font(.system(size: 12)).foregroundColor(.gray)
            Text("|").font(.system(size: 12)).foregroundColor(.gray)
            Text("비밀번호 찾기").font(.system(size: 12)).foregroundColor(.gray)
            Text("|").font(.system(size: 12)).foregroundColor(.gray)
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

// MARK: - Preview
#Preview {
    SplashWrapperView()
}
