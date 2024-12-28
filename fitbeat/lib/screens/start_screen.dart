import 'package:flutter/cupertino.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEmptyWorkout(),
        buildListWorkouts()
        // buildWorkout(),
      ],
    );
  }

  Widget buildWorkout() {
    return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: CupertinoColors.systemGrey3),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
          Align(
        alignment: AlignmentDirectional.topStart, 
        child: CupertinoButton(
            onPressed: () {},
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.black )),
                Text('description', style: TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2)),
              ],
            ),
          ),
    ));
  }

  Widget _buildHeader() {
    return const Text('top');
    // List<Widget> workoutWidgets = [];

    // // Use a loop to create multiple widgets
    // for (int i = 0; i < 10; i++) {
    //   workoutWidgets.add(
    //    buildWorkout()
    //   );
    // }

    // return Padding (
    //     padding: const EdgeInsets.all(16),
    //     child: Column (

    //     children: [
    //       const Text('Start Workout',
    //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    //       Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    //         CupertinoButton.filled(
    //           onPressed: () {},
    //           minSize: kMinInteractiveDimensionCupertino,
    //           child: const Text('Create and start a workout',
    //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    //         ),
    //       ]),

    //       const SizedBox(height: 20),

    //       const Text('Workouts'),

    //     SizedBox(
    //       height: 600,
    //     child: 
    //     GridView.count(
    //       crossAxisSpacing: 10,
    //       mainAxisSpacing: 10,
    //       crossAxisCount: 2,
    //       primary: false,
    //       padding: const EdgeInsets.all(20),
    //       children: [
    //         Container(
    //               decoration: BoxDecoration(
    //                 border: Border.all(
    //                     width: 1.0, color: CupertinoColors.activeBlue),
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //               child: CupertinoButton(
    //                 onPressed: () {},
    //                 child: const Column(
    //                   children: [
    //                     Icon(CupertinoIcons.add_circled),
    //                     Text('Add Workout'),
    //                   ],
    //                 ),
    //               ),
    //         ),
    //         buildWorkout(),
    //         buildWorkout(),
    //         buildWorkout(),
    //         buildWorkout(),

    //       ])
    //     )
    //     ] 
    //     )
        
    
      
    
        // );
  }


Widget buildEmptyWorkout() {
  return Padding (
    padding: const EdgeInsets.all(14),
    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
    children: [ 
     const Text('Start Workout',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Padding (
            padding: const EdgeInsets.only(top: 10),
            child: 
          
 
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.2),
              onPressed: () {},
              child: const Text('Create and start a workout',

                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
             ]        )
          )

             ,
    ]
    )
  );
}


Widget buildListWorkouts() {
  // return Text('hi');
  return
  Expanded(child: 
  Padding(padding: const EdgeInsets.all(10),
  child: 
    GridView.count(
      shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          primary: false,
          children: [
            Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0, color: CupertinoColors.activeBlue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CupertinoButton(
                    onPressed: () {},
                    child: const Column(
                      children: [
                        Icon(CupertinoIcons.add_circled),
                        Text('Add Workout'),
                      ],
                    ),
                  ),
            ),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),
            buildWorkout(),


          ])));
}

}