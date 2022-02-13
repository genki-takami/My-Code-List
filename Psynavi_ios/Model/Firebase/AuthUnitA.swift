/*
 Firebase関係の処理
 */

import Foundation
import Firebase

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
    
    static func signIn(_ address: String, _ password: String, handler: @escaping ResultHandler<String>) {
        
        auth.signIn(withEmail: address, password: password) { authResult, error in
            
            if let _ = error {
                handler(.failure(FirebaseError.userSignInError))
            } else {
                if let auth = authResult {
                    handler(.success(auth.user.uid))
                } else {
                    signOut()
                    handler(.failure(FirebaseError.userSignInError))
                }
            }
        }
    }
    
    static func signOut() {
        try! auth.signOut()
    }
    
    static func createUser(_ address: String, _ password: String, _ displayName: String, handler: @escaping ResultHandler<User>) {
        
        auth.createUser(withEmail: address, password: password) { authResult, error in
            
            if let _ = error {
                handler(.failure(FirebaseError.userCreateError))
            } else {
                if let user = authResult?.user {
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error2 in
                        
                        if let _ = error2 {
                            handler(.failure(FirebaseError.userDisplayNameError))
                        } else {
                            handler(.success(user))
                        }
                    }
                } else {
                    handler(.failure(FirebaseError.userCreateError))
                }
            }
        }
    }
    
    static func deleteUser(_ user: User, handler: @escaping ResultHandler<String>) {
        
        user.delete { error in
            // エラー判定
            if let _ = error {
                handler(.failure(FirebaseError.deleteError))
            } else {
                handler(.success("削除に成功\nタブ画面に戻ります"))
            }
        }
    }
}
