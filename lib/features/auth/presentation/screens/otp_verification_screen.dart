import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:final_test_family_tree/core/constants/app_constants.dart';
import 'package:final_test_family_tree/features/auth/presentation/providers/auth_provider.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/welcome_screen.dart';

// Route name constant
const String kOtpVerificationRoute = '/otp-verification';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool isRegistration;

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
    this.isRegistration = false,
  }) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResendLoading = false;
  String? _error;
  int _resendTimeout = 30;
  bool _canResend = false;
  late Timer _resendTimer;
  static const String routeName = kOtpVerificationRoute;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() {
          _resendTimeout--;
        });
      } else {
        _resendTimer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authProvider = context.read<AuthProvider>();

    try {
      final success = await authProvider.verifyOtp(_otpController.text);

      if (mounted) {
        if (success) {
          if (widget.isRegistration) {
            // Navigate to welcome screen on successful registration
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
              (route) => false,
            );
          } else {
            // For other OTP verifications (like password reset)
            Navigator.pop(context, true);
          }
        } else {
          setState(() {
            _error = authProvider.error ?? 'Invalid OTP. Please try again.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An error occurred. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isResendLoading = true;
      _error = null;
    });

    final authProvider = context.read<AuthProvider>();

    try {
      final success = await authProvider.sendOtpToPhone(widget.phoneNumber);

      if (mounted) {
        if (!success) {
          setState(() {
            _error = authProvider.error ?? 'Failed to resend OTP. Please try again.';
          });
        } else {
          // Reset the resend timer
          setState(() {
            _resendTimeout = 30;
          });
          _startResendTimer();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An error occurred. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResendLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Enter Verification Code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'We have sent a verification code to',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.phoneNumber,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: Theme.of(context).cardColor,
                  inactiveFillColor: Theme.of(context).cardColor,
                  selectedFillColor: Theme.of(context).cardColor,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).dividerColor,
                  selectedColor: Theme.of(context).primaryColor,
                ),
                cursorColor: Theme.of(context).primaryColor,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onCompleted: (value) => _verifyOtp(),
                onChanged: (value) {
                  setState(() {
                    _error = null;
                  });
                },
                beforeTextPaste: (text) {
                  return text!.length == 6 && int.tryParse(text) != null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Verify'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the code? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _canResend && !_isResendLoading
                        ? _resendOtp
                        : null,
                    child: _isResendLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _canResend
                                ? 'Resend Code'
                                : 'Resend in $_resendTimeout',
                            style: TextStyle(
                              color: _canResend
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Change Phone Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
