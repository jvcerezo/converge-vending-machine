import 'package:cvm/domain/change_calculator.dart';
import 'package:cvm/domain/change_result.dart';
import 'package:cvm/domain/denomination.dart';
import 'package:flutter_test/flutter_test.dart';

// unwrap result for success
ChangeSuccess expectSuccess(ChangeResult result) {
  expect(result, isA<ChangeSuccess>(), reason: 'got $result');
  return result as ChangeSuccess;
}

// unwrap result for failure
ChangeFailure expectFailure(ChangeResult result) {
  expect(result, isA<ChangeFailure>(), reason: 'got $result');
  return result as ChangeFailure;
}

void main(){

    // four test cases specified by Romie's Docs
    group('required cases', (){
        // from test case 1
        // Bill: 0
        // Owed: 0
        test('0 bill, 0 owed => valid, no change due', (){
            final success = expectSuccess(getChange(0, 0));

            expect(success.totalPesos, 0);
            expect(success.entries, isEmpty);
            expect(success.isNoChangeDue, isTrue);
        });

        // from test case 2
        // Bill: 1000
        // Owed: 1
        test('1000 bill, 1 owed => P999 broken down from high to low', (){
            final success = expectSuccess(getChange(1000, 1));

            expect(success.totalPesos, 999);
            expect(success.entries, const [
                ChangeEntry(DenominationValue.peso500, 1),
                ChangeEntry(DenominationValue.peso200, 2),
                ChangeEntry(DenominationValue.peso50, 1),
                ChangeEntry(DenominationValue.peso20Bill, 2),
                ChangeEntry(DenominationValue.peso5, 1),
                ChangeEntry(DenominationValue.peso1, 4),
            ]);
        });
        
        // from test case 3
        // Bill: 500
        // Owed: 600
        test('500 bill, 600 owed => insufficient payment', (){
            final failure = expectFailure(getChange(500, 600));
            // use change error insufficent payment to assert the failure reason
            expect(failure.error, ChangeError.insufficientPayment);
        });

        // from test case 4
        // Bill: 100
        // Owed: 27
        test('100 bill, 27 owed => P73 broken down from high to low', (){
            final success = expectSuccess(getChange(100, 27));

            expect(success.totalPesos, 73);
            expect(success.entries, const [
                ChangeEntry(DenominationValue.peso50, 1),
                ChangeEntry(DenominationValue.peso20Bill, 1),
                ChangeEntry(DenominationValue.peso1, 3),
            ]);
        });
    });

    // additional test cases for validation
    group('validation cases', (){
        test('breakdown always sums back to the total', (){
            for (var owed = 0; owed <= 1000; owed++){
                final result = getChange(1000, owed);
                if (result is! ChangeSuccess) continue;

                final sum = result.entries
                    .fold<int>(0, (total, entry) => total + entry.centavos);
                expect(sum, result.totalPesos * 100, reason: 'owed: $owed');
            }
        });
        test('no zero-count entries and no duplicate denominations', (){
            for (var owed = 0; owed <= 1000; owed++){
                final result = getChange(1000, owed);
                if (result is! ChangeSuccess) continue;

                final seen = <DenominationValue>{};
                for (final entry in result.entries){
                    expect(entry.count, greaterThan(0), reason: 'owed: $owed');
                    expect(seen.add(entry.denomination), isTrue, 
                        reason: 'duplicate ${entry.denomination} at owed: $owed');
                }
            }
            });
        test('centavo coins are never emitted', (){
            for (var owed = 0; owed <= 1000; owed++){
                final result = getChange(1000, owed);
                if (result is! ChangeSuccess) continue;

                for (final entry in result.entries){
                    expect(entry.denomination.centavos, greaterThanOrEqualTo(100), 
                        reason: 'owed= $owed emitted ${entry.denomination.label}');
                }
            }
        });
    });
}
