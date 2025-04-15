import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/cubits/liked_cats_cubit.dart';

class BreedFilter extends StatefulWidget {
  const BreedFilter({super.key});

  @override
  State<BreedFilter> createState() => _BreedFilterState();
}

class _BreedFilterState extends State<BreedFilter> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _buildOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final cubit = context.read<LikedCatsCubit>();
    final breeds = cubit.allBreeds;
    final selected = cubit.currentFilters;

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeDropdown,
            child: Stack(
              children: [
                Positioned(
                  left: position.dx,
                  top: position.dy + size.height,
                  width: size.width,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: const Offset(0, 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withValues(alpha: .9),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildChip('', selected.isEmpty),
                            ...breeds.map(
                              (b) => _buildChip(b, selected.contains(b)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildChip(String breed, bool isSelected) {
    return ChoiceChip(
      label: Text(
        breed.isEmpty ? 'Все породы' : breed,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      selectedColor: Colors.lightGreenAccent,
      backgroundColor: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? Colors.lightGreenAccent : Colors.white30,
        ),
      ),
      onSelected: (_) {
        context.read<LikedCatsCubit>().toggleFilter(breed);
        // optionally auto-close after selection:
        // _removeDropdown();
      },
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .85),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Фильтр по породам',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
