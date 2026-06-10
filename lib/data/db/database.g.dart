// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BrokersTable extends Brokers with TableInfo<$BrokersTable, Broker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrokersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    port,
    username,
    password,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brokers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Broker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Broker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Broker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BrokersTable createAlias(String alias) {
    return $BrokersTable(attachedDatabase, alias);
  }
}

class Broker extends DataClass implements Insertable<Broker> {
  final int id;
  final String name;
  final String address;
  final int port;
  final String? username;
  final String? password;
  final DateTime createdAt;
  const Broker({
    required this.id,
    required this.name,
    required this.address,
    required this.port,
    this.username,
    this.password,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['port'] = Variable<int>(port);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BrokersCompanion toCompanion(bool nullToAbsent) {
    return BrokersCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      port: Value(port),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      createdAt: Value(createdAt),
    );
  }

  factory Broker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Broker(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String?>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String?>(username),
      'password': serializer.toJson<String?>(password),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Broker copyWith({
    int? id,
    String? name,
    String? address,
    int? port,
    Value<String?> username = const Value.absent(),
    Value<String?> password = const Value.absent(),
    DateTime? createdAt,
  }) => Broker(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    port: port ?? this.port,
    username: username.present ? username.value : this.username,
    password: password.present ? password.value : this.password,
    createdAt: createdAt ?? this.createdAt,
  );
  Broker copyWithCompanion(BrokersCompanion data) {
    return Broker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Broker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, address, port, username, password, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Broker &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.port == this.port &&
          other.username == this.username &&
          other.password == this.password &&
          other.createdAt == this.createdAt);
}

class BrokersCompanion extends UpdateCompanion<Broker> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> address;
  final Value<int> port;
  final Value<String?> username;
  final Value<String?> password;
  final Value<DateTime> createdAt;
  const BrokersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BrokersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String address,
    required int port,
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       address = Value(address),
       port = Value(port);
  static Insertable<Broker> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BrokersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? address,
    Value<int>? port,
    Value<String?>? username,
    Value<String?>? password,
    Value<DateTime>? createdAt,
  }) {
    return BrokersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrokersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MetricsTable extends Metrics with TableInfo<$MetricsTable, Metric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brokerIdMeta = const VerificationMeta(
    'brokerId',
  );
  @override
  late final GeneratedColumn<int> brokerId = GeneratedColumn<int>(
    'broker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brokers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishEnabledMeta = const VerificationMeta(
    'publishEnabled',
  );
  @override
  late final GeneratedColumn<bool> publishEnabled = GeneratedColumn<bool>(
    'publish_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("publish_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _minValueMeta = const VerificationMeta(
    'minValue',
  );
  @override
  late final GeneratedColumn<double> minValue = GeneratedColumn<double>(
    'min_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxValueMeta = const VerificationMeta(
    'maxValue',
  );
  @override
  late final GeneratedColumn<double> maxValue = GeneratedColumn<double>(
    'max_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brokerId,
    name,
    topic,
    publishEnabled,
    minValue,
    maxValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<Metric> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('broker_id')) {
      context.handle(
        _brokerIdMeta,
        brokerId.isAcceptableOrUnknown(data['broker_id']!, _brokerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brokerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('publish_enabled')) {
      context.handle(
        _publishEnabledMeta,
        publishEnabled.isAcceptableOrUnknown(
          data['publish_enabled']!,
          _publishEnabledMeta,
        ),
      );
    }
    if (data.containsKey('min_value')) {
      context.handle(
        _minValueMeta,
        minValue.isAcceptableOrUnknown(data['min_value']!, _minValueMeta),
      );
    }
    if (data.containsKey('max_value')) {
      context.handle(
        _maxValueMeta,
        maxValue.isAcceptableOrUnknown(data['max_value']!, _maxValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Metric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Metric(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brokerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}broker_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      publishEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}publish_enabled'],
      )!,
      minValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_value'],
      ),
      maxValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_value'],
      ),
    );
  }

  @override
  $MetricsTable createAlias(String alias) {
    return $MetricsTable(attachedDatabase, alias);
  }
}

class Metric extends DataClass implements Insertable<Metric> {
  final int id;
  final int brokerId;
  final String name;
  final String topic;
  final bool publishEnabled;
  final double? minValue;
  final double? maxValue;
  const Metric({
    required this.id,
    required this.brokerId,
    required this.name,
    required this.topic,
    required this.publishEnabled,
    this.minValue,
    this.maxValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['broker_id'] = Variable<int>(brokerId);
    map['name'] = Variable<String>(name);
    map['topic'] = Variable<String>(topic);
    map['publish_enabled'] = Variable<bool>(publishEnabled);
    if (!nullToAbsent || minValue != null) {
      map['min_value'] = Variable<double>(minValue);
    }
    if (!nullToAbsent || maxValue != null) {
      map['max_value'] = Variable<double>(maxValue);
    }
    return map;
  }

  MetricsCompanion toCompanion(bool nullToAbsent) {
    return MetricsCompanion(
      id: Value(id),
      brokerId: Value(brokerId),
      name: Value(name),
      topic: Value(topic),
      publishEnabled: Value(publishEnabled),
      minValue: minValue == null && nullToAbsent
          ? const Value.absent()
          : Value(minValue),
      maxValue: maxValue == null && nullToAbsent
          ? const Value.absent()
          : Value(maxValue),
    );
  }

  factory Metric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Metric(
      id: serializer.fromJson<int>(json['id']),
      brokerId: serializer.fromJson<int>(json['brokerId']),
      name: serializer.fromJson<String>(json['name']),
      topic: serializer.fromJson<String>(json['topic']),
      publishEnabled: serializer.fromJson<bool>(json['publishEnabled']),
      minValue: serializer.fromJson<double?>(json['minValue']),
      maxValue: serializer.fromJson<double?>(json['maxValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brokerId': serializer.toJson<int>(brokerId),
      'name': serializer.toJson<String>(name),
      'topic': serializer.toJson<String>(topic),
      'publishEnabled': serializer.toJson<bool>(publishEnabled),
      'minValue': serializer.toJson<double?>(minValue),
      'maxValue': serializer.toJson<double?>(maxValue),
    };
  }

  Metric copyWith({
    int? id,
    int? brokerId,
    String? name,
    String? topic,
    bool? publishEnabled,
    Value<double?> minValue = const Value.absent(),
    Value<double?> maxValue = const Value.absent(),
  }) => Metric(
    id: id ?? this.id,
    brokerId: brokerId ?? this.brokerId,
    name: name ?? this.name,
    topic: topic ?? this.topic,
    publishEnabled: publishEnabled ?? this.publishEnabled,
    minValue: minValue.present ? minValue.value : this.minValue,
    maxValue: maxValue.present ? maxValue.value : this.maxValue,
  );
  Metric copyWithCompanion(MetricsCompanion data) {
    return Metric(
      id: data.id.present ? data.id.value : this.id,
      brokerId: data.brokerId.present ? data.brokerId.value : this.brokerId,
      name: data.name.present ? data.name.value : this.name,
      topic: data.topic.present ? data.topic.value : this.topic,
      publishEnabled: data.publishEnabled.present
          ? data.publishEnabled.value
          : this.publishEnabled,
      minValue: data.minValue.present ? data.minValue.value : this.minValue,
      maxValue: data.maxValue.present ? data.maxValue.value : this.maxValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Metric(')
          ..write('id: $id, ')
          ..write('brokerId: $brokerId, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('publishEnabled: $publishEnabled, ')
          ..write('minValue: $minValue, ')
          ..write('maxValue: $maxValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brokerId,
    name,
    topic,
    publishEnabled,
    minValue,
    maxValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Metric &&
          other.id == this.id &&
          other.brokerId == this.brokerId &&
          other.name == this.name &&
          other.topic == this.topic &&
          other.publishEnabled == this.publishEnabled &&
          other.minValue == this.minValue &&
          other.maxValue == this.maxValue);
}

class MetricsCompanion extends UpdateCompanion<Metric> {
  final Value<int> id;
  final Value<int> brokerId;
  final Value<String> name;
  final Value<String> topic;
  final Value<bool> publishEnabled;
  final Value<double?> minValue;
  final Value<double?> maxValue;
  const MetricsCompanion({
    this.id = const Value.absent(),
    this.brokerId = const Value.absent(),
    this.name = const Value.absent(),
    this.topic = const Value.absent(),
    this.publishEnabled = const Value.absent(),
    this.minValue = const Value.absent(),
    this.maxValue = const Value.absent(),
  });
  MetricsCompanion.insert({
    this.id = const Value.absent(),
    required int brokerId,
    required String name,
    required String topic,
    this.publishEnabled = const Value.absent(),
    this.minValue = const Value.absent(),
    this.maxValue = const Value.absent(),
  }) : brokerId = Value(brokerId),
       name = Value(name),
       topic = Value(topic);
  static Insertable<Metric> custom({
    Expression<int>? id,
    Expression<int>? brokerId,
    Expression<String>? name,
    Expression<String>? topic,
    Expression<bool>? publishEnabled,
    Expression<double>? minValue,
    Expression<double>? maxValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brokerId != null) 'broker_id': brokerId,
      if (name != null) 'name': name,
      if (topic != null) 'topic': topic,
      if (publishEnabled != null) 'publish_enabled': publishEnabled,
      if (minValue != null) 'min_value': minValue,
      if (maxValue != null) 'max_value': maxValue,
    });
  }

  MetricsCompanion copyWith({
    Value<int>? id,
    Value<int>? brokerId,
    Value<String>? name,
    Value<String>? topic,
    Value<bool>? publishEnabled,
    Value<double?>? minValue,
    Value<double?>? maxValue,
  }) {
    return MetricsCompanion(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      publishEnabled: publishEnabled ?? this.publishEnabled,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brokerId.present) {
      map['broker_id'] = Variable<int>(brokerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (publishEnabled.present) {
      map['publish_enabled'] = Variable<bool>(publishEnabled.value);
    }
    if (minValue.present) {
      map['min_value'] = Variable<double>(minValue.value);
    }
    if (maxValue.present) {
      map['max_value'] = Variable<double>(maxValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricsCompanion(')
          ..write('id: $id, ')
          ..write('brokerId: $brokerId, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('publishEnabled: $publishEnabled, ')
          ..write('minValue: $minValue, ')
          ..write('maxValue: $maxValue')
          ..write(')'))
        .toString();
  }
}

class $DashboardsTable extends Dashboards
    with TableInfo<$DashboardsTable, Dashboard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brokerIdMeta = const VerificationMeta(
    'brokerId',
  );
  @override
  late final GeneratedColumn<int> brokerId = GeneratedColumn<int>(
    'broker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brokers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, brokerId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dashboard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('broker_id')) {
      context.handle(
        _brokerIdMeta,
        brokerId.isAcceptableOrUnknown(data['broker_id']!, _brokerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brokerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dashboard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dashboard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brokerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}broker_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $DashboardsTable createAlias(String alias) {
    return $DashboardsTable(attachedDatabase, alias);
  }
}

class Dashboard extends DataClass implements Insertable<Dashboard> {
  final int id;
  final int brokerId;
  final String name;
  const Dashboard({
    required this.id,
    required this.brokerId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['broker_id'] = Variable<int>(brokerId);
    map['name'] = Variable<String>(name);
    return map;
  }

  DashboardsCompanion toCompanion(bool nullToAbsent) {
    return DashboardsCompanion(
      id: Value(id),
      brokerId: Value(brokerId),
      name: Value(name),
    );
  }

  factory Dashboard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dashboard(
      id: serializer.fromJson<int>(json['id']),
      brokerId: serializer.fromJson<int>(json['brokerId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brokerId': serializer.toJson<int>(brokerId),
      'name': serializer.toJson<String>(name),
    };
  }

  Dashboard copyWith({int? id, int? brokerId, String? name}) => Dashboard(
    id: id ?? this.id,
    brokerId: brokerId ?? this.brokerId,
    name: name ?? this.name,
  );
  Dashboard copyWithCompanion(DashboardsCompanion data) {
    return Dashboard(
      id: data.id.present ? data.id.value : this.id,
      brokerId: data.brokerId.present ? data.brokerId.value : this.brokerId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dashboard(')
          ..write('id: $id, ')
          ..write('brokerId: $brokerId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, brokerId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dashboard &&
          other.id == this.id &&
          other.brokerId == this.brokerId &&
          other.name == this.name);
}

class DashboardsCompanion extends UpdateCompanion<Dashboard> {
  final Value<int> id;
  final Value<int> brokerId;
  final Value<String> name;
  const DashboardsCompanion({
    this.id = const Value.absent(),
    this.brokerId = const Value.absent(),
    this.name = const Value.absent(),
  });
  DashboardsCompanion.insert({
    this.id = const Value.absent(),
    required int brokerId,
    required String name,
  }) : brokerId = Value(brokerId),
       name = Value(name);
  static Insertable<Dashboard> custom({
    Expression<int>? id,
    Expression<int>? brokerId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brokerId != null) 'broker_id': brokerId,
      if (name != null) 'name': name,
    });
  }

  DashboardsCompanion copyWith({
    Value<int>? id,
    Value<int>? brokerId,
    Value<String>? name,
  }) {
    return DashboardsCompanion(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brokerId.present) {
      map['broker_id'] = Variable<int>(brokerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardsCompanion(')
          ..write('id: $id, ')
          ..write('brokerId: $brokerId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ChartsTable extends Charts with TableInfo<$ChartsTable, ChartConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dashboardIdMeta = const VerificationMeta(
    'dashboardId',
  );
  @override
  late final GeneratedColumn<int> dashboardId = GeneratedColumn<int>(
    'dashboard_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dashboards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _metricIdMeta = const VerificationMeta(
    'metricId',
  );
  @override
  late final GeneratedColumn<int> metricId = GeneratedColumn<int>(
    'metric_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES metrics (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChartType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ChartType>($ChartsTable.$convertertype);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dashboardId,
    metricId,
    type,
    title,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChartConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dashboard_id')) {
      context.handle(
        _dashboardIdMeta,
        dashboardId.isAcceptableOrUnknown(
          data['dashboard_id']!,
          _dashboardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dashboardIdMeta);
    }
    if (data.containsKey('metric_id')) {
      context.handle(
        _metricIdMeta,
        metricId.isAcceptableOrUnknown(data['metric_id']!, _metricIdMeta),
      );
    } else if (isInserting) {
      context.missing(_metricIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChartConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dashboardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dashboard_id'],
      )!,
      metricId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}metric_id'],
      )!,
      type: $ChartsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
    );
  }

  @override
  $ChartsTable createAlias(String alias) {
    return $ChartsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChartType, int, int> $convertertype =
      const EnumIndexConverter<ChartType>(ChartType.values);
}

class ChartConfig extends DataClass implements Insertable<ChartConfig> {
  final int id;
  final int dashboardId;
  final int metricId;
  final ChartType type;
  final String? title;
  const ChartConfig({
    required this.id,
    required this.dashboardId,
    required this.metricId,
    required this.type,
    this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dashboard_id'] = Variable<int>(dashboardId);
    map['metric_id'] = Variable<int>(metricId);
    {
      map['type'] = Variable<int>($ChartsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  ChartsCompanion toCompanion(bool nullToAbsent) {
    return ChartsCompanion(
      id: Value(id),
      dashboardId: Value(dashboardId),
      metricId: Value(metricId),
      type: Value(type),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
    );
  }

  factory ChartConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartConfig(
      id: serializer.fromJson<int>(json['id']),
      dashboardId: serializer.fromJson<int>(json['dashboardId']),
      metricId: serializer.fromJson<int>(json['metricId']),
      type: $ChartsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dashboardId': serializer.toJson<int>(dashboardId),
      'metricId': serializer.toJson<int>(metricId),
      'type': serializer.toJson<int>($ChartsTable.$convertertype.toJson(type)),
      'title': serializer.toJson<String?>(title),
    };
  }

  ChartConfig copyWith({
    int? id,
    int? dashboardId,
    int? metricId,
    ChartType? type,
    Value<String?> title = const Value.absent(),
  }) => ChartConfig(
    id: id ?? this.id,
    dashboardId: dashboardId ?? this.dashboardId,
    metricId: metricId ?? this.metricId,
    type: type ?? this.type,
    title: title.present ? title.value : this.title,
  );
  ChartConfig copyWithCompanion(ChartsCompanion data) {
    return ChartConfig(
      id: data.id.present ? data.id.value : this.id,
      dashboardId: data.dashboardId.present
          ? data.dashboardId.value
          : this.dashboardId,
      metricId: data.metricId.present ? data.metricId.value : this.metricId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartConfig(')
          ..write('id: $id, ')
          ..write('dashboardId: $dashboardId, ')
          ..write('metricId: $metricId, ')
          ..write('type: $type, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dashboardId, metricId, type, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartConfig &&
          other.id == this.id &&
          other.dashboardId == this.dashboardId &&
          other.metricId == this.metricId &&
          other.type == this.type &&
          other.title == this.title);
}

class ChartsCompanion extends UpdateCompanion<ChartConfig> {
  final Value<int> id;
  final Value<int> dashboardId;
  final Value<int> metricId;
  final Value<ChartType> type;
  final Value<String?> title;
  const ChartsCompanion({
    this.id = const Value.absent(),
    this.dashboardId = const Value.absent(),
    this.metricId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
  });
  ChartsCompanion.insert({
    this.id = const Value.absent(),
    required int dashboardId,
    required int metricId,
    required ChartType type,
    this.title = const Value.absent(),
  }) : dashboardId = Value(dashboardId),
       metricId = Value(metricId),
       type = Value(type);
  static Insertable<ChartConfig> custom({
    Expression<int>? id,
    Expression<int>? dashboardId,
    Expression<int>? metricId,
    Expression<int>? type,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dashboardId != null) 'dashboard_id': dashboardId,
      if (metricId != null) 'metric_id': metricId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
    });
  }

  ChartsCompanion copyWith({
    Value<int>? id,
    Value<int>? dashboardId,
    Value<int>? metricId,
    Value<ChartType>? type,
    Value<String?>? title,
  }) {
    return ChartsCompanion(
      id: id ?? this.id,
      dashboardId: dashboardId ?? this.dashboardId,
      metricId: metricId ?? this.metricId,
      type: type ?? this.type,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dashboardId.present) {
      map['dashboard_id'] = Variable<int>(dashboardId.value);
    }
    if (metricId.present) {
      map['metric_id'] = Variable<int>(metricId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $ChartsTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartsCompanion(')
          ..write('id: $id, ')
          ..write('dashboardId: $dashboardId, ')
          ..write('metricId: $metricId, ')
          ..write('type: $type, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $ReadingsTable extends Readings with TableInfo<$ReadingsTable, Reading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _metricIdMeta = const VerificationMeta(
    'metricId',
  );
  @override
  late final GeneratedColumn<int> metricId = GeneratedColumn<int>(
    'metric_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES metrics (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, metricId, value, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('metric_id')) {
      context.handle(
        _metricIdMeta,
        metricId.isAcceptableOrUnknown(data['metric_id']!, _metricIdMeta),
      );
    } else if (isInserting) {
      context.missing(_metricIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      metricId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}metric_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ReadingsTable createAlias(String alias) {
    return $ReadingsTable(attachedDatabase, alias);
  }
}

class Reading extends DataClass implements Insertable<Reading> {
  final int id;
  final int metricId;
  final double value;
  final DateTime timestamp;
  const Reading({
    required this.id,
    required this.metricId,
    required this.value,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['metric_id'] = Variable<int>(metricId);
    map['value'] = Variable<double>(value);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      metricId: Value(metricId),
      value: Value(value),
      timestamp: Value(timestamp),
    );
  }

  factory Reading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reading(
      id: serializer.fromJson<int>(json['id']),
      metricId: serializer.fromJson<int>(json['metricId']),
      value: serializer.fromJson<double>(json['value']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'metricId': serializer.toJson<int>(metricId),
      'value': serializer.toJson<double>(value),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Reading copyWith({
    int? id,
    int? metricId,
    double? value,
    DateTime? timestamp,
  }) => Reading(
    id: id ?? this.id,
    metricId: metricId ?? this.metricId,
    value: value ?? this.value,
    timestamp: timestamp ?? this.timestamp,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      metricId: data.metricId.present ? data.metricId.value : this.metricId,
      value: data.value.present ? data.value.value : this.value,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('metricId: $metricId, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, metricId, value, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.metricId == this.metricId &&
          other.value == this.value &&
          other.timestamp == this.timestamp);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<int> id;
  final Value<int> metricId;
  final Value<double> value;
  final Value<DateTime> timestamp;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.metricId = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int metricId,
    required double value,
    required DateTime timestamp,
  }) : metricId = Value(metricId),
       value = Value(value),
       timestamp = Value(timestamp);
  static Insertable<Reading> custom({
    Expression<int>? id,
    Expression<int>? metricId,
    Expression<double>? value,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (metricId != null) 'metric_id': metricId,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? metricId,
    Value<double>? value,
    Value<DateTime>? timestamp,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      metricId: metricId ?? this.metricId,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (metricId.present) {
      map['metric_id'] = Variable<int>(metricId.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('metricId: $metricId, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BrokersTable brokers = $BrokersTable(this);
  late final $MetricsTable metrics = $MetricsTable(this);
  late final $DashboardsTable dashboards = $DashboardsTable(this);
  late final $ChartsTable charts = $ChartsTable(this);
  late final $ReadingsTable readings = $ReadingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    brokers,
    metrics,
    dashboards,
    charts,
    readings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'brokers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('metrics', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'brokers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dashboards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'dashboards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('charts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'metrics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('charts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'metrics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('readings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BrokersTableCreateCompanionBuilder =
    BrokersCompanion Function({
      Value<int> id,
      required String name,
      required String address,
      required int port,
      Value<String?> username,
      Value<String?> password,
      Value<DateTime> createdAt,
    });
typedef $$BrokersTableUpdateCompanionBuilder =
    BrokersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> address,
      Value<int> port,
      Value<String?> username,
      Value<String?> password,
      Value<DateTime> createdAt,
    });

final class $$BrokersTableReferences
    extends BaseReferences<_$AppDatabase, $BrokersTable, Broker> {
  $$BrokersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MetricsTable, List<Metric>> _metricsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.metrics,
    aliasName: $_aliasNameGenerator(db.brokers.id, db.metrics.brokerId),
  );

  $$MetricsTableProcessedTableManager get metricsRefs {
    final manager = $$MetricsTableTableManager(
      $_db,
      $_db.metrics,
    ).filter((f) => f.brokerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_metricsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DashboardsTable, List<Dashboard>>
  _dashboardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dashboards,
    aliasName: $_aliasNameGenerator(db.brokers.id, db.dashboards.brokerId),
  );

  $$DashboardsTableProcessedTableManager get dashboardsRefs {
    final manager = $$DashboardsTableTableManager(
      $_db,
      $_db.dashboards,
    ).filter((f) => f.brokerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dashboardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BrokersTableFilterComposer
    extends Composer<_$AppDatabase, $BrokersTable> {
  $$BrokersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> metricsRefs(
    Expression<bool> Function($$MetricsTableFilterComposer f) f,
  ) {
    final $$MetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.brokerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableFilterComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dashboardsRefs(
    Expression<bool> Function($$DashboardsTableFilterComposer f) f,
  ) {
    final $$DashboardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dashboards,
      getReferencedColumn: (t) => t.brokerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashboardsTableFilterComposer(
            $db: $db,
            $table: $db.dashboards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrokersTableOrderingComposer
    extends Composer<_$AppDatabase, $BrokersTable> {
  $$BrokersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrokersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrokersTable> {
  $$BrokersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> metricsRefs<T extends Object>(
    Expression<T> Function($$MetricsTableAnnotationComposer a) f,
  ) {
    final $$MetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.brokerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dashboardsRefs<T extends Object>(
    Expression<T> Function($$DashboardsTableAnnotationComposer a) f,
  ) {
    final $$DashboardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dashboards,
      getReferencedColumn: (t) => t.brokerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashboardsTableAnnotationComposer(
            $db: $db,
            $table: $db.dashboards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrokersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrokersTable,
          Broker,
          $$BrokersTableFilterComposer,
          $$BrokersTableOrderingComposer,
          $$BrokersTableAnnotationComposer,
          $$BrokersTableCreateCompanionBuilder,
          $$BrokersTableUpdateCompanionBuilder,
          (Broker, $$BrokersTableReferences),
          Broker,
          PrefetchHooks Function({bool metricsRefs, bool dashboardsRefs})
        > {
  $$BrokersTableTableManager(_$AppDatabase db, $BrokersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrokersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrokersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrokersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrokersCompanion(
                id: id,
                name: name,
                address: address,
                port: port,
                username: username,
                password: password,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String address,
                required int port,
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrokersCompanion.insert(
                id: id,
                name: name,
                address: address,
                port: port,
                username: username,
                password: password,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BrokersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({metricsRefs = false, dashboardsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (metricsRefs) db.metrics,
                    if (dashboardsRefs) db.dashboards,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (metricsRefs)
                        await $_getPrefetchedData<
                          Broker,
                          $BrokersTable,
                          Metric
                        >(
                          currentTable: table,
                          referencedTable: $$BrokersTableReferences
                              ._metricsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrokersTableReferences(
                                db,
                                table,
                                p0,
                              ).metricsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.brokerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dashboardsRefs)
                        await $_getPrefetchedData<
                          Broker,
                          $BrokersTable,
                          Dashboard
                        >(
                          currentTable: table,
                          referencedTable: $$BrokersTableReferences
                              ._dashboardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrokersTableReferences(
                                db,
                                table,
                                p0,
                              ).dashboardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.brokerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BrokersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrokersTable,
      Broker,
      $$BrokersTableFilterComposer,
      $$BrokersTableOrderingComposer,
      $$BrokersTableAnnotationComposer,
      $$BrokersTableCreateCompanionBuilder,
      $$BrokersTableUpdateCompanionBuilder,
      (Broker, $$BrokersTableReferences),
      Broker,
      PrefetchHooks Function({bool metricsRefs, bool dashboardsRefs})
    >;
typedef $$MetricsTableCreateCompanionBuilder =
    MetricsCompanion Function({
      Value<int> id,
      required int brokerId,
      required String name,
      required String topic,
      Value<bool> publishEnabled,
      Value<double?> minValue,
      Value<double?> maxValue,
    });
typedef $$MetricsTableUpdateCompanionBuilder =
    MetricsCompanion Function({
      Value<int> id,
      Value<int> brokerId,
      Value<String> name,
      Value<String> topic,
      Value<bool> publishEnabled,
      Value<double?> minValue,
      Value<double?> maxValue,
    });

final class $$MetricsTableReferences
    extends BaseReferences<_$AppDatabase, $MetricsTable, Metric> {
  $$MetricsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BrokersTable _brokerIdTable(_$AppDatabase db) => db.brokers
      .createAlias($_aliasNameGenerator(db.metrics.brokerId, db.brokers.id));

  $$BrokersTableProcessedTableManager get brokerId {
    final $_column = $_itemColumn<int>('broker_id')!;

    final manager = $$BrokersTableTableManager(
      $_db,
      $_db.brokers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brokerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChartsTable, List<ChartConfig>> _chartsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.charts,
    aliasName: $_aliasNameGenerator(db.metrics.id, db.charts.metricId),
  );

  $$ChartsTableProcessedTableManager get chartsRefs {
    final manager = $$ChartsTableTableManager(
      $_db,
      $_db.charts,
    ).filter((f) => f.metricId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: $_aliasNameGenerator(db.metrics.id, db.readings.metricId),
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.metricId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MetricsTableFilterComposer
    extends Composer<_$AppDatabase, $MetricsTable> {
  $$MetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get publishEnabled => $composableBuilder(
    column: $table.publishEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minValue => $composableBuilder(
    column: $table.minValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxValue => $composableBuilder(
    column: $table.maxValue,
    builder: (column) => ColumnFilters(column),
  );

  $$BrokersTableFilterComposer get brokerId {
    final $$BrokersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brokerId,
      referencedTable: $db.brokers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrokersTableFilterComposer(
            $db: $db,
            $table: $db.brokers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> chartsRefs(
    Expression<bool> Function($$ChartsTableFilterComposer f) f,
  ) {
    final $$ChartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.metricId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableFilterComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.metricId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $MetricsTable> {
  $$MetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get publishEnabled => $composableBuilder(
    column: $table.publishEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minValue => $composableBuilder(
    column: $table.minValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxValue => $composableBuilder(
    column: $table.maxValue,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrokersTableOrderingComposer get brokerId {
    final $$BrokersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brokerId,
      referencedTable: $db.brokers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrokersTableOrderingComposer(
            $db: $db,
            $table: $db.brokers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetricsTable> {
  $$MetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<bool> get publishEnabled => $composableBuilder(
    column: $table.publishEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minValue =>
      $composableBuilder(column: $table.minValue, builder: (column) => column);

  GeneratedColumn<double> get maxValue =>
      $composableBuilder(column: $table.maxValue, builder: (column) => column);

  $$BrokersTableAnnotationComposer get brokerId {
    final $$BrokersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brokerId,
      referencedTable: $db.brokers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrokersTableAnnotationComposer(
            $db: $db,
            $table: $db.brokers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> chartsRefs<T extends Object>(
    Expression<T> Function($$ChartsTableAnnotationComposer a) f,
  ) {
    final $$ChartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.metricId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableAnnotationComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.metricId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetricsTable,
          Metric,
          $$MetricsTableFilterComposer,
          $$MetricsTableOrderingComposer,
          $$MetricsTableAnnotationComposer,
          $$MetricsTableCreateCompanionBuilder,
          $$MetricsTableUpdateCompanionBuilder,
          (Metric, $$MetricsTableReferences),
          Metric,
          PrefetchHooks Function({
            bool brokerId,
            bool chartsRefs,
            bool readingsRefs,
          })
        > {
  $$MetricsTableTableManager(_$AppDatabase db, $MetricsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> brokerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<bool> publishEnabled = const Value.absent(),
                Value<double?> minValue = const Value.absent(),
                Value<double?> maxValue = const Value.absent(),
              }) => MetricsCompanion(
                id: id,
                brokerId: brokerId,
                name: name,
                topic: topic,
                publishEnabled: publishEnabled,
                minValue: minValue,
                maxValue: maxValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int brokerId,
                required String name,
                required String topic,
                Value<bool> publishEnabled = const Value.absent(),
                Value<double?> minValue = const Value.absent(),
                Value<double?> maxValue = const Value.absent(),
              }) => MetricsCompanion.insert(
                id: id,
                brokerId: brokerId,
                name: name,
                topic: topic,
                publishEnabled: publishEnabled,
                minValue: minValue,
                maxValue: maxValue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MetricsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({brokerId = false, chartsRefs = false, readingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chartsRefs) db.charts,
                    if (readingsRefs) db.readings,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (brokerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.brokerId,
                                    referencedTable: $$MetricsTableReferences
                                        ._brokerIdTable(db),
                                    referencedColumn: $$MetricsTableReferences
                                        ._brokerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chartsRefs)
                        await $_getPrefetchedData<
                          Metric,
                          $MetricsTable,
                          ChartConfig
                        >(
                          currentTable: table,
                          referencedTable: $$MetricsTableReferences
                              ._chartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MetricsTableReferences(
                                db,
                                table,
                                p0,
                              ).chartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.metricId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingsRefs)
                        await $_getPrefetchedData<
                          Metric,
                          $MetricsTable,
                          Reading
                        >(
                          currentTable: table,
                          referencedTable: $$MetricsTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MetricsTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.metricId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetricsTable,
      Metric,
      $$MetricsTableFilterComposer,
      $$MetricsTableOrderingComposer,
      $$MetricsTableAnnotationComposer,
      $$MetricsTableCreateCompanionBuilder,
      $$MetricsTableUpdateCompanionBuilder,
      (Metric, $$MetricsTableReferences),
      Metric,
      PrefetchHooks Function({
        bool brokerId,
        bool chartsRefs,
        bool readingsRefs,
      })
    >;
typedef $$DashboardsTableCreateCompanionBuilder =
    DashboardsCompanion Function({
      Value<int> id,
      required int brokerId,
      required String name,
    });
typedef $$DashboardsTableUpdateCompanionBuilder =
    DashboardsCompanion Function({
      Value<int> id,
      Value<int> brokerId,
      Value<String> name,
    });

final class $$DashboardsTableReferences
    extends BaseReferences<_$AppDatabase, $DashboardsTable, Dashboard> {
  $$DashboardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BrokersTable _brokerIdTable(_$AppDatabase db) => db.brokers
      .createAlias($_aliasNameGenerator(db.dashboards.brokerId, db.brokers.id));

  $$BrokersTableProcessedTableManager get brokerId {
    final $_column = $_itemColumn<int>('broker_id')!;

    final manager = $$BrokersTableTableManager(
      $_db,
      $_db.brokers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brokerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChartsTable, List<ChartConfig>> _chartsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.charts,
    aliasName: $_aliasNameGenerator(db.dashboards.id, db.charts.dashboardId),
  );

  $$ChartsTableProcessedTableManager get chartsRefs {
    final manager = $$ChartsTableTableManager(
      $_db,
      $_db.charts,
    ).filter((f) => f.dashboardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DashboardsTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardsTable> {
  $$DashboardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$BrokersTableFilterComposer get brokerId {
    final $$BrokersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brokerId,
      referencedTable: $db.brokers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrokersTableFilterComposer(
            $db: $db,
            $table: $db.brokers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> chartsRefs(
    Expression<bool> Function($$ChartsTableFilterComposer f) f,
  ) {
    final $$ChartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.dashboardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableFilterComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DashboardsTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardsTable> {
  $$DashboardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrokersTableOrderingComposer get brokerId {
    final $$BrokersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brokerId,
      referencedTable: $db.brokers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrokersTableOrderingComposer(
            $db: $db,
            $table: $db.brokers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DashboardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardsTable> {
  $$DashboardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$BrokersTableAnnotationComposer get brokerId {
    final $$BrokersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brokerId,
      referencedTable: $db.brokers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrokersTableAnnotationComposer(
            $db: $db,
            $table: $db.brokers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> chartsRefs<T extends Object>(
    Expression<T> Function($$ChartsTableAnnotationComposer a) f,
  ) {
    final $$ChartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.dashboardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableAnnotationComposer(
            $db: $db,
            $table: $db.charts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DashboardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardsTable,
          Dashboard,
          $$DashboardsTableFilterComposer,
          $$DashboardsTableOrderingComposer,
          $$DashboardsTableAnnotationComposer,
          $$DashboardsTableCreateCompanionBuilder,
          $$DashboardsTableUpdateCompanionBuilder,
          (Dashboard, $$DashboardsTableReferences),
          Dashboard,
          PrefetchHooks Function({bool brokerId, bool chartsRefs})
        > {
  $$DashboardsTableTableManager(_$AppDatabase db, $DashboardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DashboardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DashboardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> brokerId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => DashboardsCompanion(id: id, brokerId: brokerId, name: name),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int brokerId,
                required String name,
              }) => DashboardsCompanion.insert(
                id: id,
                brokerId: brokerId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DashboardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({brokerId = false, chartsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chartsRefs) db.charts],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (brokerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.brokerId,
                                referencedTable: $$DashboardsTableReferences
                                    ._brokerIdTable(db),
                                referencedColumn: $$DashboardsTableReferences
                                    ._brokerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chartsRefs)
                    await $_getPrefetchedData<
                      Dashboard,
                      $DashboardsTable,
                      ChartConfig
                    >(
                      currentTable: table,
                      referencedTable: $$DashboardsTableReferences
                          ._chartsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DashboardsTableReferences(db, table, p0).chartsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.dashboardId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DashboardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardsTable,
      Dashboard,
      $$DashboardsTableFilterComposer,
      $$DashboardsTableOrderingComposer,
      $$DashboardsTableAnnotationComposer,
      $$DashboardsTableCreateCompanionBuilder,
      $$DashboardsTableUpdateCompanionBuilder,
      (Dashboard, $$DashboardsTableReferences),
      Dashboard,
      PrefetchHooks Function({bool brokerId, bool chartsRefs})
    >;
typedef $$ChartsTableCreateCompanionBuilder =
    ChartsCompanion Function({
      Value<int> id,
      required int dashboardId,
      required int metricId,
      required ChartType type,
      Value<String?> title,
    });
typedef $$ChartsTableUpdateCompanionBuilder =
    ChartsCompanion Function({
      Value<int> id,
      Value<int> dashboardId,
      Value<int> metricId,
      Value<ChartType> type,
      Value<String?> title,
    });

final class $$ChartsTableReferences
    extends BaseReferences<_$AppDatabase, $ChartsTable, ChartConfig> {
  $$ChartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DashboardsTable _dashboardIdTable(_$AppDatabase db) =>
      db.dashboards.createAlias(
        $_aliasNameGenerator(db.charts.dashboardId, db.dashboards.id),
      );

  $$DashboardsTableProcessedTableManager get dashboardId {
    final $_column = $_itemColumn<int>('dashboard_id')!;

    final manager = $$DashboardsTableTableManager(
      $_db,
      $_db.dashboards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dashboardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MetricsTable _metricIdTable(_$AppDatabase db) => db.metrics
      .createAlias($_aliasNameGenerator(db.charts.metricId, db.metrics.id));

  $$MetricsTableProcessedTableManager get metricId {
    final $_column = $_itemColumn<int>('metric_id')!;

    final manager = $$MetricsTableTableManager(
      $_db,
      $_db.metrics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_metricIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChartsTableFilterComposer
    extends Composer<_$AppDatabase, $ChartsTable> {
  $$ChartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ChartType, ChartType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  $$DashboardsTableFilterComposer get dashboardId {
    final $$DashboardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dashboardId,
      referencedTable: $db.dashboards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashboardsTableFilterComposer(
            $db: $db,
            $table: $db.dashboards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MetricsTableFilterComposer get metricId {
    final $$MetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricId,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableFilterComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartsTable> {
  $$ChartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  $$DashboardsTableOrderingComposer get dashboardId {
    final $$DashboardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dashboardId,
      referencedTable: $db.dashboards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashboardsTableOrderingComposer(
            $db: $db,
            $table: $db.dashboards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MetricsTableOrderingComposer get metricId {
    final $$MetricsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricId,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableOrderingComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartsTable> {
  $$ChartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ChartType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  $$DashboardsTableAnnotationComposer get dashboardId {
    final $$DashboardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dashboardId,
      referencedTable: $db.dashboards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashboardsTableAnnotationComposer(
            $db: $db,
            $table: $db.dashboards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MetricsTableAnnotationComposer get metricId {
    final $$MetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricId,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartsTable,
          ChartConfig,
          $$ChartsTableFilterComposer,
          $$ChartsTableOrderingComposer,
          $$ChartsTableAnnotationComposer,
          $$ChartsTableCreateCompanionBuilder,
          $$ChartsTableUpdateCompanionBuilder,
          (ChartConfig, $$ChartsTableReferences),
          ChartConfig,
          PrefetchHooks Function({bool dashboardId, bool metricId})
        > {
  $$ChartsTableTableManager(_$AppDatabase db, $ChartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dashboardId = const Value.absent(),
                Value<int> metricId = const Value.absent(),
                Value<ChartType> type = const Value.absent(),
                Value<String?> title = const Value.absent(),
              }) => ChartsCompanion(
                id: id,
                dashboardId: dashboardId,
                metricId: metricId,
                type: type,
                title: title,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dashboardId,
                required int metricId,
                required ChartType type,
                Value<String?> title = const Value.absent(),
              }) => ChartsCompanion.insert(
                id: id,
                dashboardId: dashboardId,
                metricId: metricId,
                type: type,
                title: title,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ChartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({dashboardId = false, metricId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dashboardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dashboardId,
                                referencedTable: $$ChartsTableReferences
                                    ._dashboardIdTable(db),
                                referencedColumn: $$ChartsTableReferences
                                    ._dashboardIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (metricId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.metricId,
                                referencedTable: $$ChartsTableReferences
                                    ._metricIdTable(db),
                                referencedColumn: $$ChartsTableReferences
                                    ._metricIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartsTable,
      ChartConfig,
      $$ChartsTableFilterComposer,
      $$ChartsTableOrderingComposer,
      $$ChartsTableAnnotationComposer,
      $$ChartsTableCreateCompanionBuilder,
      $$ChartsTableUpdateCompanionBuilder,
      (ChartConfig, $$ChartsTableReferences),
      ChartConfig,
      PrefetchHooks Function({bool dashboardId, bool metricId})
    >;
typedef $$ReadingsTableCreateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      required int metricId,
      required double value,
      required DateTime timestamp,
    });
typedef $$ReadingsTableUpdateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      Value<int> metricId,
      Value<double> value,
      Value<DateTime> timestamp,
    });

final class $$ReadingsTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingsTable, Reading> {
  $$ReadingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MetricsTable _metricIdTable(_$AppDatabase db) => db.metrics
      .createAlias($_aliasNameGenerator(db.readings.metricId, db.metrics.id));

  $$MetricsTableProcessedTableManager get metricId {
    final $_column = $_itemColumn<int>('metric_id')!;

    final manager = $$MetricsTableTableManager(
      $_db,
      $_db.metrics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_metricIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$MetricsTableFilterComposer get metricId {
    final $$MetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricId,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableFilterComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$MetricsTableOrderingComposer get metricId {
    final $$MetricsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricId,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableOrderingComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$MetricsTableAnnotationComposer get metricId {
    final $$MetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.metricId,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.metrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingsTable,
          Reading,
          $$ReadingsTableFilterComposer,
          $$ReadingsTableOrderingComposer,
          $$ReadingsTableAnnotationComposer,
          $$ReadingsTableCreateCompanionBuilder,
          $$ReadingsTableUpdateCompanionBuilder,
          (Reading, $$ReadingsTableReferences),
          Reading,
          PrefetchHooks Function({bool metricId})
        > {
  $$ReadingsTableTableManager(_$AppDatabase db, $ReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> metricId = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                metricId: metricId,
                value: value,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int metricId,
                required double value,
                required DateTime timestamp,
              }) => ReadingsCompanion.insert(
                id: id,
                metricId: metricId,
                value: value,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({metricId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (metricId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.metricId,
                                referencedTable: $$ReadingsTableReferences
                                    ._metricIdTable(db),
                                referencedColumn: $$ReadingsTableReferences
                                    ._metricIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingsTable,
      Reading,
      $$ReadingsTableFilterComposer,
      $$ReadingsTableOrderingComposer,
      $$ReadingsTableAnnotationComposer,
      $$ReadingsTableCreateCompanionBuilder,
      $$ReadingsTableUpdateCompanionBuilder,
      (Reading, $$ReadingsTableReferences),
      Reading,
      PrefetchHooks Function({bool metricId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BrokersTableTableManager get brokers =>
      $$BrokersTableTableManager(_db, _db.brokers);
  $$MetricsTableTableManager get metrics =>
      $$MetricsTableTableManager(_db, _db.metrics);
  $$DashboardsTableTableManager get dashboards =>
      $$DashboardsTableTableManager(_db, _db.dashboards);
  $$ChartsTableTableManager get charts =>
      $$ChartsTableTableManager(_db, _db.charts);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
}
