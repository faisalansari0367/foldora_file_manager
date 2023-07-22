class BatteryManager {
  bool? present;
  int? plugged;
  int? status;
  int? health;
  String? technology;
  int? scale;
  int? level;
  int? temperature;
  int? voltage;
  int? healthDead;
  int? healthCold;
  int? healthGood;
  // int current;
  int? chargeCounter;
  int? currentNow;
  int? currentAvg;
  int? energyCounter;

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
      energyCounter: map['energyCounter'] as int?,
      chargeCounter: map['chargeCounter'] as int?,
      // current: map['current'],
      currentAvg: map['currentAvg'] as int?,
      currentNow: map['currentNow'] as int?,
      healthCold: map['healthCold'] as int?,
      healthDead: map['healthDead'] as int?,
      healthGood: map['healthGood'] as int?,
      health: map['health'] as int?,
      level: map['level'] as int?,
      plugged: map['plugged'] as int?,
      present: map['present'] as bool?,
      scale: map['scale'] as int?,
      status: map['status'] as int?,
      technology: map['technology'] as String?,
      temperature: map['temperature'] as int?,
      voltage: map['voltage'] as int?,
    );
  }
}
