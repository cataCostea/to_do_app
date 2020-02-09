import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/quick_note_model.dart';
import '../../providers/dashboard_provider.dart';
import '../../utils/form_validations.dart';

class AddQuickNote extends StatefulWidget {
  @override
  _AddQuickNoteState createState() => _AddQuickNoteState();
}

class _AddQuickNoteState extends State<AddQuickNote> {
  GlobalKey<FormState> _quickNoteForm = GlobalKey<FormState>();
  TextEditingController quickNoteController = TextEditingController();
  DashboardProvider dashProvider;

  @override
  void didChangeDependencies() {
    dashProvider = Provider.of<DashboardProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        child: SafeArea(
          child: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.close),
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        buildForm(),
                        suggestionsArea(),
                        priorityArea(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      ),
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Form(
        key: _quickNoteForm,
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: quickNoteController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  scrollPadding: EdgeInsets.only(bottom: 100.0),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                      fontSize: 20.0,
                    ),
                    hintText: "Write your quick note",
                  ),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7),
                    fontSize: 20.0,
                  ),
                  // onSaved: (String value) => value != ''
                  //     ? getIt<AppModel>().onSaved("CEP", value)
                  //     : null,
                  validator: Validations().mandatoryAndLength,
                ),
              ),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  offset: Offset(0.0, 3.0),
                  blurRadius: 2.0,
                  spreadRadius: 1.0)
            ],
          ),
          child: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        onTap: () {
          var isValid = _quickNoteForm.currentState.validate();
          if (isValid) {
            dashProvider.addQuickNote(QuickNote(
              date: dashProvider.stringDate,
              isChecked: false,
              noteContent: quickNoteController.text,
              priority: dashProvider.priority,
            ));
            dashProvider.getQuickNotes(dashProvider.stringDate);
            Navigator.pop(context);
          }
        });
  }

  Widget suggestionsArea() {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Suggestions',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          Container(
            child: Wrap(
              children: <Widget>[
                suggestion("Appointment with ",
                    Theme.of(context).colorScheme.primary.withOpacity(0.25)),
                suggestion(
                    "Go to the gym",
                    Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.25)),
                suggestion(
                    "Email to ",
                    Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.25)),
                suggestion(
                    "Subscription for ", Color(0xFF878CAC).withOpacity(0.25)),
                suggestion("Read ", Color(0xFF878CAC).withOpacity(0.25)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget suggestion(String suggestion, Color color) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            suggestion,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        onTap: () {
          quickNoteController.text = suggestion;
        });
  }

  Widget priorityArea() {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Priority',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              priorityButton(Color(0xFF707070), 'None', dashProvider.none),
              priorityButton(Color(0xFFF3C018), 'Medium', dashProvider.medium),
              priorityButton(Color(0xFFFF4A4A), 'High', dashProvider.high),
            ],
          )),
        ],
      ),
    );
  }

  Widget priorityButton(Color color, String priority, bool isSelected) {
    return GestureDetector(
      child: Container(
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.25)
              : Color(0xFFEBECEF).withOpacity(0.25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(180)),
                  color: color),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(priority),
          ],
        ),
      ),
      onTap: () => dashProvider.quickNotePriority(priority),
    );
  }
}
