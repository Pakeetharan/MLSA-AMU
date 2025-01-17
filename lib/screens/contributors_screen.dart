import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mlsa_amu/api/api.dart';
import 'package:mlsa_amu/models/contributors.dart';
import 'package:mlsa_amu/models/repo_details.dart';
import 'package:mlsa_amu/utils/size_config.dart';
import 'package:mlsa_amu/widgets/contributors_details_card.dart';

class ContributorsScreen extends StatefulWidget {
  const ContributorsScreen({Key? key}) : super(key: key);

  @override
  _ContributorsScreenState createState() => _ContributorsScreenState();
}

class _ContributorsScreenState extends State<ContributorsScreen> {
  RepoDetailsModel repoDetails = RepoDetailsModel();
  @override
  void initState() {
    API().fetchRepoDetails().then((value) {
      if (value != null) {
        repoDetails = RepoDetailsModel.fromJson(value);
        API().fetchContributors(repoDetails.contributorsUrl!).then((value) {
          if (value != null) {
            value.forEach((item) {
              ContributorsModel contributorsModel = ContributorsModel.fromJson(item);
              repoDetails.contributorsList!.add(contributorsModel);
            });
          }
          setState(() {});
        });
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF17181C),
      appBar: AppBar(
        title: Text(
          "Contributors",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: repoDetails.contributorsList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/mlsa-logo.png",
                          height: SizeConfig.iconGeneralHeightAndWidth,
                          width: SizeConfig.iconGeneralHeightAndWidth,
                        ),
                        SizedBox(width: 5),
                        Text(
                          repoDetails.repoName!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.baseFontSize * 7,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 2,
                      ),
                      child: Text(
                        repoDetails.repoDescription!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: SizeConfig.baseFontSize * 4,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 2,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          getHeaderView(
                            FontAwesomeIcons.star,
                            repoDetails.stars!,
                            "stars",
                            iconColor: Colors.yellow,
                          ),
                          getHeaderView(
                            FontAwesomeIcons.codeBranch,
                            repoDetails.forks!,
                            "forks",
                          ),
                          getHeaderView(
                            FontAwesomeIcons.dotCircle,
                            repoDetails.openIssues!,
                            "issues",
                            iconColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 30,
                    ),
                    Text(
                      "Contributors",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.baseFontSize * 5.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: repoDetails.contributorsList!.length,
                      itemBuilder: (context, index) {
                        return ContributorDetailsCard(
                          repoDetails.contributorsList![index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget getHeaderView(
    IconData iconData,
    int data,
    String dataText, {
    Color iconColor = Colors.grey,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.safeBlockVertical * 0.6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: SizeConfig.iconGeneralHeightAndWidth * 0.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 2,
            ),
            child: Text(
              data.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.baseFontSize * 4.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: SizeConfig.safeBlockHorizontal * 2.5,
            ),
            child: Text(
              dataText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: SizeConfig.baseFontSize * 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
