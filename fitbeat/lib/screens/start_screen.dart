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
      children: [_buildEmptyWorkout(context), _listWeightWorkouts(context), _listIntervalWorkouts(context)],
    );
  }

  String generateExerciseList(List<Exercise> workoutExercises) {
    return workoutExercises.map((exercise) => exercise.name).join(', ');
  }

  Widget _buildWorkout(String workoutTitle, List<Exercise> workoutExercises,
      BuildContext context) {
    return SizedBox(
        width: 170,
        height: 100,
        child: CardButton(
          onPressed: () => _showWorkoutExercises(workoutExercises, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(workoutTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                      fontSize: 14)
                  ),

              Text(generateExerciseList(workoutExercises),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.systemGrey2,
                          fontSize: 12))
                  .withPadding(top: 5),
            ],
          ),
        ));
  }

  Widget _buildEmptyWorkout(BuildContext context) {

    return 
     CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: 
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          // hideNavbar()
                          _chooseWorkout(context);
                          
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => CreateWorkoutPage(
                          //       showNavbar: showNavbar,
                          //     ),
                          //   ),
                          // );
                        })
                  ]))
        ]).withPadding(all: 15));
  }

  void _chooseWorkout(BuildContext context) {
  
     showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (context) => ChooseWorkoutScreen());
    }

  
  Widget _listWeightWorkouts(BuildContext context) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Weight Training').bold().withPadding(bottom: 5),
      Expanded(
          child: SingleChildScrollView(
              child: Wrap(spacing: 8, runSpacing: 8, children: [
        SizedBox(
          width: 170,
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
      ])))
    ]).withPadding(horizontal: 15).withMargin(bottom: 15));
  }

   Widget _listIntervalWorkouts(BuildContext context) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Interval Training').bold().withPadding(bottom: 5),
      Expanded(
          child: SingleChildScrollView(
              child: Wrap(spacing: 8, runSpacing: 8, children: [
        SizedBox(
          width: 170,
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
      ])))
    ]).withPadding(horizontal: 15, bottom: 15));
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
        resizeToAvoidBottomInset: false,
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
    return 
    CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
        child: SafeArea(child: 
        Column(children: [
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
                      : Column(children: [
                          Expanded(
                              child: ListView.builder(
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              return _exerciseCard(exercises[
                                  index]); // Return the widget for each exercise
                            }, // Convert the Iterable to a List
                          ))
                        ]))),
          Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      widget.showNavbar();
                      Navigator.pop(context);
                    },
                  ),
                  PrimaryButton(
                    child: Text('Finish'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ))
        ]).withPadding(horizontal: 15)
    ));
  }

  Widget _exerciseCard(Exercise exercise) {
    return Card(
            child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Text(exercise.name).xSmall().bold(),
        ),
        Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red[400]),
            child: OutlineButton(
                shape: ButtonShape.circle,
                size: ButtonSize.xSmall,
                onPressed: () {
                  setState(() {
                    exercises.remove(exercise); // Remove the exercise
                  });
                },
                child: Icon(
                  RadixIcons.cross2,
                  color: Colors.white,
                )))
      ]),
      exercise.sets?.isEmpty ?? true
          ? Center(child: Text('No items available'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(exercise.sets!.length, (index) {
                var set = exercise.sets![index];
                return Column(children: [
                  Row(children: [
                    Text('Set ${index + 1}',
                            style: TextStyle(color: Colors.neutral[400]))
                        .xSmall()
                        .bold()
                  ]).withMargin(top: 8),
                  Row(children: [
                    Expanded(
                        child: Transform.scale(
                            scale: 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reps').medium(),
                                NumberInput(
                                    initialValue: 0,
                                    onChanged: (newValue) {
                                      setState(() {
                                        set.reps = newValue;
                                      });
                                    })
                              ],
                            ))),
                    Expanded(
                        child: Transform.scale(
                            scale: 0.7,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Weight/Time').medium(),
                                  NumberInput(
                                      initialValue: 0,
                                      onChanged: (newValue) {
                                        setState(() {
                                          set.weight = newValue;
                                        });
                                      })
                                ]))),
                  ]),
                ]);
              }).toList(),
            ),
      PrimaryButton(
        leading: const Icon(Icons.add),
        size: ButtonSize.small,
        onPressed: () async {
          setState(() {
            exercise.sets?.add(Set(0.0, 0.0));
          });
        },
        child: const Text('Add Set'),
      )
    ]).withPadding(right: 0, left: 8))
        .withPadding(all: 8);
  }
}

// -----------------------ACTION SHEET-----------------------

class ChooseWorkoutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
return
    Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
                Text(
                  'Select Workout Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ]).withPadding(bottom: 15),
          PrimaryButton(child: Text('Weight Training'), onPressed: (){
              Navigator.pop(context); 
           Navigator.of(context, rootNavigator: true).push(
  CupertinoPageRoute(builder: (context) => CreateWorkoutPage(showNavbar: () {})),
);
          }).withPadding(bottom: 15),
          PrimaryButton(child: Text('Interval Training'), onPressed: (){}),
        ],
      ).withPadding(horizontal: 20, top: 20, bottom: 40)
      );
  }


}
