import 'package:app/constants/constants.dart';
import 'package:app/enums.dart';
import 'package:app/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SortButton extends StatelessWidget {
  final List<String> fields;
  final void Function(SongSortConfig sortConfig)? onMenuItemSelected;
  String currentField;
  SortOrder currentOrder;

  static const sortFields = {
    'track': 'Track number',
    'disc': 'Disc number',
    'title': 'Title',
    'album_name': 'Album',
    'artist_name': 'Artist',
    'created_at': 'Recently added',
    'length': 'Length',
  };

  SortButton({
    Key? key,
    required this.fields,
    required this.currentField,
    required this.currentOrder,
    this.onMenuItemSelected,
  }) : super(key: key) {
    assert(fields.isNotEmpty);
    assert(fields.every((field) => sortFields.containsKey(field)));
    assert(fields.contains(currentField));
  }

  PopupMenuItem<String> buildMenuItem(String field, String label) {
    var active = field == currentField;
    var style = active ? const TextStyle(color: AppColors.white) : null;

    return PopupMenuItem<String>(
      value: field,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
            child: Text(
              active ? (currentOrder == SortOrder.asc ? '↓ ' : '↑ ') : '',
              style: style,
            ),
          ),
          Text(label, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(-12, 48),
      icon: const Icon(CupertinoIcons.sort_down, size: 24),
      onSelected: (item) {
        if (item == currentField) {
          currentOrder =
              currentOrder == SortOrder.asc ? SortOrder.desc : SortOrder.asc;
        } else {
          currentOrder = SortOrder.asc;
        }

        currentField = item;

        onMenuItemSelected?.call(
          SongSortConfig(
            field: item,
            order: currentOrder,
          ),
        );
      },
      itemBuilder: (_) {
        List<PopupMenuEntry<String>> widgets = [];

        fields.forEach((field) {
          widgets
            ..add(buildMenuItem(field, sortFields[field]!))
            ..add(const PopupMenuDivider(height: .5));
        });

        return widgets.toList()..removeLast();
      },
    );
  }
}
