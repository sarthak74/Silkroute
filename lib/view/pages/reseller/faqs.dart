import 'package:flutter/material.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/qna.dart';
import 'package:silkroute/view/widget/topbar.dart';

import 'orders.dart';

class Faqs extends StatefulWidget {
  @override
  _FaqsState createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  List faqs = [];
  bool loading = true;
  void loadFaqs() {
    setState(() {
      for (int i = 0; i < 10; i++) {
        Map<String, String> qna = {
          "question": ("Ques - " + (i + 1).toString()).toString(),
          "answer": ("Ans - " + (i + 1).toString()).toString(),
        };
        faqs.add(qna);
      }
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFaqs();
    });
    super.initState();
  }

  bool isProfileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),

              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Icon(
                        Icons.question_answer,
                        size: 70,
                        color: Color(0xFF5B0D1B),
                      ),
                      SizedBox(height: 20),
                      QnAList(faqs: faqs),
                    ]),
                  ),
                  SliverFillRemaining(hasScrollBody: false, child: Container()),
                ]),
              ),

              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class QnAList extends StatefulWidget {
  const QnAList({this.faqs});
  final dynamic faqs;

  @override
  _QnAListState createState() => _QnAListState();
}

class _QnAListState extends State<QnAList> {
  bool isProfileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.faqs.length,
      itemBuilder: (BuildContext context, int index) {
        return QnA(faq: widget.faqs[index]);
      },
    );
  }
}
