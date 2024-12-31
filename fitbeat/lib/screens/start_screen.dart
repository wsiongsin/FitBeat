import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Exercise {
  String exerciseID;
  String name;
  String? exerciseImage;
  String? exerciseTarget;

  Exercise(this.exerciseID, this.name, {this.exerciseImage, this.exerciseTarget});
}



class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);
  


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
        return 
             CupertinoAlertDialog(
          content: Column(
          children: [Column(
                    children: workoutExercises.map((exercise) {
                    return Column (
                      children: [
                        Padding(padding: EdgeInsets.all(5), child: 
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Image.network(exercise.exerciseImage ?? '', height: 50, fit: BoxFit.cover), 
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(exercise.name), Text(exercise.exerciseTarget ?? '', style: const TextStyle(fontWeight: FontWeight.bold) )])
                          )
                          ]
                        ),
                        ),
                      ]
                    );
                  }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          child:
           CupertinoButton.filled
           (
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text('Start Workout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
           , onPressed: () {})
             )]),
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
      children: [_buildEmptyWorkout(), _buildListWorkouts(context)],
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

  Widget _buildEmptyWorkout() {
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
                    PrimaryButton(size: ButtonSize.normal, shape: ButtonShape.rectangle, child: const Text('Create and start a workout').small(), onPressed: () {})]))]));
    //                 CupertinoButton.filled(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 0.5, vertical: 0.2),
    //                   onPressed: () {},
    //                   child: const Text('Create and start a workout',
    //                       style: TextStyle(
    //                           fontSize: 14, fontWeight: FontWeight.bold)),
    //                 ),
    //               ])),
    //     ]));
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
                  onPressed: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(BootstrapIcons.plusCircleFill),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Add Workout'
                        ).bold(),
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
