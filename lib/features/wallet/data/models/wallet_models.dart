// lib/features/wallet/data/models/wallet_models.dart

// ── Enums ─────────────────────────────────────────────────────────────────────

enum PaymentMethod { cash, wallet, payShap }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
    PaymentMethod.cash    => 'Cash',
    PaymentMethod.wallet  => 'Wallet',
    PaymentMethod.payShap => 'PayShap',
  };

  int get value => index; // 0, 1, 2 — matches server enum
}

PaymentMethod paymentMethodFromInt(int v) =>
    PaymentMethod.values.elementAtOrNull(v) ?? PaymentMethod.cash;

enum TransactionType {
  topUp,
  rideCommission,
  p2PTransfer,
  p2PReceive,
  refund,
  adminAdjustment,
}

extension TransactionTypeX on TransactionType {
  bool get isCredit => this == TransactionType.topUp ||
      this == TransactionType.p2PReceive ||
      this == TransactionType.refund;
}

TransactionType transactionTypeFromInt(int v) =>
    TransactionType.values.elementAtOrNull(v) ?? TransactionType.topUp;

// ── Wallet ─────────────────────────────────────────────────────────────────────

class WalletResponse {
  final int     walletId;
  final String  userId;
  final double  balance;
  final DateTime updatedAt;

  const WalletResponse({
    required this.walletId,
    required this.userId,
    required this.balance,
    required this.updatedAt,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
    walletId:  json['walletId']  as int,
    userId:    json['userId']    as String,
    balance:   (json['balance']  as num).toDouble(),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

// ── Transaction ───────────────────────────────────────────────────────────────

class WalletTransaction {
  final int             id;
  final double          amount;
  final TransactionType type;
  final String          typeLabel;
  final String          description;
  final int             statusCode;
  final int?            bookingId;
  final String?         paymentReference;
  final DateTime        createdAt;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.typeLabel,
    required this.description,
    required this.statusCode,
    this.bookingId,
    this.paymentReference,
    required this.createdAt,
  });

  bool get isCredit => amount > 0;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id:               json['id']               as int,
        amount:           (json['amount']           as num).toDouble(),
        type:             transactionTypeFromInt(json['type'] as int),
        typeLabel:        json['typeLabel']         as String,
        description:      json['description']       as String,
        statusCode:       json['status']            as int,
        bookingId:        json['bookingId']         as int?,
        paymentReference: json['paymentReference']  as String?,
        createdAt:        DateTime.parse(json['createdAt'] as String),
      );
}

// ── Top-Up ────────────────────────────────────────────────────────────────────

class TopUpInitiateRequest {
  final double  amount;
  final String? returnUrl;
  final String? cancelUrl;

  const TopUpInitiateRequest({required this.amount, this.returnUrl, this.cancelUrl});

  Map<String, dynamic> toJson() => {
    'amount':    amount,
    if (returnUrl != null) 'returnUrl': returnUrl,
    if (cancelUrl != null) 'cancelUrl': cancelUrl,
  };
}

class TopUpInitiateResponse {
  final String             paymentUrl;
  final String             paymentReference;
  final double             amount;
  final Map<String,String> payFastParams;

  const TopUpInitiateResponse({
    required this.paymentUrl,
    required this.paymentReference,
    required this.amount,
    required this.payFastParams,
  });

  factory TopUpInitiateResponse.fromJson(Map<String, dynamic> json) =>
      TopUpInitiateResponse(
        paymentUrl:       json['paymentUrl']       as String,
        paymentReference: json['paymentReference'] as String,
        amount:           (json['amount']           as num).toDouble(),
        payFastParams:    (json['payFastParams'] as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      );
}

// ── P2P Transfer ──────────────────────────────────────────────────────────────

class P2PTransferRequest {
  final String  recipientUserId;
  final double  amount;
  final String? note;

  const P2PTransferRequest({
    required this.recipientUserId,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'recipientUserId': recipientUserId,
    'amount':          amount,
    if (note != null) 'note': note,
  };
}

class P2PTransferResponse {
  final bool   success;
  final double senderBalance;
  final String message;

  const P2PTransferResponse({
    required this.success,
    required this.senderBalance,
    required this.message,
  });

  factory P2PTransferResponse.fromJson(Map<String, dynamic> json) =>
      P2PTransferResponse(
        success:       json['success']       as bool,
        senderBalance: (json['senderBalance'] as num).toDouble(),
        message:       json['message']       as String,
      );
}
