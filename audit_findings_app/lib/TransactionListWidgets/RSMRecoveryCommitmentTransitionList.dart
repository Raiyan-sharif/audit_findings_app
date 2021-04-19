import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RSMRecoveryCommitmentTransitionList extends StatelessWidget {
  final List<RSMRecoveryCommitment> transactions;
  final Function deleteTX;
  RSMRecoveryCommitmentTransitionList(this.transactions,this.deleteTX);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
      children: [
        Text(
          'No Transaction added yet!',
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 20,
        ),
        Image.asset(
          'assets/images/waiting.png',
          fit: BoxFit.cover,
          height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top ) * 0.4,
        )
      ],
    )
        : ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  child: Text('\$${transactions[index].customerInfoId}'),
                ),
              ),
            ),
            title: Text(
              transactions[index].amount.toString(),
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(transactions[index].date),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete,
                color: Theme.of(context).errorColor,),
              onPressed: () => deleteTX(transactions[index].id),
            ),
          ),
        );
      },
      itemCount: transactions.length,
//        children: transactions .map((tx) {
//
//        }).toList(),
    );
  }
}
