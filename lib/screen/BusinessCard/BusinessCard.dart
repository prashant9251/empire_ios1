import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class BusinessCard extends StatelessWidget {
  BusinessCard({key, required this.masterModel});
  MasterModel masterModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(width: 40, child: const CircleAvatar(radius: 20, child: Icon(Icons.person, size: 30))),
                Flexible(
                  child: Text(
                    ' ${masterModel.partyname ?? ""}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
            if ((masterModel.broker ?? "").isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.business_center, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        masterModel.broker ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.pinkAccent,
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            GestureDetector(
              onTap: () {
                var shareText = '${masterModel.partyname ?? ""}\n';
                shareText += 'EMAIL:-${masterModel.eML ?? ""}\n';
                shareText += 'ADDRESS:-${masterModel.partyname ?? ""}\n';
                shareText += '${masterModel.aD1 ?? ""}\n';
                shareText += '${masterModel.aD2 ?? ""},${masterModel.pNO ?? ""}\n';
                shareText += 'GST:-${masterModel.gST ?? ""}\n';
                shareText += '${masterModel.mO ?? ""},${masterModel.pH1 ?? ""},${masterModel.pH2 ?? ""}';
                SharePlus.instance.share(ShareParams(
                  text: shareText,
                  subject: 'Business Card of ${masterModel.partyname ?? ""}',
                ));
              },
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      '${masterModel.aD1 ?? ""}, ${masterModel.aD2 ?? ""}, ${masterModel.city ?? ""}, ${masterModel.pNO ?? ""},',
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(FontAwesomeIcons.share, color: Colors.blueGrey, size: 16),
                ],
              ),
            ),
            SizedBox(height: 10),
            if ((masterModel.gST ?? "").isNotEmpty)
              GestureDetector(
                onTap: () {
                  var gstText = "PARTY :" + (masterModel.partyname ?? "") + "\n";
                  gstText += "GSTIN: " + (masterModel.gST ?? "") + "\n";
                  gstText += "TRANSPORT: " + (masterModel.tRSPT ?? "");
                  gstText += "\n\nFrom: " + (loginUserModel.sHOPNAME ?? "");
                  SharePlus.instance.share(ShareParams(
                    text: gstText,
                    subject: 'GST Details of ${masterModel.partyname ?? ""}',
                  ));
                },
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Gstin: ${masterModel.gST ?? ""}',
                        style: const TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(FontAwesomeIcons.share, color: Colors.blueGrey, size: 16),
                  ],
                ),
              ),
            if (masterModel.dhara != null && masterModel.dhara != "" && masterModel.dhara != "0")
              Text(
                'Dhara: ${masterModel.dhara ?? ""}',
                style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  color: Colors.blueGrey,
                ),
              ),
            const Divider(height: 30, thickness: 1),
            if ((masterModel.mO ?? "").isNotEmpty)
              GestureDetector(
                onTap: () {
                  Myf.dialNo([masterModel.mO ?? ""], context);
                },
                child: InfoRow(
                  icon: Icons.phone,
                  text: '+91 ${masterModel.mO ?? ""}',
                ),
              ),
            if ((masterModel.pH1 ?? "").isNotEmpty)
              GestureDetector(
                onTap: () {
                  Myf.dialNo([masterModel.pH1 ?? ""], context);
                },
                child: InfoRow(
                  icon: Icons.phone,
                  text: '+91 ${masterModel.pH1 ?? ""}',
                ),
              ),
            if ((masterModel.pH2 ?? "").isNotEmpty)
              GestureDetector(
                onTap: () {
                  Myf.dialNo([masterModel.pH2 ?? ""], context);
                },
                child: InfoRow(
                  icon: Icons.phone,
                  text: '+91 ${masterModel.pH2 ?? ""}',
                ),
              ),
            const SizedBox(height: 10),
            if ((masterModel.eML ?? "").isNotEmpty)
              GestureDetector(
                onTap: () {
                  Myf.launchurl(Uri.parse('mailto:${masterModel.eML ?? ""}'));
                },
                child: InfoRow(
                  icon: Icons.email,
                  text: '${masterModel.eML ?? ""}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
