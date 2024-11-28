import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recommenderProvider =
    StateNotifierProvider<Recommender, RecommenderState>(
        (ref) => Recommender(ref));

class Recommender extends StateNotifier<RecommenderState> {
  final Ref ref;

  Recommender(this.ref) : super(RecommenderState());

  final domain = 'https://vdt-news-api-bc5f68f45f02.herokuapp.com/api/';

  Future getUserRecommendations(String userId) async {
    state = state.copyWith(loadStatus: LoadStatus.loading);
    try {
      final url = '${domain}soft_get_keywords?userId=$userId';

      await Dio().get(url).then((response) {
        if (response.data != null && response.data['keywords'] != null) {
          List<String> keywords = List<String>.from(response.data['keywords']);
          print(keywords);
          state = state.copyWith(
            loadStatus: LoadStatus.success,
            userRecommendations: keywords,
          );
        } else {
          print('No data received');
          state = state.copyWith(
            loadStatus: LoadStatus.error,
            userRecommendations: [],
          );
        }
      });
    } catch (e) {
      state = state.copyWith(loadStatus: LoadStatus.error);
    }
  }

  Future getGroupRecommendations(String userId) async {
    state = state.copyWith(loadStatus: LoadStatus.loading);
    try {
      final url = '${domain}hard_get_keywords?userId=$userId';
      await Dio().get(url).then((response) {
        if (response.data != null && response.data['keywords'] != null) {
          List<String> keywords = List<String>.from(response.data['keywords']);
          print(keywords);
          state = state.copyWith(
            loadStatus: LoadStatus.success,
            groupRecommendations: keywords,
          );
        } else {
          print('No data received');
          state = state.copyWith(
            loadStatus: LoadStatus.error,
            groupRecommendations: [],
          );
        }
      });
    } catch (e) {
      state = state.copyWith(loadStatus: LoadStatus.error);
    }
  }

  void addLastReadNews(String userId, String headline) {
    final url = '${domain}add_last_read_news?userId=$userId&headline=$headline';
    Dio().post(url).then((response) {
      if (response.statusCode == 200) {
        print('Last read news added!');
      } else {
        print('Failed to add last read news!');
      }
    });
  }
}

class RecommenderState {
  final LoadStatus loadStatus;
  final List<String> userRecommendations;
  final List<String> groupRecommendations;

  RecommenderState({
    this.loadStatus = LoadStatus.initial,
    this.userRecommendations = const [],
    this.groupRecommendations = const [],
  });

  RecommenderState copyWith({
    LoadStatus? loadStatus,
    List<String>? userRecommendations,
    List<String>? groupRecommendations,
  }) {
    return RecommenderState(
      loadStatus: loadStatus ?? this.loadStatus,
      userRecommendations: userRecommendations ?? this.userRecommendations,
      groupRecommendations: groupRecommendations ?? this.groupRecommendations,
    );
  }
}

enum LoadStatus {
  initial,
  loading,
  success,
  error,
}
