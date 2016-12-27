import 'dart:html' as html;

import 'package:malison/malison.dart';

import 'package:hauberk/src/content.dart';

main() {
  var content = createContent();

  var text = new StringBuffer();
  var items = content.items.values.toList();

  items.sort((a, b) {
    if (a.depth == null && b.depth == null) {
      return a.sortIndex.compareTo(b.sortIndex);
    }

    if (a.depth == null) return -1;
    if (b.depth == null) return 1;

    return a.depth.compareTo(b.depth);
  });

  text.write('''
    <thead>
    <tr>
      <td colspan="2">Item</td>
      <td>Depth</td>
      <td>Tags</td>
      <td>Equip.</td>
      <td>Attack</td>
      <td>Armor</td>
    </tr>
    </thead>
    <tbody>
    ''');

  for (var item in items) {
    var glyph = item.appearance as Glyph;
    text.write('''
        <tr>
          <td>
<pre><span style="color: ${glyph.fore.cssColor}">${new String.fromCharCodes([glyph.char])}</span></pre>
          </td>
          <td>${item.name}</td>
        ''');

    if (item.depth == null) {
      text.write('<td>&mdash;</td>');
    } else {
      text.write('<td>${item.depth}</td>');
    }

//    if (item.categories.isEmpty) {
//      text.write('<td>&mdash;</td>');
//    } else {
//      text.write('<td>${item.categories.join("&thinsp;/&thinsp;")}</td>');
//    }
    if (item.tags.isEmpty) {
      text.write('<td>&mdash;</td>');
    } else {
      text.write('<td>${item.allTags.join(" ")}</td>');
    }

    text.write('''
          <td>${item.equipSlot != null ? item.equipSlot : "&mdash;"}</td>
          <td>
        ''');

    if (item.attack != null) {
      text.write(item.attack.averageDamage);
    } else {
      text.write('&mdash;');
    }

    text.write('<td>${item.armor != 0 ? item.armor : "&mdash;"}</td>');

    text.write('</td></tr>');
  }
  text.write('</tbody>');

  var validator = new html.NodeValidatorBuilder.common();
  validator.allowInlineStyles();

  html.querySelector('table').setInnerHtml(text.toString(),
      validator: validator);
}
