import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitbeat/pages/addExerciseDialog.dart';
import 'package:fitbeat/models/exercise.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback showNavbar;
  final VoidCallback hideNavbar;

  const StartScreen(
      {Key? key, required this.showNavbar, required this.hideNavbar})
      : super(key: key);

  void _showWorkoutExercises(
      List<Exercise> workoutExercises, BuildContext context) async {
    for (Exercise exercise in workoutExercises) {
      var url =
          'https://exercisedb.p.rapidapi.com/exercises/exercise/${exercise.exerciseID}';

      try {
        final response = await http.get(Uri.parse(url), headers: {
          'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
          'x-rapidapi-key':
              'a4f124151emsh69a768d8c7c555ep132412jsn5b9732ed3762',
        });

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          exercise.exerciseTarget = data['target'];
          exercise.exerciseImage = data['gifUrl'];
        } else {
          throw Exception('Failed to load exercises');
        }
      } catch (e) {
        print('Error fetching exercises');
      }
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Column(children: [
            Column(
              children: workoutExercises.map((exercise) {
                return Column(children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(exercise.exerciseImage ?? '',
                              height: 50, fit: BoxFit.cover),
                          Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(exercise.name),
                                    Text(exercise.exerciseTarget ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]))
                        ]),
                  ),
                ]);
              }).toList(),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: CupertinoButton.filled(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text('Start Workout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () {}))
          ]),
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
      children: [_buildEmptyWorkout(context), _buildListWorkouts(context)],
    );
  }

  String generateExerciseList(List<Exercise> workoutExercises) {
    return workoutExercises.map((exercise) => exercise.name).join(', ');
  }

  Widget _buildWorkout(String workoutTitle, List<Exercise> workoutExercises,
      BuildContext context) {
    return SizedBox(
        width: 180,
        height: 100,
        child: CardButton(
          onPressed: () => _showWorkoutExercises(workoutExercises, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(workoutTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                      fontSize: 14)),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(generateExerciseList(workoutExercises),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.systemGrey2,
                        fontSize: 12)),
              )
            ],
          ),
        ));
  }

  Widget _buildEmptyWorkout(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Start Workout',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                        size: ButtonSize.normal,
                        shape: ButtonShape.rectangle,
                        child: const Text('Start a workout').small(),
                        onPressed: () {
                          hideNavbar();
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CreateWorkoutPage(
                                showNavbar: showNavbar,
                              ),
                            ),
                          );
                        })
                  ]))
        ]));
  }

  Widget _buildListWorkouts(BuildContext context) {
    // return Text('hi');
    return Expanded(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              SizedBox(
                width: 180,
                height: 100,
                child: CardButton(
                  onPressed: () {
                    hideNavbar();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AddWorkoutPage(
                          hideNavbar: hideNavbar,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(BootstrapIcons.plusCircleFill),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text('Add Workout').bold(),
                      )
                    ],
                  ),
                ),
              ),
              _buildWorkout(
                  'Legs',
                  [
                    Exercise('2368', 'Split Squat'),
                    Exercise('0054', 'Lunges'),
                    Exercise('0760', 'Leg Press'),
                    Exercise('1459', 'RDLs')
                  ],
                  context),
              _buildWorkout(
                  'Chest and Shoulder',
                  [
                    Exercise('0025', 'Bench Press'),
                    Exercise('1456', 'Military Press'),
                    Exercise('0178', 'Lateral Raises')
                  ],
                  context),
              _buildWorkout(
                  'Back and Biceps',
                  [
                    Exercise('0160', 'Seated Row'),
                    Exercise('1429', 'Pull Ups'),
                    Exercise('0285', 'Bicep Curls')
                  ],
                  context),
              _buildWorkout(
                  'Abs and Core',
                  [
                    Exercise('0464', 'Plank'),
                    Exercise('0687', 'Russian Twists'),
                    Exercise('3699', 'Shoulder Taps')
                  ],
                  context),
            ])));
  }
}

// ---------------------------------- ADDWORKOUT PAGE ----------------------------------
class AddWorkoutPage extends StatelessWidget {
  final VoidCallback hideNavbar;

  AddWorkoutPage({Key? key, required this.hideNavbar}) : super(key: key);

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.back),
            onPressed: () {
              hideNavbar();
              Navigator.pop(context);
            },
          ),
        ),
        child: Text('asdfa'));
  }
}

// ---------------------------------- CREATE + START WORKOUT PAGE ----------------------------------

class CreateWorkoutPage extends StatefulWidget {
  final VoidCallback showNavbar;

  const CreateWorkoutPage({Key? key, required this.showNavbar})
      : super(key: key);
  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  List<Exercise> exercises = [];

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(children: [
      //       Row(children: [
      //         Row (children: [
      //           GhostButton(
      //   onPressed: () {},
      //   trailing: const Icon(RadixIcons.pencil1),
      //   child: Text(workoutName),
      // ),
      //         ])
      //       ],),

      PrimaryButton(
          leading: const Icon(Icons.add),
          child: const Text('Add Exercise'),
          onPressed: () async {
            final result = await Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ExercisesPage()));

            if (result != null) {
              // If exercises list is updated, update the state of this page
              setState(() {
                exercises.addAll(result);
              });
            }
          }).withMargin(top: 40),

      Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: exercises.isEmpty
                  ? Center(
                    child: Text(
                      'Add an exercise to get started',
                      style: TextStyle(color: Colors.gray[300]),
                    ).small().semiBold())
                  : ListView(
                      children: exercises.map((item) {
                        return Card(
                            child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.name).xSmall().bold(),
                                IconButton.destructive(
                                  icon: Icon(RadixIcons.cross2),
                                  onPressed: () {},
                                  shape: ButtonShape.circle,
                                )
                              ]),
                          item.sets?.isEmpty ?? true
                              ? Center(child: Text('No items available'))
                              : Column(
                                  children: item.sets!.map((set) {
                                    return Text(
                                        'Reps: ${set.reps}, Weight: ${set.weight}');
                                  }).toList(), // Convert map to list here
                                ),
                        ]));
                      }).toList(), // Convert the Iterable to a List
                    ))),
      Container(
         decoration: BoxDecoration(
          color: Colors.transparent
        ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlineButton(
                child: Text('Cancel'),
                onPressed: () {Navigator.pop(context);},
              ),
            ],
          ))
    ]));
  }
}
