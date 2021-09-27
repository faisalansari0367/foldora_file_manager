class BatteryManager {
  bool present;
  int plugged;
  int status;
  int health;
  String technology;
  int scale;
  int level;
  int temperature;
  int voltage;
  int healthDead;
  int healthCold;
  int healthGood;
  // int current;
  int chargeCounter;
  int currentNow;
  int currentAvg;
  int energyCounter;

  BatteryManager({
    this.present,
    this.plugged,
    this.status,
    this.health,
    this.technology,
    this.scale,
    this.level,
    this.temperature,
    this.voltage,
    this.healthDead,
    this.healthCold,
    this.healthGood,
    // this.current,
    this.chargeCounter,
    this.currentNow,
    this.currentAvg,
    this.energyCounter,
  });

  static BatteryManager fromMap(Map<Object, Object> map) {
    return BatteryManager(
      energyCounter: map['energyCounter'],
      chargeCounter: map['chargeCounter'],
      // current: map['current'],
      currentAvg: map['currentAvg'],
      currentNow: map['currentNow'],
      healthCold: map['healthCold'],
      healthDead: map['healthDead'],
      healthGood: map['healthGood'],
      health: map['health'],
      level: map['level'],
      plugged: map['plugged'],
      present: map['present'],
      scale: map['scale'],
      status: map['status'],
      technology: map['technology'],
      temperature: map['temperature'],
      voltage: map['voltage'],
    );
  }
}
