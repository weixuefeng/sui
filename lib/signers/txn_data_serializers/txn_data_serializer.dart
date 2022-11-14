
import 'package:sui/serialization/base64_buffer.dart';
import 'package:sui/types/common.dart';
import 'package:sui/types/objects.dart';

class TransferObjectTransaction {
  ObjectId objectId;
  ObjectId? gasPayment;
  int gasBudget;
  SuiAddress recipient;

  TransferObjectTransaction(this.objectId, this.gasPayment, this.gasBudget, this.recipient);
}

class TransferSuiTransaction {
  ObjectId suiObjectId;
  int gasBudget;
  SuiAddress recipient;
  int? amount;

  TransferSuiTransaction(this.suiObjectId, this.gasBudget, this.recipient, this.amount);
}

/// Send Coin<T> to a list of addresses, where `T` can be any coin type, following a list of amounts,
/// The object specified in the `gas` field will be used to pay the gas fee for the transaction.
/// The gas object can not appear in `input_coins`. If the gas object is not specified, the RPC server
/// will auto-select one.
class PayTransaction {
  List<ObjectId> inputCoins;
  List<SuiAddress> recipients;
  List<int> amounts;
  ObjectId? gasPayment;
  int gasBudget;

  PayTransaction(this.inputCoins, this.recipients, this.amounts, this.gasPayment, this.gasBudget);
}

/// Send SUI coins to a list of addresses, following a list of amounts.
/// This is for SUI coin only and does not require a separate gas coin object.
/// Specifically, what pay_sui does are:
/// 1. debit each input_coin to create new coin following the order of
/// amounts and assign it to the corresponding recipient.
/// 2. accumulate all residual SUI from input coins left and deposit all SUI to the first
/// input coin, then use the first input coin as the gas coin object.
/// 3. the balance of the first input coin after tx is sum(input_coins) - sum(amounts) - actual_gas_cost
/// 4. all other input coints other than the first one are deleted.
class PaySuiTransaction {
  List<ObjectId> inputCoins;
  List<SuiAddress> recipients;
  List<int> amounts;
  int gasBudget;

  PaySuiTransaction(this.inputCoins, this.recipients, this.amounts, this.gasBudget);
}

/// Send all SUI coins to one recipient.
/// This is for SUI coin only and does not require a separate gas coin object.
/// Specifically, what pay_all_sui does are:
/// 1. accumulate all SUI from input coins and deposit all SUI to the first input coin
/// 2. transfer the updated first coin to the recipient and also use this first coin as gas coin object.
/// 3. the balance of the first input coin after tx is sum(input_coins) - actual_gas_cost.
/// 4. all other input coins other than the first are deleted.
class PayAllSuiTransaction {
  List<ObjectId> inputCoins;
  SuiAddress recipient;
  int gasBudget;

  PayAllSuiTransaction(this.inputCoins, this.recipient, this.gasBudget);
}

class MergeCoinTransaction {
  ObjectId primaryCoin;
  ObjectId coinToMerge;
  ObjectId? gasPayment;
  int gasBudget;

  MergeCoinTransaction(this.primaryCoin, this.coinToMerge, this.gasPayment, this.gasBudget);
}

class SplitCoinTransaction {
  ObjectId coinObjectId;
  List<int> splitAmounts;
  ObjectId? gasPayment;
  int gasBudget;

  SplitCoinTransaction(this.coinObjectId, this.splitAmounts, this.gasPayment, this.gasBudget);
}

class MoveCallTransaction {
  ObjectId packageObjectId;
  String module;
  String function;
  List<dynamic> typeArguments;
  List<dynamic> arguments;
  ObjectId? gasPayment;
  int gasBudget;

  MoveCallTransaction(
    this.packageObjectId, 
    this.module, 
    this.function, 
    this.typeArguments, 
    this.arguments, 
    this.gasPayment, 
    this.gasBudget
  );
}

enum UnserializedSignableTransaction {
  moveCall,  // MoveCallTransaction
  transferSui,  // TransferSuiTransaction
  transferObject,  // TransferObjectTransaction
  mergeCoin,  // MergeCoinTransaction
  splitCoin,  // SplitCoinTransaction
  pay,  // PayTransaction
  paySui,  // PaySuiTransaction
  payAllSui,  // PayAllSuiTransaction
  publish,  // PublishTransaction
  bytes  // Uint8Array
}

class SignableTransaction {
  UnserializedSignableTransaction kind;
  dynamic data;

  SignableTransaction(this.kind, this.data);
}

class PublishTransaction {
  List<String> compiledModules;
  ObjectId? gasPayment;
  int gasBudget;

  PublishTransaction(this.compiledModules, this.gasPayment, this.gasBudget);
}

mixin TxnDataSerializer {
  Future<Base64DataBuffer> newTransferObject(
    SuiAddress signerAddress,
    TransferObjectTransaction txn
  );

  Future<Base64DataBuffer> newTransferSui(
    SuiAddress signerAddress,
    TransferSuiTransaction txn
  );

  Future<Base64DataBuffer> newPay(
    SuiAddress signerAddress,
    PayTransaction txn
  );

  Future<Base64DataBuffer> newPaySui(
    SuiAddress signerAddress,
    PaySuiTransaction txn
  );

  Future<Base64DataBuffer> newPayAllSui(
    SuiAddress signerAddress,
    PayAllSuiTransaction txn
  );

  Future<Base64DataBuffer> newMoveCall(
    SuiAddress signerAddress,
    MoveCallTransaction txn
  );

  Future<Base64DataBuffer> newMergeCoin(
    SuiAddress signerAddress,
    MergeCoinTransaction txn
  );

  Future<Base64DataBuffer> newSplitCoin(
    SuiAddress signerAddress,
    SplitCoinTransaction txn
  );

  Future<Base64DataBuffer> newPublish(
    SuiAddress signerAddress,
    PublishTransaction txn
  );

}