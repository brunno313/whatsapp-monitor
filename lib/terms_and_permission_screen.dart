import 'package:flutter/material.dart';
import 'package:full_whatsapp_monitor/notification_list_screen.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndPermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termos de Uso'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Introdução',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Bem-vindo ao Whatsapp Monitor. Este aplicativo foi desenvolvido para '
              'ajudar a proteger você contra tentativas de phishing ao monitorar '
              'as notificações dos aplicativos instalados em seu dispositivo. Ao '
              'usar este aplicativo, você concorda com os termos e condições '
              'descritos abaixo.',
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Coleta e Uso de Dados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'O Whatsapp Monitor acessa as notificações dos aplicativos instalados '
              'em seu dispositivo para verificar se há conteúdo suspeito de '
              'phishing ou golpes. As informações coletadas são utilizadas '
              'exclusivamente para identificar e alertar você sobre possíveis '
              'ameaças à sua segurança.',
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Consentimento',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Ao utilizar o Whatsapp Monitor, você concorda que o aplicativo possa '
              'acessar e analisar as notificações dos aplicativos instalados no '
              'seu dispositivo. Este acesso é essencial para que o Whatsapp Monitor '
              'possa desempenhar sua função de proteção contra phishing.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Privacidade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'O Whatsapp Monitor respeita sua privacidade. As informações '
              'coletadas a partir das notificações são tratadas de forma '
              'confidencial e não serão compartilhadas com terceiros sem o seu '
              'consentimento, exceto quando exigido por lei.',
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Segurança',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nosso objetivo é garantir a segurança dos seus dados. Utilizamos '
              'medidas de segurança adequadas para proteger as informações '
              'coletadas contra acessos não autorizados ou uso indevido.',
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Alterações nos Termos de Serviço',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Podemos atualizar estes Termos de Serviço periodicamente. Você '
              'será notificado sobre quaisquer alterações, e o uso continuado '
              'do aplicativo após tais alterações será considerado como aceitação '
              'dos novos termos.',
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Contato',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Se você tiver qualquer dúvida sobre estes Termos de Serviço, entre '
              'em contato conosco pelo suporte@example.com.',
            ),
            SizedBox(height: 16.0),
            Text(
              '8. Aceitação dos Termos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Ao clicar em "Aceitar e Continuar", você confirma que leu, entendeu e concorda '
              'com todos os termos e condições estabelecidos neste documento.',
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final res =
                      await NotificationListenerService.requestPermission();
                  if (res) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('notification_permission', true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => NotificationListScreen()),
                    );
                  }
                },
                child: Text('Aceitar e Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
