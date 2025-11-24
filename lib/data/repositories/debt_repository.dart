import 'package:hive/hive.dart';
import '../models/debt_model.dart';
import '../models/transaction_model.dart';
import '../models/person_model.dart';

class DebtRepository {
  Box<DebtModel> get _debtBox => Hive.box<DebtModel>('debts');
  Box<TransactionModel> get _transactionBox => Hive.box<TransactionModel>('transactions');
  Box<PersonModel> get _personBox => Hive.box<PersonModel>('persons');

  // DEBT OPERATIONS
  Future<void> addDebt(DebtModel debt) async {
    await _debtBox.put(debt.id, debt);
  }

  Future<void> updateDebt(DebtModel debt) async {
    await _debtBox.put(debt.id, debt);
  }

  Future<void> deleteDebt(String id) async {
    await _debtBox.delete(id);
    final transactions = getTransactionsByDebtId(id);
    for (var transaction in transactions) {
      await _transactionBox.delete(transaction.id);
    }
  }

  DebtModel? getDebtById(String id) => _debtBox.get(id);
  
  List<DebtModel> getAllDebts() => _debtBox.values.toList();
  
  List<DebtModel> getDebtsByType(DebtType type) {
    return _debtBox.values.where((debt) => debt.type == type).toList();
  }

  List<DebtModel> getDebtsIOwe() => getDebtsByType(DebtType.iOwe);
  
  List<DebtModel> getDebtsOwedToMe() => getDebtsByType(DebtType.owedToMe);
  
  List<DebtModel> getActiveDebts() {
    return _debtBox.values.where((debt) => !debt.isSettled).toList();
  }

  List<DebtModel> getSettledDebts() {
    return _debtBox.values.where((debt) => debt.isSettled).toList();
  }

  // TRANSACTION OPERATIONS
  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  TransactionModel? getTransactionById(String id) => _transactionBox.get(id);
  
  List<TransactionModel> getAllTransactions() {
    final transactions = _transactionBox.values.toList();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  List<TransactionModel> getTransactionsByDebtId(String debtId) {
    return _transactionBox.values
        .where((t) => t.debtId == debtId)
        .toList();
  }

  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return _transactionBox.values
        .where((t) => t.type == type)
        .toList();
  }

  // PERSON OPERATIONS
  Future<void> addPerson(PersonModel person) async {
    await _personBox.put(person.id, person);
  }

  Future<void> updatePerson(PersonModel person) async {
    await _personBox.put(person.id, person);
  }

  Future<void> deletePerson(String id) async {
    await _personBox.delete(id);
  }

  PersonModel? getPersonById(String id) => _personBox.get(id);
  
  List<PersonModel> getAllPersons() => _personBox.values.toList();
  
  PersonModel? getPersonByName(String name) {
    try {
      return _personBox.values.firstWhere(
        (p) => p.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // STATISTICS
  double getTotalDebtIOwe() {
    return getDebtsIOwe()
        .where((debt) => !debt.isSettled)
        .fold(0.0, (sum, debt) => sum + debt.remainingAmount);
  }

  double getTotalDebtOwedToMe() {
    return getDebtsOwedToMe()
        .where((debt) => !debt.isSettled)
        .fold(0.0, (sum, debt) => sum + debt.remainingAmount);
  }

  double getTotalPaid() {
    return getTransactionsByType(TransactionType.payment)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalReceived() {
    return getTransactionsByType(TransactionType.received)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  int getActiveDebtsCount() => getActiveDebts().length;
  
  int getSettledDebtsCount() => getSettledDebts().length;

  // CLEAR ALL
  Future<void> clearAllData() async {
    await _debtBox.clear();
    await _transactionBox.clear();
    await _personBox.clear();
  }
}