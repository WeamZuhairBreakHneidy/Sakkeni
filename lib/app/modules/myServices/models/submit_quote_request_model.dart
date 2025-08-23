class SubmitQuoteRequest {
  final String scopeOfWork;
  final String amount;
  final String startDate;

  SubmitQuoteRequest({
    required this.scopeOfWork,
    required this.amount,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
    'scope_of_work': scopeOfWork,
    'amount': amount,
    'start_date': startDate,
  };
}
