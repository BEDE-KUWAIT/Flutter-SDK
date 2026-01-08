class InitiatePaymentRequest {
  final String dbRqst;
  final AppInfo doAppinfo;
  final MerchantDetails doMerchDtl;
  final MoreDetails doMoreDtl;
  final PayerDetails doPyrDtl;
  final List<TransactionDetails> doTxnDtl;
  final TransactionHeader doTxnHdr;

  InitiatePaymentRequest({
    required this.dbRqst,
    required this.doAppinfo,
    required this.doMerchDtl,
    required this.doMoreDtl,
    required this.doPyrDtl,
    this.doTxnDtl = const [],
    required this.doTxnHdr,
  });

  InitiatePaymentRequest copyWith({
    String? dbRqst,
    AppInfo? doAppinfo,
    MerchantDetails? doMerchDtl,
    MoreDetails? doMoreDtl,
    PayerDetails? doPyrDtl,
    List<TransactionDetails>? doTxnDtl,
    TransactionHeader? doTxnHdr,
  }) => InitiatePaymentRequest(
    dbRqst: dbRqst ?? this.dbRqst,
    doAppinfo: doAppinfo ?? this.doAppinfo,
    doMerchDtl: doMerchDtl ?? this.doMerchDtl,
    doMoreDtl: doMoreDtl ?? this.doMoreDtl,
    doPyrDtl: doPyrDtl ?? this.doPyrDtl,
    doTxnDtl: doTxnDtl ?? this.doTxnDtl,
    doTxnHdr: doTxnHdr ?? this.doTxnHdr,
  );

  Map<String, dynamic> toJson() => {
    "DBRqst": dbRqst,
    "Do_Appinfo": doAppinfo.toJson(),
    "Do_MerchDtl": doMerchDtl.toJson(),
    "Do_MoreDtl": doMoreDtl.toJson(),
    "Do_PyrDtl": doPyrDtl.toJson(),
    "Do_TxnDtl": List<dynamic>.from(doTxnDtl.map((x) => x.toJson())),
    "Do_TxnHdr": doTxnHdr.toJson(),
  };
}

class AppInfo {
  final String appTyp;
  final String appVer;
  final String apiVer;
  final String? devcType;
  final String? os;

  AppInfo({required this.appTyp, required this.appVer, required this.apiVer, this.devcType, this.os});

  Map<String, dynamic> toJson() => {"AppTyp": appTyp, "AppVer": appVer, "ApiVer": apiVer, "DevcType": devcType, "OS": os};
}

class MerchantDetails {
  final String merchantID;
  final String bkyPrdenum;
  final String failureUrl;
  final String successUrl;

  MerchantDetails({required this.merchantID, required this.failureUrl, required this.successUrl}) : bkyPrdenum = 'Ecom';

  Map<String, dynamic> toJson() => {"MerchUID": merchantID, "BKY_PRDENUM": bkyPrdenum, "FURL": failureUrl, "SURL": successUrl};
}

class MoreDetails {
  final String custData1;
  final String custData2;
  final String custData3;

  MoreDetails({this.custData1 = "", this.custData2 = "", this.custData3 = ""});

  Map<String, dynamic> toJson() => {"Cust_Data1": custData1, "Cust_Data2": custData2, "Cust_Data3": custData3};
}

class PayerDetails {
  final String phone;
  final String countryCode;
  final String name;

  PayerDetails({this.phone = "", this.countryCode = "", this.name = ""});

  Map<String, dynamic> toJson() => {"Pyr_MPhone": phone, "ISDNCD": countryCode, "Pyr_Name": name};
}

class TransactionDetails {
  final String subMerchUid;
  final num txnAmt;

  TransactionDetails({required this.subMerchUid, required this.txnAmt});

  Map<String, dynamic> toJson() => {"SubMerchUID": subMerchUid, "Txn_AMT": txnAmt};
}

class TransactionHeader {
  final String merchTxnUid;
  final String payFor;
  final String payMethod;
  final String txnHdr;
  final String hashMac;
  final String? bkyTxnUid;

  TransactionHeader({
    required this.merchTxnUid,
    required this.payFor,
    required this.payMethod,
    required this.txnHdr,
    required this.hashMac,
    this.bkyTxnUid,
  });

  Map<String, dynamic> toJson() => {
    "Merch_Txn_UID": merchTxnUid,
    "PayFor": payFor,
    "PayMethod": payMethod,
    "Txn_HDR": txnHdr,
    "hashMac": hashMac,
    "BKY_Txn_UID": bkyTxnUid,
  };
}
