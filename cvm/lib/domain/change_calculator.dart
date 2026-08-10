import 'change_result.dart';
import 'denomination.dart';

// Largest possible owed the system supports
// specified by Owed: The amount owed by the user. 
// Whole number in the range 0 <= owed <= 1000.
const int maxOwed = 1000;

ChangeResult getChange(int bill, int owed) {
    // range check first before doing any calculations, throw error once out of range
    if (owed < 0 || owed > maxOwed){
        return const ChangeFailure(ChangeError.owedOutOfRange);
    }

    // handle case where input is 0 as shown here 
    // Code must pass the following tests:
    //    Bill: 0
    //    Owed: 0
    final isFreeTransaction = bill == 0 && owed == 0;
    if (!isFreeTransaction && !DenominationValue.isAcceptedBill(bill)) {
        return const ChangeFailure(ChangeError.invalidBill);
    }
    if (owed > bill) {
        return const ChangeFailure(ChangeError.insufficientPayment);
    }

    final totalPesos = bill - owed;
    return ChangeSuccess(
        entries: _calculateChange(totalPesos * 100), 
        totalPesos: totalPesos
    );
}

// helper function to calculate change entries based on the total owed amount in pesos
List<ChangeEntry> _calculateChange(int centavos) {
    final entries = <ChangeEntry>[];
    var remaining = centavos;

    for (final denomination in DenominationValue.forChange) {
        if (remaining < denomination.centavos) continue;
        final count = remaining ~/ denomination.centavos;
        remaining -= count * denomination.centavos;
        entries.add(ChangeEntry(denomination, count));
    }

    assert(remaining == 0, 'P1 is in forChange, so remaining should be 0');
    return List.unmodifiable(entries);
}