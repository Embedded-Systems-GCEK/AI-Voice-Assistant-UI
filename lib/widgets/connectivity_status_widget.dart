import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class ConnectivityStatusWidget extends StatefulWidget {
  const ConnectivityStatusWidget({super.key});

  @override
  State<ConnectivityStatusWidget> createState() => _ConnectivityStatusWidgetState();
}

class _ConnectivityStatusWidgetState extends State<ConnectivityStatusWidget> {
  final ApiService _apiService = ApiService();
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _apiService.isOnline 
            ? Colors.green.withOpacity(0.3) 
            : Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _apiService.isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: _apiService.isOnline ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _apiService.isOnline ? 'Connected to AI Assistant' : 'Offline Mode',
                  style: TextStyle(
                    color: _apiService.isOnline ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!_apiService.isOnline) ...[
                  const SizedBox(height: 2),
                  const Text(
                    'Limited features available',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isChecking)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, size: 16),
              color: Colors.white54,
              onPressed: _checkConnectivity,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Future<void> _checkConnectivity() async {
    if (_isChecking) return;
    
    setState(() => _isChecking = true);
    
    try {
      await _apiService.checkHealth();
      if (mounted) {
        setState(() => _isChecking = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }
}