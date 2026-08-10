// derived from sample Change: 1 P20 bill, 1 P5 coin. for labelling
enum DenominationType {bill, coin}

// all philippine currency denomination as of 2026
enum DenominationValue {
    peso1000(centavos: 100000, type: DenominationType.bill, display: 'P1000'),
    peso500(centavos: 50000, type: DenominationType.bill, display: 'P500'),
    peso200(centavos: 20000, type: DenominationType.bill, display: 'P200'),
    peso100(centavos: 10000, type: DenominationType.bill, display: 'P100'),
    peso50(centavos: 5000, type: DenominationType.bill, display: 'P50'),
    peso20Bill(centavos: 2000, type: DenominationType.bill, display: 'P20'),
    peso20Coin(centavos: 2000, type: DenominationType.coin, display: 'P20'),
    peso10(centavos: 1000, type: DenominationType.coin, display: 'P10'),
    peso5(centavos: 500, type: DenominationType.coin, display: 'P5'),
    peso1(centavos: 100, type: DenominationType.coin, display: 'P1'),
    sentimo25(centavos: 25, type: DenominationType.coin, display: '25¢'),
    sentimo10(centavos: 10, type: DenominationType.coin, display: '10¢'),
    sentimo5(centavos: 5, type: DenominationType.coin, display: '5¢'),
    sentimo1(centavos: 1, type: DenominationType.coin, display: '1¢');

    const DenominationValue({
        required this.centavos, 
        required this.type, 
        required this.display
    });
    
    // face value conversion. P20 is 2000 centavos, P1 is 100 centavos, 25¢ is 25 centavos, etc.
    final int centavos;
    final DenominationType type;
    // Face value as text, without the type suffix
    final String display;

    // truncate centavos for now, all inputs from the docs point to no decimals
    int get pesos => centavos ~/ 100;

    // spec format for labelling, e.g. "P20 bill", "P5 coin"
    String get label => `$display ${type.name}`;

    // greedy loop, higher denominations first before checking for lower denominations
    static const List<DenominationValue> forChange = [
        peso1000,
        peso500,
        peso200,
        peso100,
        peso50,
        peso20Bill,
        peso20Coin,
        peso10,
        peso5,
        peso1,
    ]

    // did not include 20 peso coin, specs only specified "Bills" data type
    static const List<DenominationValue> acceptedBills [
        peso1000,
        peso500,
        peso200,
        peso100,
        peso50,
        peso20Bill
    ]

    // check if user input is a valid bill denomination
    static bool isAcceptedBill(int pesos)=>
        acceptedBills.any((bill) => bill.pesos == pesos);
}