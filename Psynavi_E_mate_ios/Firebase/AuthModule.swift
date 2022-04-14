/*
 Firebase関係の処理
 */

import FirebaseAuth

final class AuthModule {
    
    static let auth = Auth.auth()
    
    static func currentUser() -> User? {
        return auth.currentUser
    }
    
    static func checkout() -> Bool {
        if let _ = currentUser() {
            return true
        } else {
            return false
        }
    }
    
    static func signInAnonymously(handler: @escaping ResultHandler<Bool>) {
        
        auth.signInAnonymously() { (authResult, error) in
            
            if let _ = error{
                handler(.failure(FirebaseError.userSignInError))
            } else {
                if authResult!.user.isAnonymous {
                    handler(.success(true))
                }
            }
        }
    }
}
