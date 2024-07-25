import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF008575),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Privacy'),
              onTap: () => _showMarkdownDialog(
                  context, 'Privacy Policy', _privacyPolicyText),
            ),
            ListTile(
              title: Text('Help & Support'),
              onTap: () => _showMarkdownDialog(
                  context, 'Help & Support', _helpSupportText),
            ),
            ListTile(
              title: Text('FAQs'),
              onTap: () => _showMarkdownDialog(
                  context, 'Frequently Asked Questions', _faqsText),
            ),
            ListTile(
              title: Text('User Guide'),
              onTap: () =>
                  _showMarkdownDialog(context, 'User Guide', _userGuideText),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkdownDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: double.maxFinite,
            child: Markdown(data: content),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  final String _privacyPolicyText = '''
**Last updated:** July 23, 2024

This Privacy Policy describes our policies and procedures on the collection, use and disclosure of your information when you use our Service and tells you about your privacy rights and how the law protects you.

We use your personal data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this Privacy Policy.

## 1. Collection and Use of Your Personal Data
We collect several different types of information for various purposes to provide and improve our Service to you.

## 2. Use of Your Personal Data
We may use Personal Data for the following purposes:
- To provide and maintain our Service
- To notify you about changes to our Service
- To provide customer support
- To gather analysis or valuable information so that we can improve our Service
- To monitor the usage of our Service
- To detect, prevent and address technical issues

## 3. Retention of Your Personal Data
We will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy.

## 4. Transfer of Your Personal Data
Your information may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ from those of your jurisdiction.

## 5. Disclosure of Your Personal Data
We may disclose your Personal Data in the good faith belief that such action is necessary to:
- Comply with a legal obligation
- Protect and defend our rights or property
- Prevent or investigate possible wrongdoing in connection with the Service
- Protect the personal safety of users of the Service or the public
- Protect against legal liability

## 6. Security of Your Personal Data
The security of your Personal Data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure.

## 7. Children's Privacy
Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13.

## 8. Changes to this Privacy Policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

## 9. Contact Us
If you have any questions about this Privacy Policy, please contact us:
- By email: privacy@example.com
''';

  final String _helpSupportText = '''
We're here to assist you with any questions or issues you may have. Here are some ways to get help:

1. **FAQs:** Check our Frequently Asked Questions for quick answers to common inquiries.

2. **User Guide:** Visit our comprehensive User Guide for detailed instructions on using our app.

3. **Contact Support:** If you can't find the answer you need, please contact our support team:
   - Email: support-ph@nittiv.com
   - Phone: +63 912 232 4567
   - Hours: Monday to Friday, 9 AM to 5 PM (Local Time)

4. **Report an Issue:** If you've encountered a bug or technical problem, please use our in-app reporting tool or email us with details about the issue.

*We strive to respond to all inquiries within 24-48 hours. Thank you for your patience and for using our app!*
''';

  final String _faqsText = '''
1. **How do I create an account?**
   To create an account, tap the "Sign Up" button on the home screen and follow the prompts.

2. **How can I reset my password?**
   Contact our support team.

3. **Is my personal information secure?**
   Yes, we use industry-standard encryption to protect your data. For more details, please read our Privacy Policy.

4. **How do I update my profile information?**
   Go to Settings > Profile and tap on the information you wish to update.

5. **Can I use the app offline?**
   Some features are available offline, but for the best experience, we recommend staying connected to the internet.

6. **How do I delete my account?**
   Please contact our support team to request account deletion.

*If you can't find the answer to your question here, please contact our support team.*
''';

  final String _userGuideText = '''
## Getting Started
1. **Download the App:** Find our app in your device's app store and download it.
2. **Create an Account:** Open the app and tap "Sign Up" to create a new account.
3. **Login:** Use your email and password to log in.

## Navigation
- The main screen displays [key features].
- Use the bottom navigation bar to switch between different sections of the app.

## Key Features
1. **Feature A**
   - How to use Feature A
   - Tips for Feature A

2. **Feature B**
   - Steps to access Feature B
   - Best practices for Feature B

3. **Feature C**
   - Description of Feature C
   - Common use cases for Feature C

## Settings
- Customize your app experience in the Settings menu.
- Manage notifications, privacy settings, and account information here.

## Troubleshooting
- If you encounter any issues, try restarting the app.
- Check our FAQs for common problem solutions.
- Contact support if you need further assistance.

*For more detailed information, please refer to our in-app help section or contact our support team.*
''';
}
