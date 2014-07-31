library hauberk.debug;

import 'dart:collection';

import 'package:piecemeal/piecemeal.dart';

import 'engine.dart';

/// A class for storing debugging information.
///
/// Unlike the rest of the engine, this is static state to make it easier for
/// the engine to punch debug info all the way to where the UI can get it. It
/// should not be used outside of a debugging scenario.
class Debug {
  static const ENABLED = false;

  static final _monsters = new Map<Monster, _MonsterLog>();

  static void addMonster(Monster monster) {
    if (!ENABLED) return;
    _monsters[monster] = new _MonsterLog(monster);
  }

  static void removeMonster(Monster monster) {
    if (!ENABLED) return;
    _monsters.remove(monster);
  }

  static void logMonster(Monster monster, String log) {
    if (!ENABLED) return;
    var monsterLog = _monsters[monster];
    monsterLog.add(log);
  }

  static void exitLevel() {
    if (!ENABLED) return;
    _monsters.clear();
  }

  static String getMonsterInfoAt(Vec pos) {
    if (!ENABLED) return null;
    for (var monster in _monsters.keys) {
      if (monster.pos == pos) {
        return _monsters[monster].toString();
      }
    }

    return null;
  }
}

class _MonsterLog {
  final Monster monster;
  final Queue<String> log = new Queue<String>();

  _MonsterLog(this.monster);

  void add(String logItem) {
    log.add(logItem);
    if (log.length > 10) log.removeFirst();
  }

  String toString() {
    var buffer = new StringBuffer();

    buffer.write(monster.breed.name);
    buffer.write(" health: ${monster.health.current}/${monster.health.max}");
    buffer.writeln(" fear: ${monster.fear}");
    buffer.writeAll(log, "\n");
    return buffer.toString();
  }
}