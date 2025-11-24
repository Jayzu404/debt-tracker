import 'package:flutter/material.dart';
import '../../data/models/debt_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/person_model.dart';
import '../../data/repositories/debt_repository.dart';
import '../../core/utils/date_utils.dart';

class DebtProvider extends ChangeNotifier {
  final DebtRepository _repository = DebtRepository();

  List<DebtModel> get allDebts => _repository.getAllDebts();
  List<DebtModel> get debtsIOwe => _repository.getDebtsIOwe();
  List<DebtModel> get debtsOwedToMe => _repository.getDebtsOwedToMe();
  List<DebtModel> get activeDebts => _repository.getActiveDebts();
  List<TransactionModel> get allTransactions => _repository.getAllTransactions();

  double get totalDebtIOwe => _repository.getTotalDebtIOwe();
  double get totalDebtOwedToMe => _repository.getTotalDebtOwedToMe();
  int get activeDebtsCount => _repository.getActiveDebtsCount();
  int get settledDebtsCount => _repository.getSettledDebtsCount();

  Future<void> addDebt({
    required String personName,
    required double amount,
    required DebtType type,
    String description = '',
  }) async {
    final person = _repository.getPersonByName(personName) ??
        PersonModel(
          id: AppDateUtils.generateId(),
          name: personName,
          createdAt: DateTime.now(),
        );

    if (_repository.getPersonByName(personName) == null) {
      await _repository.addPerson(person);
    }

    final debt = DebtModel(
      id: AppDateUtils.generateId(),
      personId: person.id,
      personName: personName,
      amount: amount,
      type: type,
      description: description,
      createdAt: DateTime.now(),
    );

    await _repository.addDebt(debt);
    notifyListeners();
  }

  Future<void> updateDebt(DebtModel debt) async {
    await _repository.updateDebt(debt.copyWith(updatedAt: DateTime.now()));
    notifyListeners();
  }

  Future<void> deleteDebt(String id) async {
    await _repository.deleteDebt(id);
    notifyListeners();
  }

  Future<void> recordPayment({
    required DebtModel debt,
    required double amount,
    String note = '',
  }) async {
    final newPaidAmount = debt.paidAmount + amount;
    final isSettled = newPaidAmount >= debt.amount;

    final updatedDebt = debt.copyWith(
      paidAmount: newPaidAmount,
      isSettled: isSettled,
      updatedAt: DateTime.now(),
    );

    await _repository.updateDebt(updatedDebt);

    final transaction = TransactionModel(
      id: AppDateUtils.generateId(),
      debtId: debt.id,
      personName: debt.personName,
      amount: amount,
      type: debt.type == DebtType.iOwe 
          ? TransactionType.payment 
          : TransactionType.received,
      note: note,
      createdAt: DateTime.now(),
    );

    await _repository.addTransaction(transaction);
    notifyListeners();
  }

  Future<void> settleDebt(String debtId) async {
    final debt = _repository.getDebtById(debtId);
    if (debt != null) {
      final remainingAmount = debt.remainingAmount;
      if (remainingAmount > 0) {
        await recordPayment(
          debt: debt,
          amount: remainingAmount,
          note: 'Debt settled',
        );
      }
    }
  }

  List<TransactionModel> getTransactionsByDebtId(String debtId) {
    return _repository.getTransactionsByDebtId(debtId);
  }

  Future<void> clearAllData() async {
    await _repository.clearAllData();
    notifyListeners();
  }
}