import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseryAppointmentDetailsScreen extends StatefulWidget {
  final String nurseryId;
  final String laborerId;
  final String laborerName;

  const NurseryAppointmentDetailsScreen(
      {super.key,
      required this.nurseryId,
      required this.laborerId,
      required this.laborerName});

  @override
  _NurseryAppointmentDetailsScreenState createState() =>
      _NurseryAppointmentDetailsScreenState();
}

class _NurseryAppointmentDetailsScreenState
    extends State<NurseryAppointmentDetailsScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Map<String, List<TimeOfDay>> availableTimeSlots = {};
  List<String> availableDays = [];
  bool isLoading = true;
  TextEditingController locationController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  double? laborerPrice;

  @override
  void initState() {
    super.initState();
    _fetchLaborerAvailability();
  }

  Future<void> _fetchLaborerAvailability() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('laborers')
          .doc(widget.laborerId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data();

        // Fetch price per hour but do NOT store it in appointments
        if (data!['pricePerHour'] != null) {
          setState(() {
            laborerPrice = data['pricePerHour'].toDouble();
          });
        }

        if (data['availableTime'] != null) {
          List<dynamic> availableTime = data['availableTime'];
          for (var entry in availableTime) {
            String day = entry['day'];
            availableDays.add(day);

            TimeOfDay start = TimeOfDay(
                hour: entry['startHour'], minute: entry['startMinute']);
            TimeOfDay end =
                TimeOfDay(hour: entry['endHour'], minute: entry['endMinute']);
            List<TimeOfDay> slots = _generateTimeSlots(start, end);

            availableTimeSlots[day] = slots;
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error fetching availability: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  List<TimeOfDay> _generateTimeSlots(TimeOfDay start, TimeOfDay end) {
    List<TimeOfDay> slots = [];
    TimeOfDay current = start;

    while (_isBeforeOrEqual(current, end)) {
      slots.add(current);
      current = _addMinutes(current, 30); // Adjust slot interval if needed
    }

    return slots;
  }

  bool _isBeforeOrEqual(TimeOfDay a, TimeOfDay b) {
    return (a.hour < b.hour) || (a.hour == b.hour && a.minute <= b.minute);
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    int newMinutes = time.minute + minutes;
    int newHour = time.hour + (newMinutes ~/ 60);
    newMinutes %= 60;
    return TimeOfDay(hour: newHour, minute: newMinutes);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDate = _findNextAvailableDate(now);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      selectableDayPredicate: (date) {
        return availableDays.contains(_getDayName(date));
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTime = null; // Reset selected time
      });
    }
  }

  DateTime _findNextAvailableDate(DateTime start) {
    for (int i = 0; i < 30; i++) {
      DateTime candidate = start.add(Duration(days: i));
      if (availableDays.contains(_getDayName(candidate))) {
        return candidate;
      }
    }
    return start; // Fallback (shouldn't happen if at least one day is available)
  }

  String _getDayName(DateTime date) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[date.weekday - 1]; // Convert 1-7 to 0-6 index
  }

  Future<void> _selectTime(BuildContext context) async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select a date first!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    String dayName = _getDayName(selectedDate!);
    List<TimeOfDay>? availableSlots = availableTimeSlots[dayName];

    if (availableSlots == null || availableSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No available time slots for this day."),
            backgroundColor: Colors.orange),
      );
      return;
    }

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: availableSlots.first,
    );

    if (picked != null && availableSlots.contains(picked)) {
      setState(() {
        selectedTime = picked;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select a valid time slot."),
            backgroundColor: Colors.orange),
      );
    }
  }

  Future<void> _confirmAppointment() async {
    if (selectedDate == null ||
        selectedTime == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Please select both date and time and enter a location!!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    String appointmentId =
        FirebaseFirestore.instance.collection('appointments').doc().id;
    String formattedDate =
        "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";

    Map<String, dynamic> appointmentData = {
      'appointmentId': appointmentId,
      'nurseryId': widget.nurseryId,
      'laborerId': widget.laborerId,
      'date': formattedDate,
      'time': "${selectedTime!.hour}:${selectedTime!.minute}",
      'location': locationController.text,
      'title': titleController.text,
      'status': 'pending',
    };

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .set(appointmentData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Appointment Confirmed!"),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error booking appointment: $e"),
            backgroundColor: Colors.red),
      );
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Book Appointment'),
  //       backgroundColor: Colors.green,
  //       foregroundColor: Colors.white,
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text("Select Date:",
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.bold)),
  //                   const SizedBox(height: 5),
  //                   ElevatedButton(
  //                     onPressed: () => _selectDate(context),
  //                     child: Text(selectedDate != null
  //                         ? "${selectedDate!.toLocal()}".split(' ')[0]
  //                         : "Choose Date"),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   const Text("Select Time:",
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.bold)),
  //                   const SizedBox(height: 5),
  //                   ElevatedButton(
  //                     onPressed: () => _selectTime(context),
  //                     child: Text(selectedTime != null
  //                         ? "${selectedTime!.format(context)}"
  //                         : "Choose Time"),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   const Text("Laborer's Price Per Hour:",
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.bold)),
  //                   const SizedBox(height: 5),
  //                   Text(
  //                     laborerPrice != null
  //                         ? "₹ ${laborerPrice!.toStringAsFixed(2)} per hour"
  //                         : "Loading...",
  //                     style: const TextStyle(fontSize: 16, color: Colors.blue),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextField(
  //                     controller: titleController,
  //                     decoration: const InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       hintText: "Enter Job Title",
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   const Text("Enter Location:",
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.bold)),
  //                   const SizedBox(height: 5),
  //                   TextField(
  //                     controller: locationController,
  //                     decoration: const InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       hintText: "Enter appointment location",
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Center(
  //                     child: ElevatedButton(
  //                       onPressed: _confirmAppointment,
  //                       style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.green),
  //                       child: const Text("Confirm Appointment",
  //                           style: TextStyle(fontSize: 16)),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(Icons.date_range, "Select Date"),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                            label: Text(selectedDate != null
                                ? "${selectedDate!.toLocal()}".split(' ')[0]
                                : "Choose Date"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600),
                          ),
                          const SizedBox(height: 16),
                          _sectionTitle(Icons.access_time, "Select Time"),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _selectTime(context),
                            label: Text(
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : "Choose Time",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600),
                          ),
                          const SizedBox(height: 16),
                          _sectionTitle(
                              Icons.attach_money, "Laborer's Price Per Hour"),
                          Text(
                            laborerPrice != null
                                ? "₹ ${laborerPrice!.toStringAsFixed(2)} per hour"
                                : "Loading...",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(Icons.work_outline, "Job Title"),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: "Enter job title",
                            ),
                          ),
                          const SizedBox(height: 16),
                          _sectionTitle(Icons.location_on, "Location"),
                          TextField(
                            controller: locationController,
                            decoration: InputDecoration(
                              hintText: "Enter work location",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      onPressed: _confirmAppointment,
                      label: const Text(
                        "Confirm Appointment",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

// Helper widget for section titles
  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
      ],
    );
  }
}
