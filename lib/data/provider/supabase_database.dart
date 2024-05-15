import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toefl_app/domain/models/test_packet_model.dart';
import 'package:toefl_app/domain/models/user_model.dart';

class SupabaseDatabase {
  final SupabaseClient _supabaseClient;
  SupabaseDatabase({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> register({
    required String password,
    required String email,
    required String name,
  }) async {
    try {
      final AuthResponse res = await _supabaseClient.auth.signUp(
        password: password,
        email: email,
      );

      if (res.user != null) {
        await _supabaseClient.from('users').insert({
          'id': res.user!.id,
          'name': name,
          'email': res.user!.email!,
        });
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login({
    required String password,
    required String email,
  }) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> getUser() async {
    try {
      final Session? session = _supabaseClient.auth.currentSession;
      if (session != null) {
        final Map<String, dynamic> user = await _supabaseClient
            .from('users')
            .select()
            .eq('id', session.user.id)
            .single();
        return UserModel.fromJson(user);
      } else {
        throw Exception('There is no user already logged in');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TestPacketModel> getPacketById(int packetId) async {
    try {
      final Map<String, dynamic> data = await _supabaseClient
          .from('test_packet')
          .select(
            'id, name, test_question(question, url, type_id, test_answer(answer, is_correct))',
          )
          .eq('id', packetId)
          .single();

      return TestPacketModel.fromJson(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TestPacketModel> getRandomPacket() async {
    try {
      final Map<String, dynamic> packetId = await _supabaseClient.rpc(
        'random_packet_id',
        params: {'auth_id': _supabaseClient.auth.currentUser!.id},
      );

      return await getPacketById(packetId['id']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> decrementTestRemaining(int userId) {
    return _supabaseClient.rpc(
      'decrement_test_remaining',
      params: {'id': userId},
    );
  }

  Future<void> insertHistory({
    required int packetId,
    required double listeningScore,
    required double readingScore,
    required double structureScore,
  }) async {
    final data = {
      'packet_id': packetId,
      'user_id': _supabaseClient.auth.currentUser!.id,
      'listening_score': listeningScore.floor(),
      'reading_score': readingScore.floor(),
      'structure_score': structureScore.floor(),
    };

    try {
      await _supabaseClient.from('test_history').insert(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}