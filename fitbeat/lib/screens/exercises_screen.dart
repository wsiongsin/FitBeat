import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  String? selectedTarget;
  String? selectedEquipment;
  List<dynamic> exercises = [];
  bool isLoading = false;
  String? error;
  int currentPage = 0;
  final int itemsPerPage = 0;

  final List<String> targetList = [
    "abs",
    "adductors",
    "biceps",
    "calves",
    "cardiovascular system",
    "delts",
    "forearms",
    "glutes",
    "hamstrings",
    "lats",
    "levator scapulae",
    "pectorals",
    "quads",
    "serratus anterior",
    "spine",
    "traps",
    "triceps",
    "upper back"
  ];

  final List<String> equipmentList = [
    "assisted",
    "band",
    "barbell",
    "body weight",
    "bosu ball",
    "cable",
    "dumbbell",
    "elliptical machine",
    "ez barbell",
    "hammer",
    "kettlebell",
    "leverage machine",
    "medicine ball",
    "olympic barbell",
    "resistance band",
    "roller",
    "rope",
    "skierg machine",
    "sled machine",
    "smith machine",
    "stability ball",
    "stationary bike",
    "stepmill machine",
    "tire",
    "trap bar",
    "upper body ergometer",
    "weighted",
    "wheel roller"
  ];

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    if (mounted) {
    setState(() {
      isLoading = true;
      error = null;
    });
    }

    var url = 'https://exercisedb.p.rapidapi.com/exercises?limit=0&offset=0';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
          'x-rapidapi-key':
              '8c93546fa6msha70544334442399p1c16c5jsn25a315b8ab15',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
        setState(() {
          exercises = data.where((exercise) {
            final matchesTarget =
                selectedTarget == null || exercise['target'] == selectedTarget;
            final matchesEquipment = selectedEquipment == null ||
                exercise['equipment'] == selectedEquipment;
            return matchesTarget && matchesEquipment;
          }).toList();
          isLoading = false;
        });
        }
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      if (mounted) {
      setState(() {
        error = 'Error fetching exercises: $e';
        isLoading = false;
      });
      }
    }
  }

  void _showInstructionsDialog(Map<String, dynamic> exercise) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(exercise['name']),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      exercise['gifUrl'],
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 200,
                          child: CupertinoActivityIndicator(),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (exercise['instructions'] as List).join('\n\n'),
                  style: const TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildSearchBar(),
        _buildFilters(),
        Expanded(
          child: _buildExercisesList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Exercises',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('New'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CupertinoSearchTextField(
        placeholder: 'Search',
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterButton(
            'Target Muscle',
            selectedTarget,
            targetList,
            (value) {
              setState(() => selectedTarget = value);
              fetchExercises();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            'Equipment',
            selectedEquipment,
            equipmentList,
            (value) {
              setState(() => selectedEquipment = value);
              fetchExercises();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    String? selectedValue,
    List<String> options,
    Function(String?) onSelect,
  ) {
    return GestureDetector(
      onTap: () {
        _showFilterOptions(label, options, selectedValue, onSelect);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedValue != null
              ? CupertinoColors.activeBlue.withOpacity(0.1)
              : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(16),
          border: selectedValue != null
              ? Border.all(color: CupertinoColors.activeBlue)
              : null,
        ),
        child: Text(
          selectedValue ?? label,
          style: TextStyle(
            color: selectedValue != null
                ? CupertinoColors.activeBlue
                : CupertinoColors.label,
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String?) onSelect,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Clear'),
                      onPressed: () {
                        onSelect(null);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == selectedValue;
                    return GestureDetector(
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CupertinoColors.activeBlue.withOpacity(0.1)
                              : null,
                          border: Border(
                            bottom: BorderSide(
                              color: CupertinoColors.separator
                                  .resolveFrom(context),
                            ),
                          ),
                        ),
                        child: Text(
                          option.toUpperCase(),
                          style: TextStyle(
                            color: isSelected
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.label.resolveFrom(context),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExercisesList() {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    if (exercises.isEmpty) {
      return const Center(child: Text('No exercises found'));
    }

    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _buildExerciseItem(exercise);
      },
    );
  }

  Widget _buildExerciseItem(Map<String, dynamic> exercise) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showInstructionsDialog(exercise),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  exercise['gifUrl'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Target: ${exercise['target']}',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Equipment: ${exercise['equipment']}',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
