import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/cubits/liked_cats_cubit.dart';

class BreedFilterDialog extends StatelessWidget {
  const BreedFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.black.withValues(alpha: .95),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: BlocBuilder<LikedCatsCubit, LikedCatsState>(
              builder: (context, state) {
                final cubit = context.read<LikedCatsCubit>();
                final breeds = cubit.allBreeds;
                final selected = cubit.currentFilters;
                final allSelected = selected.length == breeds.length;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Фильтр по породам',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            allSelected
                                ? cubit.clearFilters()
                                : cubit.selectAllBreeds();
                          },
                          child: Text(
                            allSelected ? 'Сбросить всё' : 'Выбрать все',
                            style: const TextStyle(
                              color: Colors.lightGreenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          breeds.map((breed) {
                            final isSelected = selected.contains(breed);
                            return FilterChip(
                              label: Text(
                                breed,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: Colors.lightGreenAccent,
                              backgroundColor: Colors.grey[800],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:
                                      isSelected
                                          ? Colors.lightGreen
                                          : Colors.white24,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (_) {
                                cubit.toggleFilter(breed);
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
