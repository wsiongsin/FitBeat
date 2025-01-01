
class Exercise {
  String exerciseID;
  String name;
  String? exerciseImage;
  String? exerciseTarget;
  List<Set>? sets = [];

  Exercise(this.exerciseID, this.name, {this.exerciseImage, this.exerciseTarget, this.sets});
}


class Set {
  int reps = 0;
  int weight = 0;

  Set(this.reps, this.weight);
}
