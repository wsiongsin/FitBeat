import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitbeat/models/exercise.dart';
import 'package:fitbeat/pages/musicSetup.dart';

// ---------------------------------- EXERCISE LIST PAGE ----------------------------------
class IntervalSetupPage extends StatefulWidget {
  const IntervalSetupPage({Key? key}) : super(key: key);

  @override
  _IntervalSetupPageState createState() => _IntervalSetupPageState();
}

class _IntervalSetupPageState extends State<IntervalSetupPage> {
  List<Widget> workoutOrder = [];

  final Map<StepType, String> steptoStringMap = {
    StepType.run: 'Run',
    StepType.rest: 'Rest',
    StepType.recover: 'Recover',
  };

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _intervalSetup(),
        _workoutActions(),
        _pageActions(),
      ],
    ).withPadding(horizontal: 15, top: 15, bottom: 5)));
  }

  Widget _intervalSetup() {
    return Expanded(
        child: Column(children: [
      Text(
        'Plan out your entire workout',
        style: TextStyle(color: Colors.gray[400]),
      ).small().semiBold().withPadding(bottom: 5),
      Expanded(
          child: ListView(
                  children: workoutOrder.map((widget) {
        return widget.withMargin(vertical: 3); // Each item in workoutOrder is added as a child.
      }).toList())
              .withPadding(horizontal: 15))
    ]));
  }

  Widget _addStep(WorkoutStep singleStep) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(
          
          children: [
        Container(
            decoration: BoxDecoration(
              color: singleStep.type == StepType.run
                  ? Colors.green[300]
                  : singleStep.type == StepType.rest
                      ? Colors.amber[200]
                      : Colors.zinc[300],
              borderRadius: BorderRadius.circular(10),
            ),
            width: 8,
            height: 50),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(steptoStringMap[singleStep.type] ?? '-').xSmall(),
            Text(singleStep.metricValue.toString()).xSmall()
          ],
        ).withPadding(left: 10)]),
        Row(children: [
              TextButton(
                  size: ButtonSize.small,
                  onPressed: () {
                    setState(() {
                      // Edit exercise
                    });
                  },
                  child: Icon(
                    RadixIcons.pencil1,
                    color: Colors.black,
                  )),
        Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red[400]),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlineButton(
                  shape: ButtonShape.circle,
                  size: ButtonSize.small,
                  onPressed: () {
                    setState(() {
                      // Remove the exercise by id
                    });
                  },
                  child: Icon(
                    RadixIcons.cross2,
                    color: Colors.white,
                  ))
            ]))
      ]),
    ]));
  }

  Widget _addInterval(List<Widget> intervalSteps, int repeat) {
    return
    Container (
      decoration: BoxDecoration(border: Border.all(color: Colors.sky[400], width: 2), borderRadius: BorderRadius.circular(30)),
      child: 
    Column(
      children: [
        Column(
      children: intervalSteps.map((widget) {
        return widget.withMargin(vertical: 3); // Each item in workoutOrder is added as a child.
      }).toList()),
      PrimaryButton(
        leading: const Icon(Icons.add),
        size: ButtonSize.small,
        onPressed: () async {
          setState(() {
            intervalSteps.addAll([_addStep(WorkoutStep(StepType.run, Metric.time, 0))]);
          });
        },
        child: const Text('Add Step'),
      ).withMargin(top: 5)]
      
    ).withPadding(horizontal: 15, vertical: 10));
  }

  Widget _workoutActions() {
    return Column(children: [
      PrimaryButton(
          leading: const Icon(Icons.add),
          child: const Text('Add Step'),
          onPressed: () {
            setState(() {
              workoutOrder.addAll([
                _addStep(WorkoutStep(StepType.run, Metric.time, 0)),
                _addStep(WorkoutStep(StepType.recover, Metric.time, 0)),
                _addStep(WorkoutStep(StepType.rest, Metric.time, 0))
              ]);
            });
          }).withMargin(top: 40),
      PrimaryButton(
          leading: const Icon(Icons.add),
          child: const Text('Add Repeat Interval'),
          onPressed: () {
            setState(() {
              workoutOrder.add(_addInterval([
                _addStep(WorkoutStep(StepType.run, Metric.time, 0)),
                _addStep(WorkoutStep(StepType.run, Metric.time, 0)),
                _addStep(WorkoutStep(StepType.run, Metric.time, 0)),
                _addStep(WorkoutStep(StepType.run, Metric.time, 0)),
                _addStep(WorkoutStep(StepType.rest, Metric.time, 0))
              ], 2));
            });
          }).withMargin(top: 5)
    ]).center().withMargin(bottom: 10);
  }

  Widget _pageActions() {
    return Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlineButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            PrimaryButton(
              child: Text('Next'),
              onPressed: () {
                 Navigator.of(context, rootNavigator: true).push(
  CupertinoPageRoute(builder: (context) => MusicSetupPage()));
              },
            )
          ],
        ));
  }
}
