bool isSuspiciousMessage(String? title, String? message) {
  if (title == null || message == null) {
    return false;
  }

  // Only consider messages if title is a phone number not in the user's contacts.
  if (!RegExp(
          r'\+?(\d{1,3})?[\s\-\.]?\(?\d{1,4}\)?[\s\-\.]?\d{1,4}[\s\-\.]?\d{1,4}[\s\-\.]?\d{1,9}')
      .hasMatch(title)) {
    return false;
  }

  // Normalize the message to lowercase.
  message = message.toLowerCase();

  final List<RegExp> phishingPatterns = [
    // Words that suggest a problem with the purchase.
    RegExp(
        r'problema com sua compra|erro na sua compra|transação não concluída|compra não foi processada|houve um erro|falha na transação|pedido cancelado|problemas com seu pedido'),

    // Requests to redo the purchase.
    RegExp(
        r'refaça sua compra|é necessário refazer|precisamos que refaça|por favor, realize novamente|realize a compra novamente|fazer a transação novamente|reenvie suas informações de pagamento|realize o pagamento novamente'),

    // Requests for credit card information.
    RegExp(
        r'forneça novamente os dados do seu cartão|precisamos de seus dados bancários|precisamos das informações do seu cartão de crédito|envie seus dados novamente|informe os dados do seu cartão para completar a compra|digite novamente o número do seu cartão|verifique seus dados e faça a compra novamente'),

    // Words that suggest urgency.
    RegExp(
        r'urgente|imediatamente|ação imediata necessária|o mais rápido possível|não perca tempo|ligue agora|responda imediatamente|precisamos da sua resposta agora|sua compra será cancelada|prazo para refazer a compra está acabando|última chance de completar a compra'),

    // Words that suggest a problem with the account.
    RegExp(
        r'ligue para o número|nosso suporte entrará em contato|alguém do suporte ligará|precisamos que você retorne|confirme os detalhes por telefone|recebemos um alerta|alerta de segurança|entre em contato conosco imediatamente|não divulgue a ninguém|mantenha isso em sigilo|hello world'),
  ];

  for (var pattern in phishingPatterns) {
    if (pattern.hasMatch(message)) {
      return true;
    }
  }

  return false;
}
