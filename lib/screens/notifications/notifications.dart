import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_router.gr.dart';
import '../../theme/colors.dart';

class DateNotification {
  final String date;
  final String time;
  final String notification;

  DateNotification({
    required this.date,
    required this.time,
    required this.notification,
  });
}

@RoutePage()
class NotificationsScreen extends StatefulWidget {
  final int bottomIndex;
  const NotificationsScreen({super.key, required this.bottomIndex});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState(this.bottomIndex);
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  int bottomIndex;
  final List<DateNotification> _notificationsList = [
    DateNotification(date: "10/11/2024", time: "10:00 AM", notification: "Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently."),
    DateNotification(date: "10/11/2024", time: "11:00 AM", notification: "Notification 2"),
    DateNotification(date: "11/11/2024", time: "09:00 AM", notification: "Notification 3"),
    DateNotification(date: "11/11/2024", time: "02:00 PM", notification: "Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently."),
    DateNotification(date: "20/11/2024", time: "03:30 PM", notification: "Notification 5"),
    DateNotification(date: "25/11/2024", time: "10:15 AM", notification: "Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently."),
    DateNotification(date: "25/11/2024", time: "12:00 PM", notification: "Notification 7"),
    DateNotification(date: "25/11/2024", time: "01:45 PM", notification: "Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently."),
    DateNotification(date: "26/11/2024", time: "04:00 PM", notification: "Notification 9"),
    DateNotification(date: "30/11/2024", time: "08:00 AM", notification: "Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently."),
    DateNotification(date: "30/11/2024", time: "10:30 AM", notification: "Make Money feature to your app can be a great way to engage users, but it should be done ethically and transparently."),
    DateNotification(date: "30/11/2024", time: "05:00 PM", notification: "Notification 12"),
  ];

  Map<String, List<DateNotification>> groupedNotifications = {};

  @override
  void initState() {
    super.initState();
    _groupNotificationsByDate();
  }

  void _groupNotificationsByDate() {
    groupedNotifications = {};
    for (var notification in _notificationsList) {
      if (!groupedNotifications.containsKey(notification.date)) {
        groupedNotifications[notification.date] = [];
      }
      groupedNotifications[notification.date]!.add(notification);
    }
  }

  List<String> _sortedDates() {
    final today = DateTime.now();

    // Convert dates to `DateTime` for sorting
    List<String> dates = groupedNotifications.keys.toList();
    dates.sort((a, b) {
      DateTime dateA = DateTime.parse(_convertToIso(a));
      DateTime dateB = DateTime.parse(_convertToIso(b));

      // Sort future dates first, and past dates in descending order
      if (dateA.isAfter(today) && dateB.isAfter(today)) {
        return dateA.compareTo(dateB); // Ascending for future dates
      } else if (dateA.isBefore(today) && dateB.isBefore(today)) {
        return dateB.compareTo(dateA); // Descending for past dates
      } else {
        return dateA.isAfter(today) ? -1 : 1; // Future dates come before past dates
      }
    });

    return dates;
  }

  String _convertToIso(String date) {
    final parts = date.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  Widget _buildSection(String date) {
    final today = DateTime.now();
    final todayString = "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}";

    String sectionTitle;
    if (date == todayString) {
      sectionTitle = "Today";
    } else {
      final isFuture = DateTime.parse(_convertToIso(date)).isAfter(today);
      sectionTitle = isFuture ? "" : "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(sectionTitle != "")Text(
          sectionTitle,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if(sectionTitle != "Today")Text(
          date,
          style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 10),
        ...groupedNotifications[date]!.map((notification) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.notification,
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 13),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    notification.time,
                    style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  _NotificationsScreenState(this.bottomIndex);

  @override
  Widget build(BuildContext context) {
    final sortedDates = _sortedDates();

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => context.pushRoute(DashboardRoute(bottomIndex: bottomIndex)),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: sortedDates.map((date) => _buildSection(date)).toList(),
        ),
      ),
    );
  }
}
