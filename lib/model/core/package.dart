import 'dart:convert';

import 'package:flutter/material.dart';

class Package {
  String id;
  String name;
  String state;
  String contact;
  dynamic items = [];
  Package({
    @required this.id,
    @required this.name,
    @required this.state,
    @required this.contact,
    @required this.items,
  });

  Package copyWith({
    String id,
    String name,
    String state,
    String contact,
    dynamic items,
  }) {
    return Package(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      contact: contact ?? this.contact,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'contact': contact,
      'items': items,
    };
  }

  factory Package.removeAnItem(Package pack, Map<String, dynamic> item) {
    pack.items.remove(item);
    return pack;
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      state: map['state'] ?? '',
      contact: map['contact'] ?? '',
      items: map['items'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Package(id: $id, name: $name, state: $state, contact: $contact, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Package &&
        other.id == id &&
        other.name == name &&
        other.state == state &&
        other.contact == contact &&
        other.items == items;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        state.hashCode ^
        contact.hashCode ^
        items.hashCode;
  }
}
