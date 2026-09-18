import 'package:flutter/foundation.dart';

import '../core/demo/demo_data.dart';

class DemoStore extends ChangeNotifier {
  final Set<String> _followedTeams = {'gs', 'fb', 'city'};
  final Set<String> _favoriteMatches = {'derby', 'city'};
  final Set<String> _readArticles = {};
  bool goalNotifications = true;
  bool matchNotifications = true;
  bool newsNotifications = false;
  bool unreadNotifications = true;

  List<DemoTeam> get followedTeams =>
      demoTeams.where((team) => follows(team.id)).toList();
  int get readCount => 41 + _readArticles.length;
  bool follows(String id) => _followedTeams.contains(id);
  bool isFavoriteMatch(String id) => _favoriteMatches.contains(id);

  void toggleTeam(String id) {
    if (!_followedTeams.remove(id)) _followedTeams.add(id);
    notifyListeners();
  }

  void toggleMatch(String id) {
    if (!_favoriteMatches.remove(id)) _favoriteMatches.add(id);
    notifyListeners();
  }

  void readArticle(String id) {
    if (_readArticles.add(id)) notifyListeners();
  }

  void clearNotifications() {
    unreadNotifications = false;
    notifyListeners();
  }

  void updateNotifications({bool? goals, bool? matches, bool? news}) {
    goalNotifications = goals ?? goalNotifications;
    matchNotifications = matches ?? matchNotifications;
    newsNotifications = news ?? newsNotifications;
    notifyListeners();
  }
}
