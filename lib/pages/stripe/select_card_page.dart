import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/constants/constant.dart';
import 'package:flutter_stripe_payments/services/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SelectCardPage extends StatefulWidget {
  SelectCardPage({Key key}) : super(key: key);

  @override
  SelectCardPageState createState() => SelectCardPageState();
}

class SelectCardPageState extends State<SelectCardPage> {

  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        //payViaNewCard(context);
        Navigator.pushNamed(context, '/new-cards');
        break;
      case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
      case 2:
        Navigator.pushNamed(context, '/add-new-card');
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
      message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
      amount: '150',
      currency: constant.CURRENCY
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            Icon icon;
            Text text;

            switch(index) {
              case 0:
                icon = Icon(Icons.add_circle, color: theme.primaryColor);
                text = Text('Pay via new card');
                break;
              case 1:
                icon = Icon(Icons.credit_card, color: theme.primaryColor);
                text = Text('Pay via existing card');
                break;
              case 2:
                icon = Icon(Icons.add, color: theme.primaryColor);
                text = Text('Add new card');
                break;

            }

            return InkWell(
              onTap: () {
                onItemPress(context, index);
              },
              child: ListTile(
                title: text,
                leading: icon,
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: theme.primaryColor,
          ),
          itemCount: 3
        ),
      ),
    );
  }
}