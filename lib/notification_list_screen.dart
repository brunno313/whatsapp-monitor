import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:full_whatsapp_monitor/services/notification/notification_database.dart';
import 'package:full_whatsapp_monitor/services/notification/notification_model.dart';
import 'package:full_whatsapp_monitor/utils/check_suspicious_message.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<ServiceNotificationEvent> events = [];

  @override
  void initState() {
    super.initState();

    // Carregar notificações previamente salvas ao iniciar o aplicativo
    _loadNotifications();

    // Capture only events of whatsapp that not have been removed.
    NotificationListenerService.notificationsStream
        .where((event) =>
            !event.hasRemoved! &&
            isSuspiciousMessage(event.title, event.content))
        .listen((event) async {
      // Atualize o estado da lista de notificações na UI
      setState(() {
        events.add(event);
      });

      // Extraia os dados da notificação
      final String? title = event.title;
      final String? message = event.content;
      final Uint8List? appIconBytes = event.appIcon;
      final Uint8List? largeIconBytes = event.largeIcon;

      // Converta a imagem para base64 se disponível
      final String? appIconBase64 =
          appIconBytes != null ? base64Encode(appIconBytes) : null;
      final String? largeIconBase64 =
          largeIconBytes != null ? base64Encode(largeIconBytes) : null;

      // Crie um modelo de notificação
      final notification = NotificationModel(
        title: title ?? 'Sem título',
        message: message ?? 'Sem mensagem',
        appIcon: appIconBase64,
        largeIcon: largeIconBase64,
        dateTime: DateTime.now(),
      );

      // Salve a notificação no banco de dados
      await NotificationDatabase.instance.insertNotification(notification);
    });
  }

  Future<void> _loadNotifications() async {
    // Recupere todas as notificações salvas no banco de dados
    final savedNotifications =
        await NotificationDatabase.instance.fetchAllNotifications();

    // Atualize o estado para mostrar as notificações carregadas
    setState(() {
      events = savedNotifications
          .map((e) => ServiceNotificationEvent(
                title: e.title,
                content: e.message,
                appIcon: e.appIcon != null ? base64Decode(e.appIcon!) : null,
                largeIcon:
                    e.largeIcon != null ? base64Decode(e.largeIcon!) : null,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensagens suspeitas'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 1.0,
                    left: 1.0,
                    right: 1.0,
                  ),
                  child: ListTile(
                    leading: events[index].appIcon == null
                        ? const SizedBox.shrink()
                        : Image.memory(
                            events[index].appIcon!,
                            width: 35.0,
                            height: 35.0,
                          ),
                    title: Text(events[index].title ?? "No title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          events[index].content ?? "no content",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        events[index].largeIcon != null
                            ? Image.memory(
                                events[index].largeIcon!,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
