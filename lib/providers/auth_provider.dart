import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = true;
  String _error = '';

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String get error => _error;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      _userModel = await _firestoreService.getUserById(user.uid);
      
      // Update email verification status if changed
      if (_userModel != null && _userModel!.isEmailVerified != user.emailVerified) {
        await _firestoreService.updateEmailVerificationStatus(
          user.uid, 
          user.emailVerified
        );
        _userModel = await _firestoreService.getUserById(user.uid);
      }
    } else {
      _userModel = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _error = '';
      _isLoading = true;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _error = '';
      _isLoading = true;
      notifyListeners();

      await _authService.registerWithEmailAndPassword(email, password, name);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      _error = '';
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      _error = '';
      await _authService.sendEmailVerification();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> reloadUser() async {
    await _authService.reloadUser();
    _onAuthStateChanged(_authService.currentUser);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}