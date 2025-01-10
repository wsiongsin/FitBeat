
class Exercise {
  String exerciseID;
  String name;
  String? exerciseImage;
  String? exerciseTarget;
  List<Set>? sets = [];

  Exercise(this.exerciseID, this.name, {this.exerciseImage, this.exerciseTarget, this.sets});
}


class Set {
  double reps = 0;
  double weight = 0;

  Set(this.reps, this.weight);
}


enum StepType {
  rest,
  recover,
  run,
}

enum Metric {
  distance,
  time
}

class WorkoutStep {
  StepType type;
  Metric metric = Metric.time;
  double metricValue = 0;

  WorkoutStep(this.type, this.metric, this.metricValue);

  
}