import 'package:accountable/data/backend/auth.dart';
import 'package:accountable/model/MoneyAccount.dart';
import 'package:accountable/extensions/StandardColor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

extension MoneyAccountObject on MoneyAccount {
  static final String _className = "MoneyAccount";

  ParseObject serialized({bool forUpdating = false}) {
    final ParseObject object = ParseObject(_className)
      ..set("color", this.color.name)
      ..set("title", this.title)
      ..set("notes", this.notes);
    if (forUpdating) {
      object.set("objectId", this.id);
    }
    object.setACL(ParseACL(owner: currentUser()));
    return object;
  }

  static QueryBuilder<ParseObject> queryOneWithId(final String id) {
    return QueryBuilder<ParseObject>(ParseObject(_className))
      ..whereEqualTo("objectId", id);
  }

  static QueryBuilder<ParseObject> queryAllForUid(final String uid) {
    return QueryBuilder<ParseObject>(ParseObject(_className));
  }

  static MoneyAccount? fromObject(final ParseObject object) {
    return new MoneyAccount(
      id: object.get<String>("objectId"),
      color: StandardColorExtension.fromRaw(object.get<String>("color")!),
      title: object.get<String>("title")!,
      notes: object.get<String>("notes"),
    );
  }
}
