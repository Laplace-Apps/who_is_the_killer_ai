import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_state.dart';

class FirebaseService {
  FirebaseService({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Oyun durumunu Firebase'e kaydet
  Future<void> saveGameState(GameState gameState) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('games')
            .doc('current_game')
            .set(gameState.toJson());
      }
    } catch (e) {
      print('Oyun durumu kaydedilemedi: $e');
    }
  }

  // Oyun durumunu Firebase'den yükle
  Future<GameState?> loadGameState() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('games')
            .doc('current_game')
            .get();

        if (doc.exists) {
          return GameState.fromJson(doc.data()!);
        }
      }
    } catch (e) {
      print('Oyun durumu yüklenemedi: $e');
    }
    return null;
  }

  Future<void> deleteGameState() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('games')
            .doc('current_game')
            .delete();
      }
    } catch (e) {
      print('Oyun durumu silinemedi: $e');
    }
  }

  // Oyun istatistiklerini kaydet
  Future<void> saveGameStats({
    required bool isCorrect,
    required String selectedCharacter,
    required String realKiller,
    required int conversationCount,
    required Duration gameDuration,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('stats')
            .add({
              'isCorrect': isCorrect,
              'selectedCharacter': selectedCharacter,
              'realKiller': realKiller,
              'conversationCount': conversationCount,
              'gameDuration': gameDuration.inSeconds,
              'timestamp': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      print('Oyun istatistikleri kaydedilemedi: $e');
    }
  }

  // Kullanıcının oyun istatistiklerini al
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('stats')
            .get();

        int totalGames = querySnapshot.docs.length;
        int correctGuesses = 0;
        int totalConversations = 0;
        int totalDuration = 0;

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          if (data['isCorrect'] == true) correctGuesses++;
          totalConversations += (data['conversationCount'] ?? 0) as int;
          totalDuration += (data['gameDuration'] ?? 0) as int;
        }

        return {
          'totalGames': totalGames,
          'correctGuesses': correctGuesses,
          'accuracy': totalGames > 0
              ? (correctGuesses / totalGames * 100).round()
              : 0,
          'averageConversations': totalGames > 0
              ? (totalConversations / totalGames).round()
              : 0,
          'averageDuration': totalGames > 0
              ? (totalDuration / totalGames).round()
              : 0,
        };
      }
    } catch (e) {
      print('Kullanıcı istatistikleri alınamadı: $e');
    }
    return {};
  }
}
