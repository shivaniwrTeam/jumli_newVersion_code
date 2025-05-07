class BankAccountDetails {
  final String accountHolderName;
  final String accountNumber;
  final String bankName;
  final String bankTransferStatus;
  final String ifscSwiftCode;

  BankAccountDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.bankName,
    required this.bankTransferStatus,
    required this.ifscSwiftCode,
  });

  factory BankAccountDetails.fromJson(Map<String, dynamic> json) {
    return BankAccountDetails(
      accountHolderName: json['account_holder_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankTransferStatus: json['bank_transfer_status'] ?? '',
      ifscSwiftCode: json['ifsc_swift_code'] ?? '',
    );
  }
}
