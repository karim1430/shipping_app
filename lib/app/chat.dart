import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/companyModel.dart';

class ChatScreen extends StatefulWidget {
  final CompanyModel company;

  const ChatScreen({Key? key, required this.company}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();

  // 🔍 الردود الذكية بناءً على الأسئلة
  String getSmartReply(String userMessage) {
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains("متى") && userMessage.contains("توصيل")) {
      return "نقوم بالتوصيل خلال 1-2 يوم عمل.";
    } else if ((userMessage.contains("كم") || userMessage.contains("ما هو")) &&
        (userMessage.contains("السعر") || userMessage.contains("الشحن"))) {
      return "سعر التوصيل يعتمد على الوزن والمسافة. يمكنك إنشاء طلب لرؤية السعر المقترح.";
    } else if (userMessage.contains("رقم") || userMessage.contains("الهاتف")) {
      return "يمكنك التواصل معنا على: ${widget.company.phoneNumber}";
    } else if (userMessage.contains("خصم") || userMessage.contains("عروض")) {
      return "نقدم خصومات موسمية على الشحنات الكبيرة، تابع عروضنا باستمرار!";
    } else if (userMessage.contains("تعملون") || userMessage.contains("ساعات")) {
      return "نعمل يوميًا من الساعة 9 صباحًا حتى 9 مساءً.";
    } else if (userMessage.contains("نوع") && userMessage.contains("الشحن")) {
      return "نقوم بشحن الطرود، المستندات، والبضائع بكافة أنواعها.";
    } else if (userMessage.contains("الفرع") || userMessage.contains("موقعكم")) {
      return "مقرنا الرئيسي في ${widget.company.mainAddress ?? "لم يتم تحديد العنوان"}";
    } else if (userMessage.contains("الدفع") || userMessage.contains("كاش") || userMessage.contains("اونلاين")) {
      return "نوفر الدفع كاش عند الاستلام أو الدفع الإلكتروني.";
    } else if (userMessage.contains("تأمين") || userMessage.contains("ضمان")) {
      return "نعم، جميع شحناتنا مؤمنة ضد التلف أو الفقد.";
    } else if (userMessage.contains("اللغة") || userMessage.contains("انجليزي")) {
      return "Yes, we support both Arabic and English.";
    }

    return "شكرًا لتواصلك معنا، سيتم الرد عليك قريبًا.";
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();

    setState(() {
      messages.add({'text': userMessage, 'isUser': true});
    });

    _controller.clear();

    Future.delayed(Duration(milliseconds: 600), () {
      final botReply = getSmartReply(userMessage);
      setState(() {
        messages.add({'text': botReply, 'isUser': false});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          widget.company.name,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return Align(
                  alignment:
                  msg['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: msg['isUser'] ? Colors.blue.shade900 : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg['isUser'] ? 16 : 0),
                        bottomRight: Radius.circular(msg['isUser'] ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        color: msg['isUser'] ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.cairo(),
                    decoration: InputDecoration(
                      hintText: 'اكتب سؤالك...',
                      hintStyle: GoogleFonts.cairo(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue.shade900,
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
