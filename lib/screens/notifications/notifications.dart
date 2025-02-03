import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:waw/models/notification/notification_model.dart';
import 'package:waw/providers/notiification_provider.dart';

import '../../rest/hive_repo.dart';
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
class NotificationsScreen extends ConsumerStatefulWidget {
  final int bottomIndex;
  const NotificationsScreen({super.key, required this.bottomIndex});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState(this.bottomIndex);
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {

  bool loading = true;
  List<NotificationList> notificationList = [];

  fetchData() async {
    setState(() {
      loading = true;
    });

    notificationList.clear();
    await ref.read(notificationProvider).getAllNotification();
    final notifications = ref.watch(notificationProvider);
    notificationList = notifications.allNotificationListState;
    HiveRepo.instance.setInitialNotification(value: notificationList.length.toString());
    _groupNotificationsByDate();
    setState(() {
      loading = false;
    });
  }

  int bottomIndex;
  Map<String, List<NotificationList>> groupedNotifications = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _groupNotificationsByDate() {
    groupedNotifications = {};
    for (var notification in notificationList) {
      if (!groupedNotifications.containsKey(notification.date)) {
        groupedNotifications[notification.date.toString()] = [];
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

  String _formatTime(String time) {
    try {
      final DateTime parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time;
    }
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
              border: Border.all(color: (notification.flag == "A") ? Colors.amber : Colors.grey, width: 0.2),
            ),
            child: Stack(
              clipBehavior: Clip.none, // This allows the icon to overflow out of the container
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title.toString(),
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 13),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatTime(notification.time.toString()),
                        style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if (notification.flag == "A")
                  const Positioned(
                    top: -10,
                    right: -10,
                    child: Icon(
                      Icons.volume_down,
                      color: Colors.amber,
                      size: 24, // Icon size
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

    return WillPopScope(
      onWillPop: () async {
        context.pushRoute(DashboardRoute(bottomIndex: bottomIndex));
        return false;
      },
      child: Scaffold(
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
      ),
    );
  }
}
