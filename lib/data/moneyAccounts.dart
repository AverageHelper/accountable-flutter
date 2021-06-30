import 'package:accountable/model/MoneyAccount.dart';
import 'package:accountable/model/StandardColor.dart';
import 'package:flutter/material.dart';

Map<String, MoneyAccount>? loadedAccounts;

List<Function(Map<String, MoneyAccount>)> accountSubscribers = [];
Map<String, Function(MoneyAccount?)> singleAccountSubscribers = {};

/// Caches and returns all of the user's known money accounts.
/// Also starts watching the user's accounts for changes. The
/// cache will be updated accordingly.
VoidCallback watchMoneyAccountsForUser(Function(Map<String, MoneyAccount>) cb) {
  // TODO: Call onSnapshot instead; call cb with new sorted data
  if (loadedAccounts == null) {
    loadedAccounts = new Map();
  }

  accountSubscribers.add(cb);
  cb(loadedAccounts!);

  return () {
    accountSubscribers.remove(cb);
  };
}

VoidCallback watchMoneyAccountWithId(String id, Function(MoneyAccount?) cb) {
  // TODO: Call onSnapshot instead; call cb with new data
  MoneyAccount? account = loadedAccounts?[id];

  singleAccountSubscribers[id] = cb;
  cb(account);

  return () {
    singleAccountSubscribers.remove(id);
  };
}

/// Creates a new money account for the user.
Future<MoneyAccount> createMoneyAccount({
  required String title,
  required String? notes,
  required StandardColor? color,
}) async {
  MoneyAccount newAccount = new MoneyAccount(
    title: title,
    notes: notes,
    color: color,
  );

  // TODO: Talk to the server instead; let the watchers handle updating the cache and listeners
  loadedAccounts!.putIfAbsent(newAccount.id, () => newAccount);
  accountSubscribers.forEach((cb) => cb(loadedAccounts!));
  singleAccountSubscribers.forEach((id, cb) {
    if (id == newAccount.id) {
      cb(newAccount);
    }
  });

  return newAccount;
}
