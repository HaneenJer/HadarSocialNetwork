import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Organization.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrganizationsInfoList extends StatelessWidget {

  final BuildContext currContext;

  OrganizationsInfoList(this.currContext);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Organization>>.value(
      value: DataBaseService().getAllOrganizations(),
      child: _OrganizationFeed(currContext),
    );
  }
}

class _OrganizationFeed extends StatelessWidget {
  final BuildContext currContext;

  _OrganizationFeed(this.currContext);

  @override
  Widget build(BuildContext context) {
    final List<Organization> organizations =
        Provider.of<List<Organization>>(context);

    List<_OrganizationInfo> organizationsTiles = [];

    if (organizations != null) {
      organizationsTiles = organizations.map((Organization organization) {
        return _OrganizationInfo(organization, currContext);
      }).toList();
    }

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          semanticChildCount:
              (organizations == null) ? 0 : organizations.length,
          padding: const EdgeInsets.only(bottom: 70.0, left: 8, right: 8),
          children: organizationsTiles,
        ),
      ),
    );
  }
}

class _OrganizationInfo extends StatelessWidget {
  final Organization organization;
  final BuildContext currContext;

  _OrganizationInfo(this.organization, this.currContext);

  _launchCaller(String number) async {
    var url = "tel:" + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(organization.name),

      children: [
        Table(
          //border: TableBorder.symmetric(),
          // columnWidths: const <int, TableColumnWidth>{
          //   0: IntrinsicColumnWidth(),
          //   1: FlexColumnWidth(),
          // },
          //defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          textDirection: TextDirection.rtl,


          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Text(
                  AppLocalizations.of(currContext).telNumberTwoDots,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    Text(
                      organization.phoneNumber + ' ',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchCaller(organization.phoneNumber);
                      },
                      child: Icon(
                        Icons.call,
                        size: 20.0,
                        color: BasicColor.clr,
                      ),
                    ),

                  ],
                ),

              ],
            ),

            TableRow(
              children: <Widget>[
                Text(
                  AppLocalizations.of(currContext).emailTwoDots,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  organization.email,

                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),

              ],
            ),
            TableRow(
              children: <Widget>[
                Text(
                  AppLocalizations.of(currContext).locationTwoDots,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  organization.location,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),

              ],
            ),
            TableRow(
              children: <Widget>[
                Text(
                  AppLocalizations.of(currContext).services,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  alignment: Alignment.topRight,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: organization.services.map((service) {
                      return Text(
                        service.description,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueGrey,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      );
                    }).toList(),
                  ),
                ),

              ],
            ),
          ],
        ),

      ],
    );
  }
}
