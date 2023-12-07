import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
import 'package:uuid/uuid.dart';

class UPIPayment extends StatefulWidget {
  final String receiverName;
  final String receiverUpiId;
  final String eventName;
  final String eventDate;
  final double amount;
  final String eventId;
  final String location;
  UPIPayment(
      {super.key,
      required this.receiverName,
      required this.receiverUpiId,
      required this.eventName,
      required this.eventDate,
      required this.amount,
      required this.eventId,
      required this.location});

  @override
  State<UPIPayment> createState() => _UPIPaymentState();
}

class _UPIPaymentState extends State<UPIPayment> {
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  String generateTransactionRId() {
    var uuid = Uuid();
    String transactionRId = uuid.v4();
    return transactionRId;
  }

  void storeTransactionDetailsInFirestore(
      {required String userID,
      required String eventID,
      required String transactionID,
      required double amount,
      required DateTime timestamp,
      required String transactionNote}) async {
    try {
      CollectionReference transactionsCollection =
          FirebaseFirestore.instance.collection('transactions');

      // Store transaction details in Firestore
      await transactionsCollection.doc(transactionID).set({
        'userID': userID,
        'eventID': eventID,
        'transactionID': transactionID,
        'amount': amount,
        'timestamp': timestamp,
        'transactionNote': transactionNote
        // Add other transaction details as needed
        // ...
      });

      print('Transaction details stored successfully!');
    } catch (e) {
      print('Error storing transaction details: $e');
    }
  }

  //old initiateTransaction as on pubdev
  // Future<UpiResponse> initiateTransaction(UpiApp app) async {
  //   String transactionRId = generateTransactionRId();
  //   return _upiIndia.startTransaction(
  //       app: app,
  //       receiverUpiId: widget.receiverUpiId,
  //       receiverName: widget.receiverName,
  //       transactionRefId: transactionRId,
  //       transactionNote:
  //           'Ticket for ${widget.eventName} Event on ${widget.eventDate}.',
  //       amount: widget.amount,
  //       flexibleAmount: false);
  // }

  //new initiateTransaction for storing data in firebase
  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    String transactionRId = generateTransactionRId();
    try {
      UpiResponse response = await _upiIndia.startTransaction(
          app: app,
          receiverUpiId: widget.receiverUpiId,
          receiverName: widget.receiverName,
          transactionRefId: transactionRId,
          transactionNote:
              'Ticket for ${widget.eventName} Event on ${widget.eventDate}.',
          amount: widget.amount,
          flexibleAmount: false);

      // Check if the transaction was successful
      if (response.status == UpiPaymentStatus.SUCCESS) {
        // Get user and event IDs; you'll need to replace these with your actual data

        User? user = FirebaseAuth.instance.currentUser;
        String userID = user!.uid;
        String eventID = widget.eventId;

        // Store transaction details in Firestore
        storeTransactionDetailsInFirestore(
            userID: userID,
            eventID: eventID,
            transactionID: response.transactionId ?? '',
            amount: widget.amount, // Replace with the actual transaction amount
            timestamp: DateTime.now(),
            transactionNote:
                'Ticket for ${widget.eventName} Event on ${widget.eventDate}.');
      }

      return response;
    } catch (e) {
      print('Error during transaction: $e');
      throw e; // Rethrow the error to handle it as needed in your UI
    }
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      // ignore: curly_braces_in_flow_control_structures
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        style: header,
                      ), // Print's text message on screen
                    );
                  }

                  // If we have data then definitely we will have UpiResponse.
                  // It cannot be null
                  UpiResponse _upiResponse = snapshot.data!;

                  // Data in UpiResponse can be null. Check before printing
                  String txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  _checkTxnStatus(status);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(''),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
