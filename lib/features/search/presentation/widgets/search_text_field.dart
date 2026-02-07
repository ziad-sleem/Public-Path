import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController searchController; 
  final Function(String)? onChanged;
  const SearchTextField({super.key, required this.searchController,required this.onChanged});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return   Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller:widget.searchController,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
  }
}