import 'package:flutter/cupertino.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmptyWorkout(),
        _buildListWorkouts()
      ],
    );
  }

  Widget _buildWorkout(String workoutTitle, String workoutExercises) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: CupertinoColors.systemGrey3),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 180,
        height: 100,
        child: CupertinoButton(
          padding: const EdgeInsets.all(15),
          onPressed: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(workoutTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                      fontSize: 14)),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(workoutExercises,
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
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.5, vertical: 0.2),
                      onPressed: () {},
                      child: const Text('Create and start a workout',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ])),
        ]));
  }

  Widget _buildListWorkouts() {
    // return Text('hi');
    return Expanded(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.0, color: CupertinoColors.activeBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 180,
                height: 100,
                child: CupertinoButton(
                  onPressed: () {},
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.add_circled),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Add Workout',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _buildWorkout('Legs',
                  'Squat, Leg Press, Leg Extension, Standing Calf Raise'),
              _buildWorkout('Chest and Triceps',
                  'Bench Press, Incline Bench Press, Strict Military Press'),
              _buildWorkout('Back and Biceps',
                  'Deadlift, Seated Row, Lat Pulldowns, Bicep Curls'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
              _buildWorkout('Abs and Core',
                  'Plank, Deadbugs, Russian Twists, Mountain Climbers'),
            ])));
  }
}
