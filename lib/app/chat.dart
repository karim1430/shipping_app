import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/companyModel.dart';

class ChatScreen extends StatefulWidget {
  final CompanyModel company;

  const ChatScreen({Key? key, required this.company}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMessages(); // ✅ تحميل الرسائل من SharedPreferences عند فتح الصفحة
  }

  // 🔍 حفظ الرسائل في SharedPreferences
  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(messages);
    await prefs.setString('chat_${widget.company.id}', encodedData);
  }

  // 🔍 تحميل الرسائل من SharedPreferences
  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('chat_${widget.company.id}');
    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      setState(() {
        messages = decodedData.cast<Map<String, dynamic>>();
      });
    }
  }

  // 🔍 الردود الذكية
  String getSmartReply(String userMessage) {
    userMessage = userMessage.toLowerCase();
    if (userMessage.contains("متى") && userMessage.contains("توصيل")) {
      return "نقوم بالتوصيل خلال 1-2 يوم عمل.";
    } else if ((userMessage.contains("كم") || userMessage.contains("ما هو")) &&
        (userMessage.contains("السعر") || userMessage.contains("الشحن"))) {
      return "السعر يعتمد على الوزن والمسافة. قم بإنشاء طلب لرؤية السعر المقترح.";
    } else if (userMessage.contains("رقم") || userMessage.contains("الهاتف")) {
      return "تواصل معنا عبر: ${widget.company.phoneNumber}";
    }
    return "شكرًا لتواصلك، سيتم الرد عليك قريبًا.";
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();

    setState(() {
      messages.add({'text': userMessage, 'isUser': true});
    });
    saveMessages(); // ✅ حفظ بعد رسالة المستخدم

    Future.delayed(const Duration(milliseconds: 600), () {
      final botReply = getSmartReply(userMessage);
      setState(() {
        messages.add({'text': botReply, 'isUser': false});
      });
      saveMessages(); // ✅ حفظ بعد رد البوت
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(widget.company.name, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
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
                  alignment: msg['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
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
                      hintText: 'اكتب رسالتك...',
                      hintStyle: GoogleFonts.cairo(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
