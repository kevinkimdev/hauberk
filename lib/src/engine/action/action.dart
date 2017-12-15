import 'dart:collection';

import 'package:piecemeal/piecemeal.dart';

import '../core/actor.dart';
import '../core/element.dart';
import '../core/game.dart';
import '../core/log.dart';
import '../core/option.dart';
import '../hero/hero.dart';
import '../monster/monster.dart';

abstract class Action {
  Actor _actor;
  Game _game;
  Queue<Action> _actions;
  GameResult _gameResult;
  bool _consumesEnergy;

  Game get game => _game;
  Actor get actor => _actor;
  Monster get monster => _actor as Monster;
  Hero get hero => _actor as Hero;
  bool get consumesEnergy => _consumesEnergy;

  void bind(Actor actor, {bool consumesEnergy}) {
    assert(_actor == null);

    _actor = actor;
    _game = actor.game;
    _consumesEnergy = consumesEnergy ?? true;
  }

  ActionResult perform(Queue<Action> actions, GameResult gameResult) {
    assert(_actor != null); // Action should be bound already.

    _actions = actions;
    _gameResult = gameResult;
    return onPerform();
  }

  ActionResult onPerform();

  /// Enqueue a secondary action that is a consequence of this one.
  void addAction(Action action, [Actor actor]) {
    action.bind(actor ?? _actor, consumesEnergy: false);
    _actions.add(action);
  }

  void addEvent(EventType type,
      {Actor actor, Element element, other, Vec pos, Direction dir}) {
    _gameResult.events.add(new Event(type, actor, element, pos, dir, other));
  }

  /// How much noise is produced by this action. Override to make certain
  /// actions quieter or louder.
  int get noise => Option.noiseNormal;

  void error(String message, [Noun noun1, Noun noun2, Noun noun3]) {
    if (!_actor.isVisible) return;
    _game.log.error(message, noun1, noun2, noun3);
  }

  void log(String message, [Noun noun1, Noun noun2, Noun noun3]) {
    if (!_actor.isVisible) return;
    _game.log.message(message, noun1, noun2, noun3);
  }

  ActionResult succeed([String message, Noun noun1, Noun noun2, Noun noun3]) {
    if (message != null) log(message, noun1, noun2, noun3);
    return ActionResult.success;
  }

  ActionResult fail([String message, Noun noun1, Noun noun2, Noun noun3]) {
    if (message != null) error(message, noun1, noun2, noun3);
    return ActionResult.failure;
  }

  ActionResult alternate(Action action) {
    action.bind(_actor, consumesEnergy: _consumesEnergy);
    return new ActionResult.alternate(action);
  }

  /// Returns [success] if [done] is `true`, otherwise returns [notDone].
  ActionResult doneIf(bool done) {
    return done ? ActionResult.success : ActionResult.notDone;
  }
}

class ActionResult {
  static final success = const ActionResult(succeeded: true, done: true);
  static final failure = const ActionResult(succeeded: false, done: true);
  static final notDone = const ActionResult(succeeded: true, done: false);

  /// An alternate [Action] that should be performed instead of the one that
  /// failed to perform and returned this. For example, when the [Hero] walks
  /// into a closed door, the [WalkAction] will fail (the door is closed) and
  /// return an alternate [OpenDoorAction] instead.
  final Action alternative;

  /// `true` if the [Action] was successful and energy should be consumed.
  final bool succeeded;

  /// `true` if the [Action] does not need any further processing.
  final bool done;

  const ActionResult({this.succeeded, this.done}) : alternative = null;

  const ActionResult.alternate(this.alternative)
      : succeeded = false,
        done = true;
}

class FocusAction extends Action {
  /// The focus cost of the action.
  final int _focus;

  /// The action to perform if the hero has enough focus.
  final Action _action;

  FocusAction(this._focus, this._action);

  ActionResult onPerform() {
    if (hero.focus < _focus) {
      return fail("You don't have enough focus to do this!");
    }

    hero.focus -= _focus;
    return alternate(_action);
  }
}
