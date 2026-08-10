// implementation of input states

import 'denomination.dart';

class ChangeEntry {
    const ChangeEntry(this.denomination, this.count)
        : assert(count >= 0, 'Count must be non-negative');
    
    final DenominationValue denomination;
    final int count;

    // total value of this entry in centavos
    int get centavos => denomination.centavos * count;

    @override
    String toString() => '$count x ${denomination.label}';

    @override
    bool operator ==(Object other) =>
        other is ChangeEntry &&
        other.denomination == denomination &&
        other.count == count;

    @override
    int get hashCode => Object.hash(denomination, count);
}

// error handler
enum ChangeError {
    // user input bill is not enough to pay owed
    insufficientPayment,

    // user input is outside of supported range 0 <= input <= 1000
    owedOutOfRange,

    // user input is either negative, or not a real banknote
    invalidBill,
}

// sealed because we want to restrict the possible subclasses of ChangeResult to only ChangeSuccess and ChangeFailure
sealed class ChangeResult {
    const ChangeResult();
}

final class ChangeSuccess extends ChangeResult {
    const ChangeSuccess({required this.entries, required this.totalPesos});

    final List<ChangeEntry> entries;

    // owed amount in pesos
    final int totalPesos;

    bool get isNoChangeDue => entries.isEmpty;

    @override
    String toString() => 'ChangeSuccess(P$totalPesos, $entries)';
}

final class ChangeFailure extends ChangeResult {
    const ChangeFailure(this.error);

    final ChangeError error;

    @override
    String toString() => 'ChangeFailure(${error.name})';
}