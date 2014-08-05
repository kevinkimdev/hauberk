library hauberk.ui.item_dialog;

import 'package:malison/malison.dart';

import '../engine.dart';
import 'input.dart';

/// Modal dialog for letting the user perform an [Action] on an [Item]
/// accessible to the [Hero].
class ItemDialog extends Screen {
  final Game _game;
  final _ItemCommand _mode;
  _ItemView _view;

  bool get isTransparent => true;

  ItemDialog.drop(this._game)
      : _mode = new _DropItemCommand(),
        _view = new _InventoryView();

  ItemDialog.use(this._game)
      : _mode = new _UseItemCommand(),
        _view = new _InventoryView();

  bool handleInput(Input input) {
    if (input == Input.CANCEL) {
      ui.pop();
      return true;
    }

    return false;
  }

  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (shift || alt) return false;

    if (keyCode >= KeyCode.A && keyCode <= KeyCode.Z) {
      selectItem(keyCode - KeyCode.A);
      return true;
    }

    if (keyCode == KeyCode.TAB) {
      _view = _view.next;
      if (!_mode.showGroundItems && _view is _GroundView) _view = _view.next;
      dirty();
      return true;
    }

    return false;
  }

  void render(Terminal terminal) {
    terminal.writeAt(0, 0, _mode.query(_view));

    terminal.rect(0, terminal.height - 2, terminal.width, 2).clear();
    terminal.writeAt(0, terminal.height - 1,
        '[A-Z] Select item, [Tab] Switch view',
        Color.GRAY);

    drawItems(terminal, 0, 1, _view.getItems(_game),
        (item) => _mode.canSelect(item));
  }

  void selectItem(int index) {
    var items = _view.getItems(_game).toList();
    if (index >= items.length) return;
    if (!_mode.canSelect(items[index])) return;

    _game.hero.setNextAction(_mode.getAction(index, _view));
    ui.pop();
  }
}

// TODO: Move to separate file?
void drawItems(Terminal terminal, int x, int y, Iterable<Item> items,
    bool canSelect(Item item)) {
  var i = 0;
  for (final item in items) {
    final itemY = i + y;

    var borderColor = Color.GRAY;
    var letterColor = Color.YELLOW;
    var textColor = Color.WHITE;
    if (!canSelect(item)) {
      borderColor = Color.DARK_GRAY;
      letterColor = Color.GRAY;
      textColor = Color.GRAY;
    }

    terminal.writeAt(x, itemY, '( )   ', borderColor);
    terminal.writeAt(x + 1, itemY, 'abcdefghijklmnopqrstuvwxyz'[i], letterColor);
    terminal.drawGlyph(x + 4, itemY, item.appearance);
    terminal.writeAt(x + 6, itemY, item.nounText, textColor);
    i++;
  }
}

/// Which set of items are currently being shown in the view.
abstract class _ItemView {
  /// The query shown to the user when selecting an item to drop from this view.
  String get dropQuery;

  /// The query shown to the user when selecting an item to use from this view.
  String get useQuery;

  /// Gets the next inventory view, rotating through all three.
  _ItemView get next;

  /// Gets the items visible in this view.
  Iterable<Item> getItems(Game game);

  /// Creates an [Action] that will drop the item at [index] from this view.
  Action getDropAction(int index);

  /// Creates an [Action] that will use the item at [index] from this view.
  Action getUseAction(int index);
}

/// An [ItemView] for items in the hero's [Inventory].
class _InventoryView implements _ItemView {
  String get dropQuery => 'Drop which item?';
  String get useQuery => 'Use or equip which item?';
  _ItemView get next => new _EquipmentView();

  Iterable<Item> getItems(Game game) => game.hero.inventory;
  Action getDropAction(int index) => new DropInventoryAction(index);
  Action getUseAction(int index) => new UseAction(index, false);
}

/// An [ItemView] for items in the hero's [Equipment].
class _EquipmentView implements _ItemView {
  String get dropQuery => 'Unequip and drop which item?';
  String get useQuery => 'Unequip which item?';
  _ItemView get next => new _GroundView();

  Iterable<Item> getItems(Game game) => game.hero.equipment;
  Action getDropAction(int index) => new DropEquipmentAction(index);
  Action getUseAction(int index) => new UnequipAction(index);
}

/// An [ItemView] for items on the ground where the hero is standing.
class _GroundView implements _ItemView {
  String get dropQuery => throw "unreachable";
  String get useQuery => 'Pick up and use which item?';
  _ItemView get next => new _InventoryView();

  Iterable<Item> getItems(Game game) => game.stage.itemsAt(game.hero.pos);
  Action getDropAction(int index) => throw "unreachable";
  Action getUseAction(int index) => new UseAction(index, true);
}

/// The action the user wants to perform on the selected item.
abstract class _ItemCommand {
  /// `true` if items on the ground can be used with this command.
  bool get showGroundItems => true;

  /// The query shown to the user when selecting an item in this mode from
  /// [view].
  String query(_ItemView view);

  /// Returns `true` if [item] is a valid selection for this command.
  bool canSelect(Item item);

  /// Creates an [Action] to perform this command on the item at [index] in
  /// [view].
  Action getAction(int index, _ItemView view);
}

class _DropItemCommand extends _ItemCommand {
  bool get showGroundItems => false;

  String query(_ItemView view) => view.dropQuery;
  bool canSelect(Item item) => true;
  Action getAction(int index, _ItemView view) => view.getDropAction(index);
}

class _UseItemCommand extends _ItemCommand {
  String query(_ItemView view) => view.useQuery;
  bool canSelect(Item item) => item.canUse || item.canEquip;
  Action getAction(int index, _ItemView view) => view.getUseAction(index);
}
