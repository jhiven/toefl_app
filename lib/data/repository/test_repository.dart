import 'package:toefl_app/data/provider/audio_provider.dart';
import 'package:toefl_app/data/provider/supabase_database.dart';
import 'package:toefl_app/domain/models/test_history_model.dart';
import 'package:toefl_app/domain/models/test_leaderboard_model.dart';
import 'package:toefl_app/domain/models/test_packet_model.dart';
import 'package:toefl_app/domain/models/test_question_model.dart';

class TestRepository {
  final SupabaseDatabase _supabaseDatabase;

  TestRepository({
    required SupabaseDatabase supabaseDatabase,
  }) : _supabaseDatabase = supabaseDatabase;

  Future<TestPacketModel> getPacketById(int packetId) async {
    return await _supabaseDatabase.getPacketById(packetId);
  }

  Future<TestPacketModel> getRandomPacket() async {
    return await _supabaseDatabase.getRandomPacket();
  }

  Future<void> decrementTestRemaining() {
    return _supabaseDatabase.decrementTestRemaining();
  }

  Future<int> getTestRemaining() {
    return _supabaseDatabase.getTestRemaining();
  }

  Future<void> insertHistory({
    required int packetId,
    required int listeningScore,
    required int readingScore,
    required int structureScore,
  }) async {
    return await _supabaseDatabase.insertHistory(
      packetId: packetId,
      listeningScore: listeningScore,
      readingScore: readingScore,
      structureScore: structureScore,
    );
  }

  Future<List<TestLeaderboardModel>> getLeaderboard() async {
    return await _supabaseDatabase.getLeaderboard();
  }

  Future<List<TestHistoryModel>> getHistory({
    required String userId,
  }) async {
    return await _supabaseDatabase.getHistory(
      userId: userId,
    );
  }

  Future<TestQuestionModel> downloadAudio(TestQuestionModel question) async {
    final audioProvider = AudioProvider();

    return question.copyWith(
      url: await audioProvider.downloadAudio(
        id: question.id,
        url: question.url!,
      ),
    );
  }
}
