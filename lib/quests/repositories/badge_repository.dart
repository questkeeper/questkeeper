import 'package:questkeeper/quests/models/badge.dart';
import 'package:questkeeper/quests/models/user_badge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeRepository {
  BadgeRepository();
  final supabase = Supabase.instance.client;

  Future<List<Badge>> getBadges() async {
    final badges = await supabase
        .from("badges")
        .select()
        .order("name")
        .order("tier", ascending: false)
        .order("resetMonthly");

    final List<Badge> badgesList = badges.map((e) => Badge.fromMap(e)).toList();

    return badgesList;
  }

  Future<Badge> getBadge(String id) async {
    final space = await supabase.from("spaces").select().eq("id", id).single();

    return Badge.fromMap(space);
  }

  Future<List<UserBadge>> getUserBadges() async {
    final userBadges =
        await supabase.from("user_badges").select().order("earnedAt");

    final List<UserBadge> userBadgesList =
        userBadges.map((e) => UserBadge.fromMap(e)).toList();

    return userBadgesList;
  }
}
