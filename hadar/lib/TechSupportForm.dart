import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:hadar/profiles/profile.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';

import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/UsersInquiry.dart';

import 'Design/mainDesign.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TechSupportForm extends StatelessWidget {
  ProfilePage parent;
  BuildContext context;

  DescriptonBox desReason;
  DescriptonBox desBox;
  DescriptonBox desName;
  DescriptonBox desId;
  DescriptonBox desPhone;
  String reason;
  String description;
  String userName;
  String userId;
  String userPhone;
  HelpRequestType helpRequestType;

  TechSupportForm(ProfilePage parent, BuildContext context) {
    this.context = context;
    this.parent = parent;
    init();
  }

  void init() {
    this.desName = DescriptonBox(title: AppLocalizations.of(context).name, parent: parent);
    this.desId = DescriptonBox(title: AppLocalizations.of(context).id, parent: parent);
    this.desPhone = DescriptonBox(title: AppLocalizations.of(context).telNumber, parent: parent);
    this.desReason = DescriptonBox(title: AppLocalizations.of(context).inquiryReasonInShort, parent: parent);
    this.desBox = DescriptonBox(title: AppLocalizations.of(context).explanation, parent: parent);
  }

  Widget getRelContainer(DescriptonBox des){
    return                   Container(
      height: 100,
      child: des,
    );
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(

        bottomNavigationBar: BottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
              MySliverAppBar(expandedHeight: 150, title: AppLocalizations.of(context).inquiry),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column( children:[
                  SizedBox(
                    height: 100,
                  ),
                  getRelContainer(desName),
                  getRelContainer(desId),
                  getRelContainer(desPhone),
                  getRelContainer(desReason),
                  getRelContainer(desBox),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    onPressed: () async{
                      userName = desName.getDataEntered();
                      userId = desId.getDataEntered();
                      userPhone = desPhone.getDataEntered();
                      reason = desReason.getDataEntered();
                      description = desBox.getDataEntered();
                      print(userName);
                      print(userPhone);
                      print(reason);
                      print(description);
                      UserInquiry userInquiry= UserInquiry(userName, userId, userPhone, reason, description, DateTime.now());
                      DataBaseService().addInquryToDataBase(userInquiry);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(CurrentUser.curr_user)),
                      );
                      // Navigator.canPop(context);
                    },
                    child: Text(AppLocalizations.of(context).approve),
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}


class DescriptonBox extends StatefulWidget {
  DescriptonBox({Key key, this.title, this.parent}) : super(key: key);
  _DescriptonBox desBoxState = _DescriptonBox();
  final String title;
  final ProfilePage parent;

  void setSelectedType(HelpRequestType selectedType) {
    desBoxState.setSelectedType(selectedType);
  }

  String getDataEntered(){
    return desBoxState.getDataEntered();
  }



  HelpRequestType getHelpRequestType() {
    return desBoxState.getHelpRequestType();
  }

  @override
  _DescriptonBox createState() => desBoxState;
}

class _DescriptonBox extends State<DescriptonBox> {
  String _inputtext = 'waiting..';
  HelpRequest helpRequest;
  TextEditingController inputtextField = TextEditingController();
  HelpRequestType helpRequestType;



  void setSelectedType(HelpRequestType selectedType) {
    setState(() {
      _inputtext = selectedType.description;
    });
  }

  HelpRequestType getHelpRequestType() {
    return helpRequestType;
  }

  String getDataEntered(){
    return inputtextField.text;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: inputtextField,
                      textAlign: TextAlign.right,
                      autofocus: true,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: widget.title,
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
