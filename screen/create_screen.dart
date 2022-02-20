import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis/monitoring/v3.dart';
import 'package:intl/intl.dart';

import 'package:pgsupervisor/database/storage.dart';
import 'package:pgsupervisor/model/event_info.dart';
import 'package:pgsupervisor/others/colors.dart';
import 'package:pgsupervisor/screen/calendar_client.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();

  late TextEditingController textControllerDate;
  late TextEditingController textControllerStartTime;
  late TextEditingController textControllerEndTime;
  late TextEditingController textControllerTitle;
  late TextEditingController textControllerDesc;
  late TextEditingController textControllerLocation;
  late TextEditingController textControllerAttendee;

  late FocusNode textFocusNodeTitle;
  late FocusNode textFocusNodeDesc;
  late FocusNode textFocusNodeLocation;
  late FocusNode textFocusNodeAttendee;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  late String currentTitle;
  late String currentDesc;
  late String currentLocation;
  late String currentEmail;
  late String errorString = '';
  // List<String> attendeeEmails = [];
  List<calendar.EventAttendee> attendeeEmails = [];

  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool isEditingEndTime = false;
  bool isEditingBatch = false;
  bool isEditingTitle = false;
  bool isEditingEmail = false;
  bool isEditingLink = false;
  bool isErrorTime = false;
  bool shouldNofityAttendees = false;
  bool hasConferenceSupport = false;

  bool isDataStorageInProgress = false;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate.text = DateFormat.yMMMMd().format(selectedDate);
      });
    }
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        textControllerStartTime.text = selectedStartTime.format(context);
      });
    } else {
      setState(() {
        textControllerStartTime.text = selectedStartTime.format(context);
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
        textControllerEndTime.text = selectedEndTime.format(context);
      });
    } else {
      setState(() {
        textControllerEndTime.text = selectedEndTime.format(context);
      });
    }
  }

  String? _validateTitle(String value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Title can\'t be empty';
      }
    } else {
      return 'Title can\'t be empty';
    }

    return null;
  }

  String? _validateEmail(String value) {
    if (value != null) {
      value = value.trim();

      if (value.isEmpty) {
        return 'Can\'t add an empty email';
      } else {
        final regex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        final matches = regex.allMatches(value);
        for (Match match in matches) {
          if (match.start == 0 && match.end == value.length) {
            return null;
          }
        }
      }
    } else {
      return 'Can\'t add an empty email';
    }

    return 'Invalid email';
  }

  @override
  void initState() {
    textControllerDate = TextEditingController();
    textControllerStartTime = TextEditingController();
    textControllerEndTime = TextEditingController();
    textControllerTitle = TextEditingController();
    textControllerDesc = TextEditingController();
    textControllerLocation = TextEditingController();
    textControllerAttendee = TextEditingController();

    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColor.LightYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            width: width,
            child: Column(
              children: <Widget>[
                Hero(
                  tag: 'backButton',
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: CustomColor.dark_blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    Text(
                      'Create new event',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 40.0,
                      color: CustomColor.kGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.LightYellow,
                  ),
                  child: Column(
                    children: const <Widget>[
                      Text(
                        'This will add a new event to the events list. You can also add video conferencing option and choose to notify the attendees of this event.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'You will have access to modify or remove the event afterwards.* is mandatory to fill in.',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // title
                    TextField(
                      enabled: true,
                      cursorColor: CustomColor.kGreen,
                      focusNode: textFocusNodeTitle,
                      controller: textControllerTitle,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          isEditingTitle = true;
                          currentTitle = value;
                        });
                      },
                      onSubmitted: (value) {
                        textFocusNodeTitle.unfocus();
                        FocusScope.of(context).requestFocus(textFocusNodeDesc);
                      },
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        labelText: 'Title*',
                        labelStyle: const TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        hintText: 'eg: Birthday party of John',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingTitle ? _validateTitle(currentTitle) : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    // description
                    TextField(
                      enabled: true,
                      maxLines: null,
                      cursorColor: CustomColor.kGreen,
                      focusNode: textFocusNodeDesc,
                      controller: textControllerDesc,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          currentDesc = value;
                        });
                      },
                      onSubmitted: (value) {
                        textFocusNodeDesc.unfocus();
                        FocusScope.of(context).requestFocus(textFocusNodeLocation);
                      },
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        labelText: 'Description',
                        labelStyle: const TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        hintText: 'eg: Some information about this event',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // date
                    TextField(
                      cursorColor: CustomColor.kGreen,
                      controller: textControllerDate,
                      textCapitalization: TextCapitalization.characters,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        labelText: 'Date*',
                        labelStyle: const TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        hintText: 'eg: September 10, 2020',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingDate && textControllerDate.text != null
                            ? textControllerDate.text.isNotEmpty
                            ? null
                            : 'Date can\'t be empty'
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    // start
                    TextField(
                      cursorColor: CustomColor.kGreen,
                      controller: textControllerStartTime,
                      onTap: () => _selectStartTime(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        labelText: 'Start Time*',
                        labelStyle: const TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        hintText: 'eg: 09:30 AM',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingStartTime && textControllerStartTime.text != null
                            ? textControllerStartTime.text.isNotEmpty
                            ? null
                            : 'Start time can\'t be empty'
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    // end
                    TextField(
                      cursorColor: CustomColor.kGreen,
                      controller: textControllerEndTime,
                      onTap: () => _selectEndTime(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        labelText: 'End Time*',
                        labelStyle: const TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        hintText: 'eg: 11:30 AM',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingEndTime && textControllerEndTime.text != null
                            ? textControllerEndTime.text.isNotEmpty
                            ? null
                            : 'End time can\'t be empty'
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    // location
                    TextField(
                      enabled: true,
                      cursorColor: CustomColor.kGreen,
                      focusNode: textFocusNodeLocation,
                      controller: textControllerLocation,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          currentLocation = value;
                        });
                      },
                      onSubmitted: (value) {
                        textFocusNodeLocation.unfocus();
                        FocusScope.of(context).requestFocus(textFocusNodeAttendee);
                      },
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        labelText: 'Location',
                        labelStyle: const TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        hintText: 'eg: Place of the event',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // attendees
                    RichText(
                      text: const TextSpan(
                        text: 'Attendees Requested',
                        style: TextStyle(
                          color: CustomColor.kGreen,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      itemCount: attendeeEmails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                attendeeEmails[index].email!,
                                style: const TextStyle(
                                  color: CustomColor.neon_green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    attendeeEmails.removeAt(index);
                                  });
                                },
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: true,
                            cursorColor: CustomColor.kGreen,
                            focusNode: textFocusNodeAttendee,
                            controller: textControllerAttendee,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                currentEmail = value;
                              });
                            },
                            onSubmitted: (value) {
                              textFocusNodeAttendee.unfocus();
                            },
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColor.kGreen)),
                              border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                              contentPadding: const EdgeInsets.only(
                                left: 16,
                                bottom: 16,
                                top: 16,
                                right: 16,
                              ),
                              hintText: 'Enter attendee email',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              errorText: isEditingEmail ? _validateEmail(currentEmail) : null,
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: CustomColor.kGreen,
                            size: 35,
                          ),
                          onPressed: () {
                            setState(() {
                              isEditingEmail = true;
                            });
                            if (_validateEmail(currentEmail) == null) {
                              setState(() {
                                textFocusNodeAttendee.unfocus();
                                calendar.EventAttendee eventAttendee = calendar.EventAttendee();
                                eventAttendee.email = currentEmail;

                                attendeeEmails.add(eventAttendee);

                                textControllerAttendee.text = '';
                                currentEmail = '';
                                isEditingEmail = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: attendeeEmails.isNotEmpty,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Notify attendees',
                                style: TextStyle(
                                  color: CustomColor.kGreen,
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Switch(
                                value: shouldNofityAttendees,
                                onChanged: (value) {
                                  setState(() {
                                    shouldNofityAttendees = value;
                                  });
                                },
                                activeColor: CustomColor.kGreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add video conferencing',
                          style: TextStyle(
                            color: CustomColor.kGreen,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Switch(
                          value: hasConferenceSupport,
                          onChanged: (value) {
                            setState(() {
                              hasConferenceSupport = value;
                            });
                          },
                          activeColor: CustomColor.sea_blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.maxFinite,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        elevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        color: CustomColor.kGreen,
                        onPressed: isDataStorageInProgress
                            ? null
                            : () async {
                          setState(() {
                            isErrorTime = false;
                            isDataStorageInProgress = true;
                          });

                          textFocusNodeTitle.unfocus();
                          textFocusNodeDesc.unfocus();
                          textFocusNodeLocation.unfocus();
                          textFocusNodeAttendee.unfocus();

                          if (selectedDate != null &&
                              selectedStartTime != null &&
                              selectedEndTime != null &&
                              currentTitle != null) {
                            int startTimeInEpoch = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedStartTime.hour,
                              selectedStartTime.minute,
                            ).millisecondsSinceEpoch;

                            int endTimeInEpoch = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedEndTime.hour,
                              selectedEndTime.minute,
                            ).millisecondsSinceEpoch;

                            print('DIFFERENCE: ${endTimeInEpoch - startTimeInEpoch}');

                            print('Start Time: ${DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch)}');
                            print('End Time: ${DateTime.fromMillisecondsSinceEpoch(endTimeInEpoch)}');

                            if (endTimeInEpoch - startTimeInEpoch > 0) {
                              if (_validateTitle(currentTitle) == null) {
                                await calendarClient
                                    .insert(
                                    title: currentTitle,
                                    description: currentDesc ,
                                    location: currentLocation,
                                    attendeeEmailList: attendeeEmails,
                                    shouldNotifyAttendees: shouldNofityAttendees,
                                    hasConferenceSupport: hasConferenceSupport,
                                    startTime: DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch),
                                    endTime: DateTime.fromMillisecondsSinceEpoch(endTimeInEpoch))
                                    .then((eventData) async {
                                  String? eventId = eventData['id'];
                                  String? eventLink = eventData['link'];

                                  List<String> emails = [];

                                  for (int i = 0; i < attendeeEmails.length; i++) {
                                    emails.add(attendeeEmails[i].email!);
                                  }

                                  EventInfo eventInfo = EventInfo(
                                    id: eventId!,
                                    name: currentTitle,
                                    description: currentDesc ,
                                    location: currentLocation,
                                    link: eventLink!,
                                    attendeeEmails: emails,
                                    shouldNotifyAttendees: shouldNofityAttendees,
                                    hasConfereningSupport: hasConferenceSupport,
                                    startTimeInEpoch: startTimeInEpoch,
                                    endTimeInEpoch: endTimeInEpoch,
                                  );

                                  await storage
                                      .storeEventData(eventInfo)
                                      .whenComplete(() => Navigator.of(context).pop())
                                      .catchError(
                                        (e) => print(e),
                                  );
                                }).catchError(
                                  // ignore: invalid_return_type_for_catch_error
                                      (e) => print(e),
                                );

                                setState(() {
                                  isDataStorageInProgress = false;
                                });
                              } else {
                                setState(() {
                                  isEditingTitle = true;
                                  isEditingLink = true;
                                });
                              }
                            } else {
                              setState(() {
                                isErrorTime = true;
                                errorString = 'Invalid time! Please use a proper start and end time';
                              });
                            }
                          } else {
                            setState(() {
                              isEditingDate = true;
                              isEditingStartTime = true;
                              isEditingEndTime = true;
                              isEditingBatch = true;
                              isEditingTitle = true;
                              isEditingLink = true;
                            });
                          }
                          setState(() {
                            isDataStorageInProgress = false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: isDataStorageInProgress
                              ? const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'ADD',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isErrorTime,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorString,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}