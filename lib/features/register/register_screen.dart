import 'package:material_ui/material_ui.dart';

import '../../core/app_api.dart';
import '../../core/app_persistence.dart';
import '../../core/user_qr_token.dart';
import '../../theme/whs_theme.dart';
import '../../widgets/section_page_header.dart';
import 'registered_user_qr_dialog.dart';

/// Registration page aligned with WHS Egypt registration fields.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _api = AppApi();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _organizationController = TextEditingController();
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  static const _attendanceOptions = ['In-person', 'To be confirmed'];
  String _attendanceType = _attendanceOptions.first;

  @override
  void dispose() {
    _api.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    final request = <String, String>{
      'full_name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'organization': _organizationController.text.trim(),
      'job_title': _titleController.text.trim(),
      'phone': _phoneController.text.trim(),
      'attendance_type': _attendanceType,
      'message': _messageController.text.trim(),
    };

    setState(() => _isSubmitting = true);
    late final String qrToken;
    try {
      await _api.submitRegistration(request);
      qrToken = createUserQrToken();
      await AppPersistence.saveRegistrationRequest({
        ...request,
        'qr_token': qrToken,
      });
    } on AppApiException catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not submit your request. Please try again.'),
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    await showDialog<void>(
      context: context,
      builder: (_) => RegisteredUserQrDialog(token: qrToken),
    );
  }

  InputDecoration _decoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: WhsColors.burgundy),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WhsColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WhsColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WhsColors.burgundy, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 720 ? 28.0 : 18.0;
            final maxWidth = constraints.maxWidth >= 720
                ? 720.0
                : double.infinity;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 40),
                  children: [
                    const SectionPageHeader(
                      eyebrow: 'Registration',
                      title: 'Registration',
                      subtitle: 'Complete the form below to submit your registration request for the Egypt Women’s Health Summit 2026.',
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WhsColors.divider),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'ATTENDANCE REGISTRATION',
                              style: TextStyle(
                                color: WhsColors.teal,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Join the national dialogue.',
                              style: TextStyle(
                                color: WhsColors.ink,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Enter your details below. Our team will receive your registration request and contact you accordingly.',
                              style: TextStyle(
                                color: WhsColors.inkMuted,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 22),
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: _decoration(
                                label: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _decoration(
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email address';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _organizationController,
                              decoration: _decoration(
                                label: 'Organization',
                                icon: Icons.business_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your organization';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _titleController,
                              decoration: _decoration(
                                label: 'Job Title',
                                icon: Icons.work_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your job title';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _decoration(
                                label: 'Phone Number',
                                icon: Icons.phone_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              initialValue: _attendanceType,
                              decoration: _decoration(
                                label: 'Attendance Type',
                                icon: Icons.event_available_outlined,
                              ),
                              items: [
                                for (final option in _attendanceOptions)
                                  DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _attendanceType = value);
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _messageController,
                              maxLines: 4,
                              decoration: _decoration(
                                label: 'Message',
                                icon: Icons.message_outlined,
                              ),
                            ),
                            const SizedBox(height: 22),
                            FilledButton(
                              onPressed: _isSubmitting ? null : _submitForm,
                              style: FilledButton.styleFrom(
                                backgroundColor: WhsColors.burgundy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Submit Registration Request',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
