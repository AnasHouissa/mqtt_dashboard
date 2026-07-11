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
  static const VerificationMeta _secureMeta = const VerificationMeta('secure');
  @override
  late final GeneratedColumn<bool> secure = GeneratedColumn<bool>(
    'secure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("secure" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _keepAliveMeta = const VerificationMeta(
    'keepAlive',
  );
  @override
  late final GeneratedColumn<int> keepAlive = GeneratedColumn<int>(
    'keep_alive',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _connectTimeoutMeta = const VerificationMeta(
    'connectTimeout',
  );
  @override
  late final GeneratedColumn<int> connectTimeout = GeneratedColumn<int>(
    'connect_timeout',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _qosMeta = const VerificationMeta('qos');
  @override
  late final GeneratedColumn<int> qos = GeneratedColumn<int>(
    'qos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _retainMeta = const VerificationMeta('retain');
  @override
  late final GeneratedColumn<bool> retain = GeneratedColumn<bool>(
    'retain',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("retain" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    secure,
    keepAlive,
    connectTimeout,
    qos,
    retain,
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
    if (data.containsKey('secure')) {
      context.handle(
        _secureMeta,
        secure.isAcceptableOrUnknown(data['secure']!, _secureMeta),
      );
    }
    if (data.containsKey('keep_alive')) {
      context.handle(
        _keepAliveMeta,
        keepAlive.isAcceptableOrUnknown(data['keep_alive']!, _keepAliveMeta),
      );
    }
    if (data.containsKey('connect_timeout')) {
      context.handle(
        _connectTimeoutMeta,
        connectTimeout.isAcceptableOrUnknown(
          data['connect_timeout']!,
          _connectTimeoutMeta,
        ),
      );
    }
    if (data.containsKey('qos')) {
      context.handle(
        _qosMeta,
        qos.isAcceptableOrUnknown(data['qos']!, _qosMeta),
      );
    }
    if (data.containsKey('retain')) {
      context.handle(
        _retainMeta,
        retain.isAcceptableOrUnknown(data['retain']!, _retainMeta),
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
      secure: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}secure'],
      )!,
      keepAlive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}keep_alive'],
      )!,
      connectTimeout: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}connect_timeout'],
      )!,
      qos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qos'],
      )!,
      retain: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}retain'],
      )!,
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

  /// Connect over TLS (defaults the port to 8883 in the UI).
  final bool secure;

  /// MQTT keep-alive ping interval, in seconds.
  final int keepAlive;

  /// Connection handshake timeout, in seconds.
  final int connectTimeout;

  /// Default QoS (0/1/2) applied to subscribes and publishes for this broker.
  final int qos;

  /// Whether published messages set the broker's retain flag.
  final bool retain;
  final DateTime createdAt;
  const Broker({
    required this.id,
    required this.name,
    required this.address,
    required this.port,
    this.username,
    this.password,
    required this.secure,
    required this.keepAlive,
    required this.connectTimeout,
    required this.qos,
    required this.retain,
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
    map['secure'] = Variable<bool>(secure);
    map['keep_alive'] = Variable<int>(keepAlive);
    map['connect_timeout'] = Variable<int>(connectTimeout);
    map['qos'] = Variable<int>(qos);
    map['retain'] = Variable<bool>(retain);
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
      secure: Value(secure),
      keepAlive: Value(keepAlive),
      connectTimeout: Value(connectTimeout),
      qos: Value(qos),
      retain: Value(retain),
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
      secure: serializer.fromJson<bool>(json['secure']),
      keepAlive: serializer.fromJson<int>(json['keepAlive']),
      connectTimeout: serializer.fromJson<int>(json['connectTimeout']),
      qos: serializer.fromJson<int>(json['qos']),
      retain: serializer.fromJson<bool>(json['retain']),
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
      'secure': serializer.toJson<bool>(secure),
      'keepAlive': serializer.toJson<int>(keepAlive),
      'connectTimeout': serializer.toJson<int>(connectTimeout),
      'qos': serializer.toJson<int>(qos),
      'retain': serializer.toJson<bool>(retain),
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
    bool? secure,
    int? keepAlive,
    int? connectTimeout,
    int? qos,
    bool? retain,
    DateTime? createdAt,
  }) => Broker(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    port: port ?? this.port,
    username: username.present ? username.value : this.username,
    password: password.present ? password.value : this.password,
    secure: secure ?? this.secure,
    keepAlive: keepAlive ?? this.keepAlive,
    connectTimeout: connectTimeout ?? this.connectTimeout,
    qos: qos ?? this.qos,
    retain: retain ?? this.retain,
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
      secure: data.secure.present ? data.secure.value : this.secure,
      keepAlive: data.keepAlive.present ? data.keepAlive.value : this.keepAlive,
      connectTimeout: data.connectTimeout.present
          ? data.connectTimeout.value
          : this.connectTimeout,
      qos: data.qos.present ? data.qos.value : this.qos,
      retain: data.retain.present ? data.retain.value : this.retain,
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
          ..write('secure: $secure, ')
          ..write('keepAlive: $keepAlive, ')
          ..write('connectTimeout: $connectTimeout, ')
          ..write('qos: $qos, ')
          ..write('retain: $retain, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    port,
    username,
    password,
    secure,
    keepAlive,
    connectTimeout,
    qos,
    retain,
    createdAt,
  );
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
          other.secure == this.secure &&
          other.keepAlive == this.keepAlive &&
          other.connectTimeout == this.connectTimeout &&
          other.qos == this.qos &&
          other.retain == this.retain &&
          other.createdAt == this.createdAt);
}

class BrokersCompanion extends UpdateCompanion<Broker> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> address;
  final Value<int> port;
  final Value<String?> username;
  final Value<String?> password;
  final Value<bool> secure;
  final Value<int> keepAlive;
  final Value<int> connectTimeout;
  final Value<int> qos;
  final Value<bool> retain;
  final Value<DateTime> createdAt;
  const BrokersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.secure = const Value.absent(),
    this.keepAlive = const Value.absent(),
    this.connectTimeout = const Value.absent(),
    this.qos = const Value.absent(),
    this.retain = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BrokersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String address,
    required int port,
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.secure = const Value.absent(),
    this.keepAlive = const Value.absent(),
    this.connectTimeout = const Value.absent(),
    this.qos = const Value.absent(),
    this.retain = const Value.absent(),
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
    Expression<bool>? secure,
    Expression<int>? keepAlive,
    Expression<int>? connectTimeout,
    Expression<int>? qos,
    Expression<bool>? retain,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (secure != null) 'secure': secure,
      if (keepAlive != null) 'keep_alive': keepAlive,
      if (connectTimeout != null) 'connect_timeout': connectTimeout,
      if (qos != null) 'qos': qos,
      if (retain != null) 'retain': retain,
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
    Value<bool>? secure,
    Value<int>? keepAlive,
    Value<int>? connectTimeout,
    Value<int>? qos,
    Value<bool>? retain,
    Value<DateTime>? createdAt,
  }) {
    return BrokersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      secure: secure ?? this.secure,
      keepAlive: keepAlive ?? this.keepAlive,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      qos: qos ?? this.qos,
      retain: retain ?? this.retain,
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
    if (secure.present) {
      map['secure'] = Variable<bool>(secure.value);
    }
    if (keepAlive.present) {
      map['keep_alive'] = Variable<int>(keepAlive.value);
    }
    if (connectTimeout.present) {
      map['connect_timeout'] = Variable<int>(connectTimeout.value);
    }
    if (qos.present) {
      map['qos'] = Variable<int>(qos.value);
    }
    if (retain.present) {
      map['retain'] = Variable<bool>(retain.value);
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
          ..write('secure: $secure, ')
          ..write('keepAlive: $keepAlive, ')
          ..write('connectTimeout: $connectTimeout, ')
          ..write('qos: $qos, ')
          ..write('retain: $retain, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SmsSourcesTable extends SmsSources
    with TableInfo<$SmsSourcesTable, SmsSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsSourcesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, name, phoneNumber, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsSource> instance, {
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
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
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
  SmsSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SmsSourcesTable createAlias(String alias) {
    return $SmsSourcesTable(attachedDatabase, alias);
  }
}

class SmsSource extends DataClass implements Insertable<SmsSource> {
  final int id;
  final String name;
  final String phoneNumber;
  final DateTime createdAt;
  const SmsSource({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SmsSourcesCompanion toCompanion(bool nullToAbsent) {
    return SmsSourcesCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      createdAt: Value(createdAt),
    );
  }

  factory SmsSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsSource(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SmsSource copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
  }) => SmsSource(
    id: id ?? this.id,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    createdAt: createdAt ?? this.createdAt,
  );
  SmsSource copyWithCompanion(SmsSourcesCompanion data) {
    return SmsSource(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsSource(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phoneNumber, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsSource &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.createdAt == this.createdAt);
}

class SmsSourcesCompanion extends UpdateCompanion<SmsSource> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<DateTime> createdAt;
  const SmsSourcesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SmsSourcesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phoneNumber,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       phoneNumber = Value(phoneNumber);
  static Insertable<SmsSource> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SmsSourcesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phoneNumber,
    Value<DateTime>? createdAt,
  }) {
    return SmsSourcesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsSourcesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
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
  @override
  late final GeneratedColumnWithTypeConverter<MetricSourceKind, int>
  sourceKind = GeneratedColumn<int>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  ).withConverter<MetricSourceKind>($MetricsTable.$convertersourceKind);
  static const VerificationMeta _brokerIdMeta = const VerificationMeta(
    'brokerId',
  );
  @override
  late final GeneratedColumn<int> brokerId = GeneratedColumn<int>(
    'broker_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brokers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _smsSourceIdMeta = const VerificationMeta(
    'smsSourceId',
  );
  @override
  late final GeneratedColumn<int> smsSourceId = GeneratedColumn<int>(
    'sms_source_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sms_sources (id) ON DELETE CASCADE',
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
  static const VerificationMeta _useFixedRangeMeta = const VerificationMeta(
    'useFixedRange',
  );
  @override
  late final GeneratedColumn<bool> useFixedRange = GeneratedColumn<bool>(
    'use_fixed_range',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_fixed_range" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SmsValueMode?, int> smsValueMode =
      GeneratedColumn<int>(
        'sms_value_mode',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<SmsValueMode?>($MetricsTable.$convertersmsValueModen);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceKind,
    brokerId,
    smsSourceId,
    name,
    topic,
    publishEnabled,
    minValue,
    maxValue,
    useFixedRange,
    smsValueMode,
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
    }
    if (data.containsKey('sms_source_id')) {
      context.handle(
        _smsSourceIdMeta,
        smsSourceId.isAcceptableOrUnknown(
          data['sms_source_id']!,
          _smsSourceIdMeta,
        ),
      );
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
    if (data.containsKey('use_fixed_range')) {
      context.handle(
        _useFixedRangeMeta,
        useFixedRange.isAcceptableOrUnknown(
          data['use_fixed_range']!,
          _useFixedRangeMeta,
        ),
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
      sourceKind: $MetricsTable.$convertersourceKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source_kind'],
        )!,
      ),
      brokerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}broker_id'],
      ),
      smsSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sms_source_id'],
      ),
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
      useFixedRange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_fixed_range'],
      )!,
      smsValueMode: $MetricsTable.$convertersmsValueModen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}sms_value_mode'],
        ),
      ),
    );
  }

  @override
  $MetricsTable createAlias(String alias) {
    return $MetricsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MetricSourceKind, int, int> $convertersourceKind =
      const EnumIndexConverter<MetricSourceKind>(MetricSourceKind.values);
  static JsonTypeConverter2<SmsValueMode, int, int> $convertersmsValueMode =
      const EnumIndexConverter<SmsValueMode>(SmsValueMode.values);
  static JsonTypeConverter2<SmsValueMode?, int?, int?> $convertersmsValueModen =
      JsonTypeConverter2.asNullable($convertersmsValueMode);
}

class Metric extends DataClass implements Insertable<Metric> {
  final int id;

  /// Which kind of data source feeds this metric. Defaults to `mqtt` (index 0)
  /// so pre-existing broker metrics keep working after migration.
  final MetricSourceKind sourceKind;

  /// Owning broker when [sourceKind] is mqtt; null for SMS metrics.
  final int? brokerId;

  /// Owning SMS source when [sourceKind] is sms; null for broker metrics.
  final int? smsSourceId;

  /// For MQTT this is the display name; for SMS it is the station NAME line we
  /// match against (the first line of the message body).
  final String name;

  /// For MQTT this is the subscription topic; for SMS it is the TOPIC label we
  /// match against (the text before the trailing `[ value ]`).
  final String topic;
  final bool publishEnabled;
  final double? minValue;
  final double? maxValue;

  /// When true, charts use [minValue]/[maxValue] as fixed Y-axis bounds.
  /// When false, the axis auto-scales to the received readings.
  final bool useFixedRange;

  /// How to convert an SMS bracket value to a number; null for MQTT metrics.
  final SmsValueMode? smsValueMode;
  const Metric({
    required this.id,
    required this.sourceKind,
    this.brokerId,
    this.smsSourceId,
    required this.name,
    required this.topic,
    required this.publishEnabled,
    this.minValue,
    this.maxValue,
    required this.useFixedRange,
    this.smsValueMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['source_kind'] = Variable<int>(
        $MetricsTable.$convertersourceKind.toSql(sourceKind),
      );
    }
    if (!nullToAbsent || brokerId != null) {
      map['broker_id'] = Variable<int>(brokerId);
    }
    if (!nullToAbsent || smsSourceId != null) {
      map['sms_source_id'] = Variable<int>(smsSourceId);
    }
    map['name'] = Variable<String>(name);
    map['topic'] = Variable<String>(topic);
    map['publish_enabled'] = Variable<bool>(publishEnabled);
    if (!nullToAbsent || minValue != null) {
      map['min_value'] = Variable<double>(minValue);
    }
    if (!nullToAbsent || maxValue != null) {
      map['max_value'] = Variable<double>(maxValue);
    }
    map['use_fixed_range'] = Variable<bool>(useFixedRange);
    if (!nullToAbsent || smsValueMode != null) {
      map['sms_value_mode'] = Variable<int>(
        $MetricsTable.$convertersmsValueModen.toSql(smsValueMode),
      );
    }
    return map;
  }

  MetricsCompanion toCompanion(bool nullToAbsent) {
    return MetricsCompanion(
      id: Value(id),
      sourceKind: Value(sourceKind),
      brokerId: brokerId == null && nullToAbsent
          ? const Value.absent()
          : Value(brokerId),
      smsSourceId: smsSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(smsSourceId),
      name: Value(name),
      topic: Value(topic),
      publishEnabled: Value(publishEnabled),
      minValue: minValue == null && nullToAbsent
          ? const Value.absent()
          : Value(minValue),
      maxValue: maxValue == null && nullToAbsent
          ? const Value.absent()
          : Value(maxValue),
      useFixedRange: Value(useFixedRange),
      smsValueMode: smsValueMode == null && nullToAbsent
          ? const Value.absent()
          : Value(smsValueMode),
    );
  }

  factory Metric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Metric(
      id: serializer.fromJson<int>(json['id']),
      sourceKind: $MetricsTable.$convertersourceKind.fromJson(
        serializer.fromJson<int>(json['sourceKind']),
      ),
      brokerId: serializer.fromJson<int?>(json['brokerId']),
      smsSourceId: serializer.fromJson<int?>(json['smsSourceId']),
      name: serializer.fromJson<String>(json['name']),
      topic: serializer.fromJson<String>(json['topic']),
      publishEnabled: serializer.fromJson<bool>(json['publishEnabled']),
      minValue: serializer.fromJson<double?>(json['minValue']),
      maxValue: serializer.fromJson<double?>(json['maxValue']),
      useFixedRange: serializer.fromJson<bool>(json['useFixedRange']),
      smsValueMode: $MetricsTable.$convertersmsValueModen.fromJson(
        serializer.fromJson<int?>(json['smsValueMode']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceKind': serializer.toJson<int>(
        $MetricsTable.$convertersourceKind.toJson(sourceKind),
      ),
      'brokerId': serializer.toJson<int?>(brokerId),
      'smsSourceId': serializer.toJson<int?>(smsSourceId),
      'name': serializer.toJson<String>(name),
      'topic': serializer.toJson<String>(topic),
      'publishEnabled': serializer.toJson<bool>(publishEnabled),
      'minValue': serializer.toJson<double?>(minValue),
      'maxValue': serializer.toJson<double?>(maxValue),
      'useFixedRange': serializer.toJson<bool>(useFixedRange),
      'smsValueMode': serializer.toJson<int?>(
        $MetricsTable.$convertersmsValueModen.toJson(smsValueMode),
      ),
    };
  }

  Metric copyWith({
    int? id,
    MetricSourceKind? sourceKind,
    Value<int?> brokerId = const Value.absent(),
    Value<int?> smsSourceId = const Value.absent(),
    String? name,
    String? topic,
    bool? publishEnabled,
    Value<double?> minValue = const Value.absent(),
    Value<double?> maxValue = const Value.absent(),
    bool? useFixedRange,
    Value<SmsValueMode?> smsValueMode = const Value.absent(),
  }) => Metric(
    id: id ?? this.id,
    sourceKind: sourceKind ?? this.sourceKind,
    brokerId: brokerId.present ? brokerId.value : this.brokerId,
    smsSourceId: smsSourceId.present ? smsSourceId.value : this.smsSourceId,
    name: name ?? this.name,
    topic: topic ?? this.topic,
    publishEnabled: publishEnabled ?? this.publishEnabled,
    minValue: minValue.present ? minValue.value : this.minValue,
    maxValue: maxValue.present ? maxValue.value : this.maxValue,
    useFixedRange: useFixedRange ?? this.useFixedRange,
    smsValueMode: smsValueMode.present ? smsValueMode.value : this.smsValueMode,
  );
  Metric copyWithCompanion(MetricsCompanion data) {
    return Metric(
      id: data.id.present ? data.id.value : this.id,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      brokerId: data.brokerId.present ? data.brokerId.value : this.brokerId,
      smsSourceId: data.smsSourceId.present
          ? data.smsSourceId.value
          : this.smsSourceId,
      name: data.name.present ? data.name.value : this.name,
      topic: data.topic.present ? data.topic.value : this.topic,
      publishEnabled: data.publishEnabled.present
          ? data.publishEnabled.value
          : this.publishEnabled,
      minValue: data.minValue.present ? data.minValue.value : this.minValue,
      maxValue: data.maxValue.present ? data.maxValue.value : this.maxValue,
      useFixedRange: data.useFixedRange.present
          ? data.useFixedRange.value
          : this.useFixedRange,
      smsValueMode: data.smsValueMode.present
          ? data.smsValueMode.value
          : this.smsValueMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Metric(')
          ..write('id: $id, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('brokerId: $brokerId, ')
          ..write('smsSourceId: $smsSourceId, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('publishEnabled: $publishEnabled, ')
          ..write('minValue: $minValue, ')
          ..write('maxValue: $maxValue, ')
          ..write('useFixedRange: $useFixedRange, ')
          ..write('smsValueMode: $smsValueMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceKind,
    brokerId,
    smsSourceId,
    name,
    topic,
    publishEnabled,
    minValue,
    maxValue,
    useFixedRange,
    smsValueMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Metric &&
          other.id == this.id &&
          other.sourceKind == this.sourceKind &&
          other.brokerId == this.brokerId &&
          other.smsSourceId == this.smsSourceId &&
          other.name == this.name &&
          other.topic == this.topic &&
          other.publishEnabled == this.publishEnabled &&
          other.minValue == this.minValue &&
          other.maxValue == this.maxValue &&
          other.useFixedRange == this.useFixedRange &&
          other.smsValueMode == this.smsValueMode);
}

class MetricsCompanion extends UpdateCompanion<Metric> {
  final Value<int> id;
  final Value<MetricSourceKind> sourceKind;
  final Value<int?> brokerId;
  final Value<int?> smsSourceId;
  final Value<String> name;
  final Value<String> topic;
  final Value<bool> publishEnabled;
  final Value<double?> minValue;
  final Value<double?> maxValue;
  final Value<bool> useFixedRange;
  final Value<SmsValueMode?> smsValueMode;
  const MetricsCompanion({
    this.id = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.brokerId = const Value.absent(),
    this.smsSourceId = const Value.absent(),
    this.name = const Value.absent(),
    this.topic = const Value.absent(),
    this.publishEnabled = const Value.absent(),
    this.minValue = const Value.absent(),
    this.maxValue = const Value.absent(),
    this.useFixedRange = const Value.absent(),
    this.smsValueMode = const Value.absent(),
  });
  MetricsCompanion.insert({
    this.id = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.brokerId = const Value.absent(),
    this.smsSourceId = const Value.absent(),
    required String name,
    required String topic,
    this.publishEnabled = const Value.absent(),
    this.minValue = const Value.absent(),
    this.maxValue = const Value.absent(),
    this.useFixedRange = const Value.absent(),
    this.smsValueMode = const Value.absent(),
  }) : name = Value(name),
       topic = Value(topic);
  static Insertable<Metric> custom({
    Expression<int>? id,
    Expression<int>? sourceKind,
    Expression<int>? brokerId,
    Expression<int>? smsSourceId,
    Expression<String>? name,
    Expression<String>? topic,
    Expression<bool>? publishEnabled,
    Expression<double>? minValue,
    Expression<double>? maxValue,
    Expression<bool>? useFixedRange,
    Expression<int>? smsValueMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (brokerId != null) 'broker_id': brokerId,
      if (smsSourceId != null) 'sms_source_id': smsSourceId,
      if (name != null) 'name': name,
      if (topic != null) 'topic': topic,
      if (publishEnabled != null) 'publish_enabled': publishEnabled,
      if (minValue != null) 'min_value': minValue,
      if (maxValue != null) 'max_value': maxValue,
      if (useFixedRange != null) 'use_fixed_range': useFixedRange,
      if (smsValueMode != null) 'sms_value_mode': smsValueMode,
    });
  }

  MetricsCompanion copyWith({
    Value<int>? id,
    Value<MetricSourceKind>? sourceKind,
    Value<int?>? brokerId,
    Value<int?>? smsSourceId,
    Value<String>? name,
    Value<String>? topic,
    Value<bool>? publishEnabled,
    Value<double?>? minValue,
    Value<double?>? maxValue,
    Value<bool>? useFixedRange,
    Value<SmsValueMode?>? smsValueMode,
  }) {
    return MetricsCompanion(
      id: id ?? this.id,
      sourceKind: sourceKind ?? this.sourceKind,
      brokerId: brokerId ?? this.brokerId,
      smsSourceId: smsSourceId ?? this.smsSourceId,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      publishEnabled: publishEnabled ?? this.publishEnabled,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      useFixedRange: useFixedRange ?? this.useFixedRange,
      smsValueMode: smsValueMode ?? this.smsValueMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<int>(
        $MetricsTable.$convertersourceKind.toSql(sourceKind.value),
      );
    }
    if (brokerId.present) {
      map['broker_id'] = Variable<int>(brokerId.value);
    }
    if (smsSourceId.present) {
      map['sms_source_id'] = Variable<int>(smsSourceId.value);
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
    if (useFixedRange.present) {
      map['use_fixed_range'] = Variable<bool>(useFixedRange.value);
    }
    if (smsValueMode.present) {
      map['sms_value_mode'] = Variable<int>(
        $MetricsTable.$convertersmsValueModen.toSql(smsValueMode.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricsCompanion(')
          ..write('id: $id, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('brokerId: $brokerId, ')
          ..write('smsSourceId: $smsSourceId, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('publishEnabled: $publishEnabled, ')
          ..write('minValue: $minValue, ')
          ..write('maxValue: $maxValue, ')
          ..write('useFixedRange: $useFixedRange, ')
          ..write('smsValueMode: $smsValueMode')
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
  List<GeneratedColumn> get $columns => [id, name];
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
  final String name;
  const Dashboard({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  DashboardsCompanion toCompanion(bool nullToAbsent) {
    return DashboardsCompanion(id: Value(id), name: Value(name));
  }

  factory Dashboard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dashboard(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Dashboard copyWith({int? id, String? name}) =>
      Dashboard(id: id ?? this.id, name: name ?? this.name);
  Dashboard copyWithCompanion(DashboardsCompanion data) {
    return Dashboard(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dashboard(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dashboard && other.id == this.id && other.name == this.name);
}

class DashboardsCompanion extends UpdateCompanion<Dashboard> {
  final Value<int> id;
  final Value<String> name;
  const DashboardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  DashboardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Dashboard> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  DashboardsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return DashboardsCompanion(id: id ?? this.id, name: name ?? this.name);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardsCompanion(')
          ..write('id: $id, ')
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, dashboardId, title, position];
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
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
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ChartsTable createAlias(String alias) {
    return $ChartsTable(attachedDatabase, alias);
  }
}

class ChartConfig extends DataClass implements Insertable<ChartConfig> {
  final int id;
  final int dashboardId;
  final String? title;

  /// Display order of this component within its dashboard (ascending). Lower
  /// values render higher up. Reordered by drag / move up-down in the UI.
  final int position;
  const ChartConfig({
    required this.id,
    required this.dashboardId,
    this.title,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dashboard_id'] = Variable<int>(dashboardId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  ChartsCompanion toCompanion(bool nullToAbsent) {
    return ChartsCompanion(
      id: Value(id),
      dashboardId: Value(dashboardId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      position: Value(position),
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
      title: serializer.fromJson<String?>(json['title']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dashboardId': serializer.toJson<int>(dashboardId),
      'title': serializer.toJson<String?>(title),
      'position': serializer.toJson<int>(position),
    };
  }

  ChartConfig copyWith({
    int? id,
    int? dashboardId,
    Value<String?> title = const Value.absent(),
    int? position,
  }) => ChartConfig(
    id: id ?? this.id,
    dashboardId: dashboardId ?? this.dashboardId,
    title: title.present ? title.value : this.title,
    position: position ?? this.position,
  );
  ChartConfig copyWithCompanion(ChartsCompanion data) {
    return ChartConfig(
      id: data.id.present ? data.id.value : this.id,
      dashboardId: data.dashboardId.present
          ? data.dashboardId.value
          : this.dashboardId,
      title: data.title.present ? data.title.value : this.title,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartConfig(')
          ..write('id: $id, ')
          ..write('dashboardId: $dashboardId, ')
          ..write('title: $title, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dashboardId, title, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartConfig &&
          other.id == this.id &&
          other.dashboardId == this.dashboardId &&
          other.title == this.title &&
          other.position == this.position);
}

class ChartsCompanion extends UpdateCompanion<ChartConfig> {
  final Value<int> id;
  final Value<int> dashboardId;
  final Value<String?> title;
  final Value<int> position;
  const ChartsCompanion({
    this.id = const Value.absent(),
    this.dashboardId = const Value.absent(),
    this.title = const Value.absent(),
    this.position = const Value.absent(),
  });
  ChartsCompanion.insert({
    this.id = const Value.absent(),
    required int dashboardId,
    this.title = const Value.absent(),
    this.position = const Value.absent(),
  }) : dashboardId = Value(dashboardId);
  static Insertable<ChartConfig> custom({
    Expression<int>? id,
    Expression<int>? dashboardId,
    Expression<String>? title,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dashboardId != null) 'dashboard_id': dashboardId,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
    });
  }

  ChartsCompanion copyWith({
    Value<int>? id,
    Value<int>? dashboardId,
    Value<String?>? title,
    Value<int>? position,
  }) {
    return ChartsCompanion(
      id: id ?? this.id,
      dashboardId: dashboardId ?? this.dashboardId,
      title: title ?? this.title,
      position: position ?? this.position,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartsCompanion(')
          ..write('id: $id, ')
          ..write('dashboardId: $dashboardId, ')
          ..write('title: $title, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $ChartSeriesTable extends ChartSeries
    with TableInfo<$ChartSeriesTable, ChartSeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartSeriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chartIdMeta = const VerificationMeta(
    'chartId',
  );
  @override
  late final GeneratedColumn<int> chartId = GeneratedColumn<int>(
    'chart_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES charts (id) ON DELETE CASCADE',
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
      ).withConverter<ChartType>($ChartSeriesTable.$convertertype);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visibleMeta = const VerificationMeta(
    'visible',
  );
  @override
  late final GeneratedColumn<bool> visible = GeneratedColumn<bool>(
    'visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sensorCountMeta = const VerificationMeta(
    'sensorCount',
  );
  @override
  late final GeneratedColumn<int> sensorCount = GeneratedColumn<int>(
    'sensor_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fillColorMeta = const VerificationMeta(
    'fillColor',
  );
  @override
  late final GeneratedColumn<int> fillColor = GeneratedColumn<int>(
    'fill_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emptyColorMeta = const VerificationMeta(
    'emptyColor',
  );
  @override
  late final GeneratedColumn<int> emptyColor = GeneratedColumn<int>(
    'empty_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bgColorMeta = const VerificationMeta(
    'bgColor',
  );
  @override
  late final GeneratedColumn<int> bgColor = GeneratedColumn<int>(
    'bg_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fgColorMeta = const VerificationMeta(
    'fgColor',
  );
  @override
  late final GeneratedColumn<int> fgColor = GeneratedColumn<int>(
    'fg_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chartId,
    metricId,
    type,
    color,
    visible,
    position,
    sensorCount,
    fillColor,
    emptyColor,
    unit,
    bgColor,
    fgColor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chart_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChartSeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chart_id')) {
      context.handle(
        _chartIdMeta,
        chartId.isAcceptableOrUnknown(data['chart_id']!, _chartIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chartIdMeta);
    }
    if (data.containsKey('metric_id')) {
      context.handle(
        _metricIdMeta,
        metricId.isAcceptableOrUnknown(data['metric_id']!, _metricIdMeta),
      );
    } else if (isInserting) {
      context.missing(_metricIdMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('visible')) {
      context.handle(
        _visibleMeta,
        visible.isAcceptableOrUnknown(data['visible']!, _visibleMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('sensor_count')) {
      context.handle(
        _sensorCountMeta,
        sensorCount.isAcceptableOrUnknown(
          data['sensor_count']!,
          _sensorCountMeta,
        ),
      );
    }
    if (data.containsKey('fill_color')) {
      context.handle(
        _fillColorMeta,
        fillColor.isAcceptableOrUnknown(data['fill_color']!, _fillColorMeta),
      );
    }
    if (data.containsKey('empty_color')) {
      context.handle(
        _emptyColorMeta,
        emptyColor.isAcceptableOrUnknown(data['empty_color']!, _emptyColorMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('bg_color')) {
      context.handle(
        _bgColorMeta,
        bgColor.isAcceptableOrUnknown(data['bg_color']!, _bgColorMeta),
      );
    }
    if (data.containsKey('fg_color')) {
      context.handle(
        _fgColorMeta,
        fgColor.isAcceptableOrUnknown(data['fg_color']!, _fgColorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartSeriesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChartSeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chartId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chart_id'],
      )!,
      metricId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}metric_id'],
      )!,
      type: $ChartSeriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      visible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}visible'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      sensorCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sensor_count'],
      ),
      fillColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fill_color'],
      ),
      emptyColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}empty_color'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      bgColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bg_color'],
      ),
      fgColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fg_color'],
      ),
    );
  }

  @override
  $ChartSeriesTable createAlias(String alias) {
    return $ChartSeriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChartType, int, int> $convertertype =
      const EnumIndexConverter<ChartType>(ChartType.values);
}

class ChartSeriesRow extends DataClass implements Insertable<ChartSeriesRow> {
  final int id;
  final int chartId;
  final int metricId;
  final ChartType type;

  /// ARGB color value used to draw the series.
  final int color;
  final bool visible;

  /// Display order within the chart.
  final int position;

  /// Number of sensor cells for a [ChartType.sensorGrid] (a multiple of 4).
  final int? sensorCount;

  /// ARGB fill color used when a sensor is in alert (sensorGrid).
  final int? fillColor;

  /// ARGB color used for a cleared/OK sensor cell (sensorGrid default color).
  final int? emptyColor;

  /// Unit label shown next to the value in a [ChartType.statTile].
  final String? unit;

  /// ARGB background color of a stat tile.
  final int? bgColor;

  /// ARGB foreground (text + border) color of a stat tile.
  final int? fgColor;
  const ChartSeriesRow({
    required this.id,
    required this.chartId,
    required this.metricId,
    required this.type,
    required this.color,
    required this.visible,
    required this.position,
    this.sensorCount,
    this.fillColor,
    this.emptyColor,
    this.unit,
    this.bgColor,
    this.fgColor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chart_id'] = Variable<int>(chartId);
    map['metric_id'] = Variable<int>(metricId);
    {
      map['type'] = Variable<int>($ChartSeriesTable.$convertertype.toSql(type));
    }
    map['color'] = Variable<int>(color);
    map['visible'] = Variable<bool>(visible);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || sensorCount != null) {
      map['sensor_count'] = Variable<int>(sensorCount);
    }
    if (!nullToAbsent || fillColor != null) {
      map['fill_color'] = Variable<int>(fillColor);
    }
    if (!nullToAbsent || emptyColor != null) {
      map['empty_color'] = Variable<int>(emptyColor);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || bgColor != null) {
      map['bg_color'] = Variable<int>(bgColor);
    }
    if (!nullToAbsent || fgColor != null) {
      map['fg_color'] = Variable<int>(fgColor);
    }
    return map;
  }

  ChartSeriesCompanion toCompanion(bool nullToAbsent) {
    return ChartSeriesCompanion(
      id: Value(id),
      chartId: Value(chartId),
      metricId: Value(metricId),
      type: Value(type),
      color: Value(color),
      visible: Value(visible),
      position: Value(position),
      sensorCount: sensorCount == null && nullToAbsent
          ? const Value.absent()
          : Value(sensorCount),
      fillColor: fillColor == null && nullToAbsent
          ? const Value.absent()
          : Value(fillColor),
      emptyColor: emptyColor == null && nullToAbsent
          ? const Value.absent()
          : Value(emptyColor),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      bgColor: bgColor == null && nullToAbsent
          ? const Value.absent()
          : Value(bgColor),
      fgColor: fgColor == null && nullToAbsent
          ? const Value.absent()
          : Value(fgColor),
    );
  }

  factory ChartSeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartSeriesRow(
      id: serializer.fromJson<int>(json['id']),
      chartId: serializer.fromJson<int>(json['chartId']),
      metricId: serializer.fromJson<int>(json['metricId']),
      type: $ChartSeriesTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      color: serializer.fromJson<int>(json['color']),
      visible: serializer.fromJson<bool>(json['visible']),
      position: serializer.fromJson<int>(json['position']),
      sensorCount: serializer.fromJson<int?>(json['sensorCount']),
      fillColor: serializer.fromJson<int?>(json['fillColor']),
      emptyColor: serializer.fromJson<int?>(json['emptyColor']),
      unit: serializer.fromJson<String?>(json['unit']),
      bgColor: serializer.fromJson<int?>(json['bgColor']),
      fgColor: serializer.fromJson<int?>(json['fgColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chartId': serializer.toJson<int>(chartId),
      'metricId': serializer.toJson<int>(metricId),
      'type': serializer.toJson<int>(
        $ChartSeriesTable.$convertertype.toJson(type),
      ),
      'color': serializer.toJson<int>(color),
      'visible': serializer.toJson<bool>(visible),
      'position': serializer.toJson<int>(position),
      'sensorCount': serializer.toJson<int?>(sensorCount),
      'fillColor': serializer.toJson<int?>(fillColor),
      'emptyColor': serializer.toJson<int?>(emptyColor),
      'unit': serializer.toJson<String?>(unit),
      'bgColor': serializer.toJson<int?>(bgColor),
      'fgColor': serializer.toJson<int?>(fgColor),
    };
  }

  ChartSeriesRow copyWith({
    int? id,
    int? chartId,
    int? metricId,
    ChartType? type,
    int? color,
    bool? visible,
    int? position,
    Value<int?> sensorCount = const Value.absent(),
    Value<int?> fillColor = const Value.absent(),
    Value<int?> emptyColor = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<int?> bgColor = const Value.absent(),
    Value<int?> fgColor = const Value.absent(),
  }) => ChartSeriesRow(
    id: id ?? this.id,
    chartId: chartId ?? this.chartId,
    metricId: metricId ?? this.metricId,
    type: type ?? this.type,
    color: color ?? this.color,
    visible: visible ?? this.visible,
    position: position ?? this.position,
    sensorCount: sensorCount.present ? sensorCount.value : this.sensorCount,
    fillColor: fillColor.present ? fillColor.value : this.fillColor,
    emptyColor: emptyColor.present ? emptyColor.value : this.emptyColor,
    unit: unit.present ? unit.value : this.unit,
    bgColor: bgColor.present ? bgColor.value : this.bgColor,
    fgColor: fgColor.present ? fgColor.value : this.fgColor,
  );
  ChartSeriesRow copyWithCompanion(ChartSeriesCompanion data) {
    return ChartSeriesRow(
      id: data.id.present ? data.id.value : this.id,
      chartId: data.chartId.present ? data.chartId.value : this.chartId,
      metricId: data.metricId.present ? data.metricId.value : this.metricId,
      type: data.type.present ? data.type.value : this.type,
      color: data.color.present ? data.color.value : this.color,
      visible: data.visible.present ? data.visible.value : this.visible,
      position: data.position.present ? data.position.value : this.position,
      sensorCount: data.sensorCount.present
          ? data.sensorCount.value
          : this.sensorCount,
      fillColor: data.fillColor.present ? data.fillColor.value : this.fillColor,
      emptyColor: data.emptyColor.present
          ? data.emptyColor.value
          : this.emptyColor,
      unit: data.unit.present ? data.unit.value : this.unit,
      bgColor: data.bgColor.present ? data.bgColor.value : this.bgColor,
      fgColor: data.fgColor.present ? data.fgColor.value : this.fgColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartSeriesRow(')
          ..write('id: $id, ')
          ..write('chartId: $chartId, ')
          ..write('metricId: $metricId, ')
          ..write('type: $type, ')
          ..write('color: $color, ')
          ..write('visible: $visible, ')
          ..write('position: $position, ')
          ..write('sensorCount: $sensorCount, ')
          ..write('fillColor: $fillColor, ')
          ..write('emptyColor: $emptyColor, ')
          ..write('unit: $unit, ')
          ..write('bgColor: $bgColor, ')
          ..write('fgColor: $fgColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chartId,
    metricId,
    type,
    color,
    visible,
    position,
    sensorCount,
    fillColor,
    emptyColor,
    unit,
    bgColor,
    fgColor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartSeriesRow &&
          other.id == this.id &&
          other.chartId == this.chartId &&
          other.metricId == this.metricId &&
          other.type == this.type &&
          other.color == this.color &&
          other.visible == this.visible &&
          other.position == this.position &&
          other.sensorCount == this.sensorCount &&
          other.fillColor == this.fillColor &&
          other.emptyColor == this.emptyColor &&
          other.unit == this.unit &&
          other.bgColor == this.bgColor &&
          other.fgColor == this.fgColor);
}

class ChartSeriesCompanion extends UpdateCompanion<ChartSeriesRow> {
  final Value<int> id;
  final Value<int> chartId;
  final Value<int> metricId;
  final Value<ChartType> type;
  final Value<int> color;
  final Value<bool> visible;
  final Value<int> position;
  final Value<int?> sensorCount;
  final Value<int?> fillColor;
  final Value<int?> emptyColor;
  final Value<String?> unit;
  final Value<int?> bgColor;
  final Value<int?> fgColor;
  const ChartSeriesCompanion({
    this.id = const Value.absent(),
    this.chartId = const Value.absent(),
    this.metricId = const Value.absent(),
    this.type = const Value.absent(),
    this.color = const Value.absent(),
    this.visible = const Value.absent(),
    this.position = const Value.absent(),
    this.sensorCount = const Value.absent(),
    this.fillColor = const Value.absent(),
    this.emptyColor = const Value.absent(),
    this.unit = const Value.absent(),
    this.bgColor = const Value.absent(),
    this.fgColor = const Value.absent(),
  });
  ChartSeriesCompanion.insert({
    this.id = const Value.absent(),
    required int chartId,
    required int metricId,
    required ChartType type,
    required int color,
    this.visible = const Value.absent(),
    this.position = const Value.absent(),
    this.sensorCount = const Value.absent(),
    this.fillColor = const Value.absent(),
    this.emptyColor = const Value.absent(),
    this.unit = const Value.absent(),
    this.bgColor = const Value.absent(),
    this.fgColor = const Value.absent(),
  }) : chartId = Value(chartId),
       metricId = Value(metricId),
       type = Value(type),
       color = Value(color);
  static Insertable<ChartSeriesRow> custom({
    Expression<int>? id,
    Expression<int>? chartId,
    Expression<int>? metricId,
    Expression<int>? type,
    Expression<int>? color,
    Expression<bool>? visible,
    Expression<int>? position,
    Expression<int>? sensorCount,
    Expression<int>? fillColor,
    Expression<int>? emptyColor,
    Expression<String>? unit,
    Expression<int>? bgColor,
    Expression<int>? fgColor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chartId != null) 'chart_id': chartId,
      if (metricId != null) 'metric_id': metricId,
      if (type != null) 'type': type,
      if (color != null) 'color': color,
      if (visible != null) 'visible': visible,
      if (position != null) 'position': position,
      if (sensorCount != null) 'sensor_count': sensorCount,
      if (fillColor != null) 'fill_color': fillColor,
      if (emptyColor != null) 'empty_color': emptyColor,
      if (unit != null) 'unit': unit,
      if (bgColor != null) 'bg_color': bgColor,
      if (fgColor != null) 'fg_color': fgColor,
    });
  }

  ChartSeriesCompanion copyWith({
    Value<int>? id,
    Value<int>? chartId,
    Value<int>? metricId,
    Value<ChartType>? type,
    Value<int>? color,
    Value<bool>? visible,
    Value<int>? position,
    Value<int?>? sensorCount,
    Value<int?>? fillColor,
    Value<int?>? emptyColor,
    Value<String?>? unit,
    Value<int?>? bgColor,
    Value<int?>? fgColor,
  }) {
    return ChartSeriesCompanion(
      id: id ?? this.id,
      chartId: chartId ?? this.chartId,
      metricId: metricId ?? this.metricId,
      type: type ?? this.type,
      color: color ?? this.color,
      visible: visible ?? this.visible,
      position: position ?? this.position,
      sensorCount: sensorCount ?? this.sensorCount,
      fillColor: fillColor ?? this.fillColor,
      emptyColor: emptyColor ?? this.emptyColor,
      unit: unit ?? this.unit,
      bgColor: bgColor ?? this.bgColor,
      fgColor: fgColor ?? this.fgColor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chartId.present) {
      map['chart_id'] = Variable<int>(chartId.value);
    }
    if (metricId.present) {
      map['metric_id'] = Variable<int>(metricId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $ChartSeriesTable.$convertertype.toSql(type.value),
      );
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (visible.present) {
      map['visible'] = Variable<bool>(visible.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (sensorCount.present) {
      map['sensor_count'] = Variable<int>(sensorCount.value);
    }
    if (fillColor.present) {
      map['fill_color'] = Variable<int>(fillColor.value);
    }
    if (emptyColor.present) {
      map['empty_color'] = Variable<int>(emptyColor.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (bgColor.present) {
      map['bg_color'] = Variable<int>(bgColor.value);
    }
    if (fgColor.present) {
      map['fg_color'] = Variable<int>(fgColor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartSeriesCompanion(')
          ..write('id: $id, ')
          ..write('chartId: $chartId, ')
          ..write('metricId: $metricId, ')
          ..write('type: $type, ')
          ..write('color: $color, ')
          ..write('visible: $visible, ')
          ..write('position: $position, ')
          ..write('sensorCount: $sensorCount, ')
          ..write('fillColor: $fillColor, ')
          ..write('emptyColor: $emptyColor, ')
          ..write('unit: $unit, ')
          ..write('bgColor: $bgColor, ')
          ..write('fgColor: $fgColor')
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
  static const VerificationMeta _rawMeta = const VerificationMeta('raw');
  @override
  late final GeneratedColumn<String> raw = GeneratedColumn<String>(
    'raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, metricId, value, timestamp, raw];
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
    if (data.containsKey('raw')) {
      context.handle(
        _rawMeta,
        raw.isAcceptableOrUnknown(data['raw']!, _rawMeta),
      );
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
      raw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw'],
      ),
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

  /// The raw payload / bracket value this reading was parsed from (e.g.
  /// `IN1, IN2, IN4`, `OK`, `21.62`). Kept so state components (sensor grid)
  /// can recover *which* inputs are active, which the numeric [value] loses.
  final String? raw;
  const Reading({
    required this.id,
    required this.metricId,
    required this.value,
    required this.timestamp,
    this.raw,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['metric_id'] = Variable<int>(metricId);
    map['value'] = Variable<double>(value);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || raw != null) {
      map['raw'] = Variable<String>(raw);
    }
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      metricId: Value(metricId),
      value: Value(value),
      timestamp: Value(timestamp),
      raw: raw == null && nullToAbsent ? const Value.absent() : Value(raw),
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
      raw: serializer.fromJson<String?>(json['raw']),
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
      'raw': serializer.toJson<String?>(raw),
    };
  }

  Reading copyWith({
    int? id,
    int? metricId,
    double? value,
    DateTime? timestamp,
    Value<String?> raw = const Value.absent(),
  }) => Reading(
    id: id ?? this.id,
    metricId: metricId ?? this.metricId,
    value: value ?? this.value,
    timestamp: timestamp ?? this.timestamp,
    raw: raw.present ? raw.value : this.raw,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      metricId: data.metricId.present ? data.metricId.value : this.metricId,
      value: data.value.present ? data.value.value : this.value,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      raw: data.raw.present ? data.raw.value : this.raw,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('metricId: $metricId, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('raw: $raw')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, metricId, value, timestamp, raw);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.metricId == this.metricId &&
          other.value == this.value &&
          other.timestamp == this.timestamp &&
          other.raw == this.raw);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<int> id;
  final Value<int> metricId;
  final Value<double> value;
  final Value<DateTime> timestamp;
  final Value<String?> raw;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.metricId = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.raw = const Value.absent(),
  });
  ReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int metricId,
    required double value,
    required DateTime timestamp,
    this.raw = const Value.absent(),
  }) : metricId = Value(metricId),
       value = Value(value),
       timestamp = Value(timestamp);
  static Insertable<Reading> custom({
    Expression<int>? id,
    Expression<int>? metricId,
    Expression<double>? value,
    Expression<DateTime>? timestamp,
    Expression<String>? raw,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (metricId != null) 'metric_id': metricId,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
      if (raw != null) 'raw': raw,
    });
  }

  ReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? metricId,
    Value<double>? value,
    Value<DateTime>? timestamp,
    Value<String?>? raw,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      metricId: metricId ?? this.metricId,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      raw: raw ?? this.raw,
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
    if (raw.present) {
      map['raw'] = Variable<String>(raw.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('metricId: $metricId, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('raw: $raw')
          ..write(')'))
        .toString();
  }
}

class $SmsMessagesTable extends SmsMessages
    with TableInfo<$SmsMessagesTable, SmsMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsMessagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _smsSourceIdMeta = const VerificationMeta(
    'smsSourceId',
  );
  @override
  late final GeneratedColumn<int> smsSourceId = GeneratedColumn<int>(
    'sms_source_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sms_sources (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SmsParseStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SmsParseStatus>($SmsMessagesTable.$converterstatus);
  static const VerificationMeta _readingsCreatedMeta = const VerificationMeta(
    'readingsCreated',
  );
  @override
  late final GeneratedColumn<int> readingsCreated = GeneratedColumn<int>(
    'readings_created',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    smsSourceId,
    sender,
    body,
    receivedAt,
    status,
    readingsCreated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sms_source_id')) {
      context.handle(
        _smsSourceIdMeta,
        smsSourceId.isAcceptableOrUnknown(
          data['sms_source_id']!,
          _smsSourceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_smsSourceIdMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('readings_created')) {
      context.handle(
        _readingsCreatedMeta,
        readingsCreated.isAcceptableOrUnknown(
          data['readings_created']!,
          _readingsCreatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      smsSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sms_source_id'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      status: $SmsMessagesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      readingsCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}readings_created'],
      )!,
    );
  }

  @override
  $SmsMessagesTable createAlias(String alias) {
    return $SmsMessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SmsParseStatus, int, int> $converterstatus =
      const EnumIndexConverter<SmsParseStatus>(SmsParseStatus.values);
}

class SmsMessage extends DataClass implements Insertable<SmsMessage> {
  final int id;
  final int smsSourceId;

  /// Raw sender address as reported by the OS.
  final String sender;

  /// Full, unmodified SMS body.
  final String body;
  final DateTime receivedAt;

  /// Outcome of parsing/matching this message.
  final SmsParseStatus status;

  /// How many readings this message produced (0 when unmatched).
  final int readingsCreated;
  const SmsMessage({
    required this.id,
    required this.smsSourceId,
    required this.sender,
    required this.body,
    required this.receivedAt,
    required this.status,
    required this.readingsCreated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sms_source_id'] = Variable<int>(smsSourceId);
    map['sender'] = Variable<String>(sender);
    map['body'] = Variable<String>(body);
    map['received_at'] = Variable<DateTime>(receivedAt);
    {
      map['status'] = Variable<int>(
        $SmsMessagesTable.$converterstatus.toSql(status),
      );
    }
    map['readings_created'] = Variable<int>(readingsCreated);
    return map;
  }

  SmsMessagesCompanion toCompanion(bool nullToAbsent) {
    return SmsMessagesCompanion(
      id: Value(id),
      smsSourceId: Value(smsSourceId),
      sender: Value(sender),
      body: Value(body),
      receivedAt: Value(receivedAt),
      status: Value(status),
      readingsCreated: Value(readingsCreated),
    );
  }

  factory SmsMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsMessage(
      id: serializer.fromJson<int>(json['id']),
      smsSourceId: serializer.fromJson<int>(json['smsSourceId']),
      sender: serializer.fromJson<String>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      status: $SmsMessagesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      readingsCreated: serializer.fromJson<int>(json['readingsCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'smsSourceId': serializer.toJson<int>(smsSourceId),
      'sender': serializer.toJson<String>(sender),
      'body': serializer.toJson<String>(body),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'status': serializer.toJson<int>(
        $SmsMessagesTable.$converterstatus.toJson(status),
      ),
      'readingsCreated': serializer.toJson<int>(readingsCreated),
    };
  }

  SmsMessage copyWith({
    int? id,
    int? smsSourceId,
    String? sender,
    String? body,
    DateTime? receivedAt,
    SmsParseStatus? status,
    int? readingsCreated,
  }) => SmsMessage(
    id: id ?? this.id,
    smsSourceId: smsSourceId ?? this.smsSourceId,
    sender: sender ?? this.sender,
    body: body ?? this.body,
    receivedAt: receivedAt ?? this.receivedAt,
    status: status ?? this.status,
    readingsCreated: readingsCreated ?? this.readingsCreated,
  );
  SmsMessage copyWithCompanion(SmsMessagesCompanion data) {
    return SmsMessage(
      id: data.id.present ? data.id.value : this.id,
      smsSourceId: data.smsSourceId.present
          ? data.smsSourceId.value
          : this.smsSourceId,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      status: data.status.present ? data.status.value : this.status,
      readingsCreated: data.readingsCreated.present
          ? data.readingsCreated.value
          : this.readingsCreated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsMessage(')
          ..write('id: $id, ')
          ..write('smsSourceId: $smsSourceId, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('status: $status, ')
          ..write('readingsCreated: $readingsCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    smsSourceId,
    sender,
    body,
    receivedAt,
    status,
    readingsCreated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsMessage &&
          other.id == this.id &&
          other.smsSourceId == this.smsSourceId &&
          other.sender == this.sender &&
          other.body == this.body &&
          other.receivedAt == this.receivedAt &&
          other.status == this.status &&
          other.readingsCreated == this.readingsCreated);
}

class SmsMessagesCompanion extends UpdateCompanion<SmsMessage> {
  final Value<int> id;
  final Value<int> smsSourceId;
  final Value<String> sender;
  final Value<String> body;
  final Value<DateTime> receivedAt;
  final Value<SmsParseStatus> status;
  final Value<int> readingsCreated;
  const SmsMessagesCompanion({
    this.id = const Value.absent(),
    this.smsSourceId = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.readingsCreated = const Value.absent(),
  });
  SmsMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int smsSourceId,
    required String sender,
    required String body,
    required DateTime receivedAt,
    required SmsParseStatus status,
    this.readingsCreated = const Value.absent(),
  }) : smsSourceId = Value(smsSourceId),
       sender = Value(sender),
       body = Value(body),
       receivedAt = Value(receivedAt),
       status = Value(status);
  static Insertable<SmsMessage> custom({
    Expression<int>? id,
    Expression<int>? smsSourceId,
    Expression<String>? sender,
    Expression<String>? body,
    Expression<DateTime>? receivedAt,
    Expression<int>? status,
    Expression<int>? readingsCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (smsSourceId != null) 'sms_source_id': smsSourceId,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
      if (receivedAt != null) 'received_at': receivedAt,
      if (status != null) 'status': status,
      if (readingsCreated != null) 'readings_created': readingsCreated,
    });
  }

  SmsMessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? smsSourceId,
    Value<String>? sender,
    Value<String>? body,
    Value<DateTime>? receivedAt,
    Value<SmsParseStatus>? status,
    Value<int>? readingsCreated,
  }) {
    return SmsMessagesCompanion(
      id: id ?? this.id,
      smsSourceId: smsSourceId ?? this.smsSourceId,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      status: status ?? this.status,
      readingsCreated: readingsCreated ?? this.readingsCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (smsSourceId.present) {
      map['sms_source_id'] = Variable<int>(smsSourceId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $SmsMessagesTable.$converterstatus.toSql(status.value),
      );
    }
    if (readingsCreated.present) {
      map['readings_created'] = Variable<int>(readingsCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsMessagesCompanion(')
          ..write('id: $id, ')
          ..write('smsSourceId: $smsSourceId, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('status: $status, ')
          ..write('readingsCreated: $readingsCreated')
          ..write(')'))
        .toString();
  }
}

class $SmsTopicPresetsTable extends SmsTopicPresets
    with TableInfo<$SmsTopicPresetsTable, SmsTopicPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsTopicPresetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, label, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_topic_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsTopicPreset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {label},
  ];
  @override
  SmsTopicPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsTopicPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SmsTopicPresetsTable createAlias(String alias) {
    return $SmsTopicPresetsTable(attachedDatabase, alias);
  }
}

class SmsTopicPreset extends DataClass implements Insertable<SmsTopicPreset> {
  final int id;
  final String label;
  final DateTime createdAt;
  const SmsTopicPreset({
    required this.id,
    required this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SmsTopicPresetsCompanion toCompanion(bool nullToAbsent) {
    return SmsTopicPresetsCompanion(
      id: Value(id),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory SmsTopicPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsTopicPreset(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SmsTopicPreset copyWith({int? id, String? label, DateTime? createdAt}) =>
      SmsTopicPreset(
        id: id ?? this.id,
        label: label ?? this.label,
        createdAt: createdAt ?? this.createdAt,
      );
  SmsTopicPreset copyWithCompanion(SmsTopicPresetsCompanion data) {
    return SmsTopicPreset(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsTopicPreset(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsTopicPreset &&
          other.id == this.id &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class SmsTopicPresetsCompanion extends UpdateCompanion<SmsTopicPreset> {
  final Value<int> id;
  final Value<String> label;
  final Value<DateTime> createdAt;
  const SmsTopicPresetsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SmsTopicPresetsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.createdAt = const Value.absent(),
  }) : label = Value(label);
  static Insertable<SmsTopicPreset> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SmsTopicPresetsCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<DateTime>? createdAt,
  }) {
    return SmsTopicPresetsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsTopicPresetsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BrokersTable brokers = $BrokersTable(this);
  late final $SmsSourcesTable smsSources = $SmsSourcesTable(this);
  late final $MetricsTable metrics = $MetricsTable(this);
  late final $DashboardsTable dashboards = $DashboardsTable(this);
  late final $ChartsTable charts = $ChartsTable(this);
  late final $ChartSeriesTable chartSeries = $ChartSeriesTable(this);
  late final $ReadingsTable readings = $ReadingsTable(this);
  late final $SmsMessagesTable smsMessages = $SmsMessagesTable(this);
  late final $SmsTopicPresetsTable smsTopicPresets = $SmsTopicPresetsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    brokers,
    smsSources,
    metrics,
    dashboards,
    charts,
    chartSeries,
    readings,
    smsMessages,
    smsTopicPresets,
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
        'sms_sources',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('metrics', kind: UpdateKind.delete)],
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
        'charts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chart_series', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'metrics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chart_series', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'metrics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('readings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sms_sources',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sms_messages', kind: UpdateKind.delete)],
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
      Value<bool> secure,
      Value<int> keepAlive,
      Value<int> connectTimeout,
      Value<int> qos,
      Value<bool> retain,
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
      Value<bool> secure,
      Value<int> keepAlive,
      Value<int> connectTimeout,
      Value<int> qos,
      Value<bool> retain,
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

  ColumnFilters<bool> get secure => $composableBuilder(
    column: $table.secure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get keepAlive => $composableBuilder(
    column: $table.keepAlive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get connectTimeout => $composableBuilder(
    column: $table.connectTimeout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qos => $composableBuilder(
    column: $table.qos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get retain => $composableBuilder(
    column: $table.retain,
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

  ColumnOrderings<bool> get secure => $composableBuilder(
    column: $table.secure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get keepAlive => $composableBuilder(
    column: $table.keepAlive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get connectTimeout => $composableBuilder(
    column: $table.connectTimeout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qos => $composableBuilder(
    column: $table.qos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get retain => $composableBuilder(
    column: $table.retain,
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

  GeneratedColumn<bool> get secure =>
      $composableBuilder(column: $table.secure, builder: (column) => column);

  GeneratedColumn<int> get keepAlive =>
      $composableBuilder(column: $table.keepAlive, builder: (column) => column);

  GeneratedColumn<int> get connectTimeout => $composableBuilder(
    column: $table.connectTimeout,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qos =>
      $composableBuilder(column: $table.qos, builder: (column) => column);

  GeneratedColumn<bool> get retain =>
      $composableBuilder(column: $table.retain, builder: (column) => column);

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
          PrefetchHooks Function({bool metricsRefs})
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
                Value<bool> secure = const Value.absent(),
                Value<int> keepAlive = const Value.absent(),
                Value<int> connectTimeout = const Value.absent(),
                Value<int> qos = const Value.absent(),
                Value<bool> retain = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrokersCompanion(
                id: id,
                name: name,
                address: address,
                port: port,
                username: username,
                password: password,
                secure: secure,
                keepAlive: keepAlive,
                connectTimeout: connectTimeout,
                qos: qos,
                retain: retain,
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
                Value<bool> secure = const Value.absent(),
                Value<int> keepAlive = const Value.absent(),
                Value<int> connectTimeout = const Value.absent(),
                Value<int> qos = const Value.absent(),
                Value<bool> retain = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrokersCompanion.insert(
                id: id,
                name: name,
                address: address,
                port: port,
                username: username,
                password: password,
                secure: secure,
                keepAlive: keepAlive,
                connectTimeout: connectTimeout,
                qos: qos,
                retain: retain,
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
          prefetchHooksCallback: ({metricsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (metricsRefs) db.metrics],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (metricsRefs)
                    await $_getPrefetchedData<Broker, $BrokersTable, Metric>(
                      currentTable: table,
                      referencedTable: $$BrokersTableReferences
                          ._metricsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BrokersTableReferences(db, table, p0).metricsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.brokerId == item.id),
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
      PrefetchHooks Function({bool metricsRefs})
    >;
typedef $$SmsSourcesTableCreateCompanionBuilder =
    SmsSourcesCompanion Function({
      Value<int> id,
      required String name,
      required String phoneNumber,
      Value<DateTime> createdAt,
    });
typedef $$SmsSourcesTableUpdateCompanionBuilder =
    SmsSourcesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phoneNumber,
      Value<DateTime> createdAt,
    });

final class $$SmsSourcesTableReferences
    extends BaseReferences<_$AppDatabase, $SmsSourcesTable, SmsSource> {
  $$SmsSourcesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MetricsTable, List<Metric>> _metricsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.metrics,
    aliasName: $_aliasNameGenerator(db.smsSources.id, db.metrics.smsSourceId),
  );

  $$MetricsTableProcessedTableManager get metricsRefs {
    final manager = $$MetricsTableTableManager(
      $_db,
      $_db.metrics,
    ).filter((f) => f.smsSourceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_metricsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SmsMessagesTable, List<SmsMessage>>
  _smsMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.smsMessages,
    aliasName: $_aliasNameGenerator(
      db.smsSources.id,
      db.smsMessages.smsSourceId,
    ),
  );

  $$SmsMessagesTableProcessedTableManager get smsMessagesRefs {
    final manager = $$SmsMessagesTableTableManager(
      $_db,
      $_db.smsMessages,
    ).filter((f) => f.smsSourceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_smsMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SmsSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $SmsSourcesTable> {
  $$SmsSourcesTableFilterComposer({
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

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
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
      getReferencedColumn: (t) => t.smsSourceId,
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

  Expression<bool> smsMessagesRefs(
    Expression<bool> Function($$SmsMessagesTableFilterComposer f) f,
  ) {
    final $$SmsMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsMessages,
      getReferencedColumn: (t) => t.smsSourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsMessagesTableFilterComposer(
            $db: $db,
            $table: $db.smsMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SmsSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsSourcesTable> {
  $$SmsSourcesTableOrderingComposer({
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

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmsSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsSourcesTable> {
  $$SmsSourcesTableAnnotationComposer({
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

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> metricsRefs<T extends Object>(
    Expression<T> Function($$MetricsTableAnnotationComposer a) f,
  ) {
    final $$MetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metrics,
      getReferencedColumn: (t) => t.smsSourceId,
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

  Expression<T> smsMessagesRefs<T extends Object>(
    Expression<T> Function($$SmsMessagesTableAnnotationComposer a) f,
  ) {
    final $$SmsMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsMessages,
      getReferencedColumn: (t) => t.smsSourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.smsMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SmsSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsSourcesTable,
          SmsSource,
          $$SmsSourcesTableFilterComposer,
          $$SmsSourcesTableOrderingComposer,
          $$SmsSourcesTableAnnotationComposer,
          $$SmsSourcesTableCreateCompanionBuilder,
          $$SmsSourcesTableUpdateCompanionBuilder,
          (SmsSource, $$SmsSourcesTableReferences),
          SmsSource,
          PrefetchHooks Function({bool metricsRefs, bool smsMessagesRefs})
        > {
  $$SmsSourcesTableTableManager(_$AppDatabase db, $SmsSourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SmsSourcesCompanion(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phoneNumber,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SmsSourcesCompanion.insert(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmsSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({metricsRefs = false, smsMessagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (metricsRefs) db.metrics,
                    if (smsMessagesRefs) db.smsMessages,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (metricsRefs)
                        await $_getPrefetchedData<
                          SmsSource,
                          $SmsSourcesTable,
                          Metric
                        >(
                          currentTable: table,
                          referencedTable: $$SmsSourcesTableReferences
                              ._metricsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SmsSourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).metricsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.smsSourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (smsMessagesRefs)
                        await $_getPrefetchedData<
                          SmsSource,
                          $SmsSourcesTable,
                          SmsMessage
                        >(
                          currentTable: table,
                          referencedTable: $$SmsSourcesTableReferences
                              ._smsMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SmsSourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).smsMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.smsSourceId == item.id,
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

typedef $$SmsSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsSourcesTable,
      SmsSource,
      $$SmsSourcesTableFilterComposer,
      $$SmsSourcesTableOrderingComposer,
      $$SmsSourcesTableAnnotationComposer,
      $$SmsSourcesTableCreateCompanionBuilder,
      $$SmsSourcesTableUpdateCompanionBuilder,
      (SmsSource, $$SmsSourcesTableReferences),
      SmsSource,
      PrefetchHooks Function({bool metricsRefs, bool smsMessagesRefs})
    >;
typedef $$MetricsTableCreateCompanionBuilder =
    MetricsCompanion Function({
      Value<int> id,
      Value<MetricSourceKind> sourceKind,
      Value<int?> brokerId,
      Value<int?> smsSourceId,
      required String name,
      required String topic,
      Value<bool> publishEnabled,
      Value<double?> minValue,
      Value<double?> maxValue,
      Value<bool> useFixedRange,
      Value<SmsValueMode?> smsValueMode,
    });
typedef $$MetricsTableUpdateCompanionBuilder =
    MetricsCompanion Function({
      Value<int> id,
      Value<MetricSourceKind> sourceKind,
      Value<int?> brokerId,
      Value<int?> smsSourceId,
      Value<String> name,
      Value<String> topic,
      Value<bool> publishEnabled,
      Value<double?> minValue,
      Value<double?> maxValue,
      Value<bool> useFixedRange,
      Value<SmsValueMode?> smsValueMode,
    });

final class $$MetricsTableReferences
    extends BaseReferences<_$AppDatabase, $MetricsTable, Metric> {
  $$MetricsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BrokersTable _brokerIdTable(_$AppDatabase db) => db.brokers
      .createAlias($_aliasNameGenerator(db.metrics.brokerId, db.brokers.id));

  $$BrokersTableProcessedTableManager? get brokerId {
    final $_column = $_itemColumn<int>('broker_id');
    if ($_column == null) return null;
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

  static $SmsSourcesTable _smsSourceIdTable(_$AppDatabase db) =>
      db.smsSources.createAlias(
        $_aliasNameGenerator(db.metrics.smsSourceId, db.smsSources.id),
      );

  $$SmsSourcesTableProcessedTableManager? get smsSourceId {
    final $_column = $_itemColumn<int>('sms_source_id');
    if ($_column == null) return null;
    final manager = $$SmsSourcesTableTableManager(
      $_db,
      $_db.smsSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_smsSourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChartSeriesTable, List<ChartSeriesRow>>
  _chartSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chartSeries,
    aliasName: $_aliasNameGenerator(db.metrics.id, db.chartSeries.metricId),
  );

  $$ChartSeriesTableProcessedTableManager get chartSeriesRefs {
    final manager = $$ChartSeriesTableTableManager(
      $_db,
      $_db.chartSeries,
    ).filter((f) => f.metricId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartSeriesRefsTable($_db));
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

  ColumnWithTypeConverterFilters<MetricSourceKind, MetricSourceKind, int>
  get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnFilters<bool> get useFixedRange => $composableBuilder(
    column: $table.useFixedRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SmsValueMode?, SmsValueMode, int>
  get smsValueMode => $composableBuilder(
    column: $table.smsValueMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  $$SmsSourcesTableFilterComposer get smsSourceId {
    final $$SmsSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsSourceId,
      referencedTable: $db.smsSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSourcesTableFilterComposer(
            $db: $db,
            $table: $db.smsSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> chartSeriesRefs(
    Expression<bool> Function($$ChartSeriesTableFilterComposer f) f,
  ) {
    final $$ChartSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartSeries,
      getReferencedColumn: (t) => t.metricId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartSeriesTableFilterComposer(
            $db: $db,
            $table: $db.chartSeries,
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

  ColumnOrderings<int> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
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

  ColumnOrderings<bool> get useFixedRange => $composableBuilder(
    column: $table.useFixedRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get smsValueMode => $composableBuilder(
    column: $table.smsValueMode,
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

  $$SmsSourcesTableOrderingComposer get smsSourceId {
    final $$SmsSourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsSourceId,
      referencedTable: $db.smsSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSourcesTableOrderingComposer(
            $db: $db,
            $table: $db.smsSources,
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

  GeneratedColumnWithTypeConverter<MetricSourceKind, int> get sourceKind =>
      $composableBuilder(
        column: $table.sourceKind,
        builder: (column) => column,
      );

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

  GeneratedColumn<bool> get useFixedRange => $composableBuilder(
    column: $table.useFixedRange,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SmsValueMode?, int> get smsValueMode =>
      $composableBuilder(
        column: $table.smsValueMode,
        builder: (column) => column,
      );

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

  $$SmsSourcesTableAnnotationComposer get smsSourceId {
    final $$SmsSourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsSourceId,
      referencedTable: $db.smsSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.smsSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> chartSeriesRefs<T extends Object>(
    Expression<T> Function($$ChartSeriesTableAnnotationComposer a) f,
  ) {
    final $$ChartSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartSeries,
      getReferencedColumn: (t) => t.metricId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.chartSeries,
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
            bool smsSourceId,
            bool chartSeriesRefs,
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
                Value<MetricSourceKind> sourceKind = const Value.absent(),
                Value<int?> brokerId = const Value.absent(),
                Value<int?> smsSourceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<bool> publishEnabled = const Value.absent(),
                Value<double?> minValue = const Value.absent(),
                Value<double?> maxValue = const Value.absent(),
                Value<bool> useFixedRange = const Value.absent(),
                Value<SmsValueMode?> smsValueMode = const Value.absent(),
              }) => MetricsCompanion(
                id: id,
                sourceKind: sourceKind,
                brokerId: brokerId,
                smsSourceId: smsSourceId,
                name: name,
                topic: topic,
                publishEnabled: publishEnabled,
                minValue: minValue,
                maxValue: maxValue,
                useFixedRange: useFixedRange,
                smsValueMode: smsValueMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<MetricSourceKind> sourceKind = const Value.absent(),
                Value<int?> brokerId = const Value.absent(),
                Value<int?> smsSourceId = const Value.absent(),
                required String name,
                required String topic,
                Value<bool> publishEnabled = const Value.absent(),
                Value<double?> minValue = const Value.absent(),
                Value<double?> maxValue = const Value.absent(),
                Value<bool> useFixedRange = const Value.absent(),
                Value<SmsValueMode?> smsValueMode = const Value.absent(),
              }) => MetricsCompanion.insert(
                id: id,
                sourceKind: sourceKind,
                brokerId: brokerId,
                smsSourceId: smsSourceId,
                name: name,
                topic: topic,
                publishEnabled: publishEnabled,
                minValue: minValue,
                maxValue: maxValue,
                useFixedRange: useFixedRange,
                smsValueMode: smsValueMode,
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
              ({
                brokerId = false,
                smsSourceId = false,
                chartSeriesRefs = false,
                readingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chartSeriesRefs) db.chartSeries,
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
                        if (smsSourceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.smsSourceId,
                                    referencedTable: $$MetricsTableReferences
                                        ._smsSourceIdTable(db),
                                    referencedColumn: $$MetricsTableReferences
                                        ._smsSourceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chartSeriesRefs)
                        await $_getPrefetchedData<
                          Metric,
                          $MetricsTable,
                          ChartSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$MetricsTableReferences
                              ._chartSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MetricsTableReferences(
                                db,
                                table,
                                p0,
                              ).chartSeriesRefs,
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
        bool smsSourceId,
        bool chartSeriesRefs,
        bool readingsRefs,
      })
    >;
typedef $$DashboardsTableCreateCompanionBuilder =
    DashboardsCompanion Function({Value<int> id, required String name});
typedef $$DashboardsTableUpdateCompanionBuilder =
    DashboardsCompanion Function({Value<int> id, Value<String> name});

final class $$DashboardsTableReferences
    extends BaseReferences<_$AppDatabase, $DashboardsTable, Dashboard> {
  $$DashboardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

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
          PrefetchHooks Function({bool chartsRefs})
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
                Value<String> name = const Value.absent(),
              }) => DashboardsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  DashboardsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DashboardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chartsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chartsRefs) db.charts],
              addJoins: null,
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
      PrefetchHooks Function({bool chartsRefs})
    >;
typedef $$ChartsTableCreateCompanionBuilder =
    ChartsCompanion Function({
      Value<int> id,
      required int dashboardId,
      Value<String?> title,
      Value<int> position,
    });
typedef $$ChartsTableUpdateCompanionBuilder =
    ChartsCompanion Function({
      Value<int> id,
      Value<int> dashboardId,
      Value<String?> title,
      Value<int> position,
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

  static MultiTypedResultKey<$ChartSeriesTable, List<ChartSeriesRow>>
  _chartSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chartSeries,
    aliasName: $_aliasNameGenerator(db.charts.id, db.chartSeries.chartId),
  );

  $$ChartSeriesTableProcessedTableManager get chartSeriesRefs {
    final manager = $$ChartSeriesTableTableManager(
      $_db,
      $_db.chartSeries,
    ).filter((f) => f.chartId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartSeriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
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

  Expression<bool> chartSeriesRefs(
    Expression<bool> Function($$ChartSeriesTableFilterComposer f) f,
  ) {
    final $$ChartSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartSeries,
      getReferencedColumn: (t) => t.chartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartSeriesTableFilterComposer(
            $db: $db,
            $table: $db.chartSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

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

  Expression<T> chartSeriesRefs<T extends Object>(
    Expression<T> Function($$ChartSeriesTableAnnotationComposer a) f,
  ) {
    final $$ChartSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartSeries,
      getReferencedColumn: (t) => t.chartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.chartSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({bool dashboardId, bool chartSeriesRefs})
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
                Value<String?> title = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => ChartsCompanion(
                id: id,
                dashboardId: dashboardId,
                title: title,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dashboardId,
                Value<String?> title = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => ChartsCompanion.insert(
                id: id,
                dashboardId: dashboardId,
                title: title,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ChartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({dashboardId = false, chartSeriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chartSeriesRefs) db.chartSeries,
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

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chartSeriesRefs)
                        await $_getPrefetchedData<
                          ChartConfig,
                          $ChartsTable,
                          ChartSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$ChartsTableReferences
                              ._chartSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChartsTableReferences(
                                db,
                                table,
                                p0,
                              ).chartSeriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chartId == item.id,
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
      PrefetchHooks Function({bool dashboardId, bool chartSeriesRefs})
    >;
typedef $$ChartSeriesTableCreateCompanionBuilder =
    ChartSeriesCompanion Function({
      Value<int> id,
      required int chartId,
      required int metricId,
      required ChartType type,
      required int color,
      Value<bool> visible,
      Value<int> position,
      Value<int?> sensorCount,
      Value<int?> fillColor,
      Value<int?> emptyColor,
      Value<String?> unit,
      Value<int?> bgColor,
      Value<int?> fgColor,
    });
typedef $$ChartSeriesTableUpdateCompanionBuilder =
    ChartSeriesCompanion Function({
      Value<int> id,
      Value<int> chartId,
      Value<int> metricId,
      Value<ChartType> type,
      Value<int> color,
      Value<bool> visible,
      Value<int> position,
      Value<int?> sensorCount,
      Value<int?> fillColor,
      Value<int?> emptyColor,
      Value<String?> unit,
      Value<int?> bgColor,
      Value<int?> fgColor,
    });

final class $$ChartSeriesTableReferences
    extends BaseReferences<_$AppDatabase, $ChartSeriesTable, ChartSeriesRow> {
  $$ChartSeriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChartsTable _chartIdTable(_$AppDatabase db) => db.charts.createAlias(
    $_aliasNameGenerator(db.chartSeries.chartId, db.charts.id),
  );

  $$ChartsTableProcessedTableManager get chartId {
    final $_column = $_itemColumn<int>('chart_id')!;

    final manager = $$ChartsTableTableManager(
      $_db,
      $_db.charts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chartIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MetricsTable _metricIdTable(_$AppDatabase db) =>
      db.metrics.createAlias(
        $_aliasNameGenerator(db.chartSeries.metricId, db.metrics.id),
      );

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

class $$ChartSeriesTableFilterComposer
    extends Composer<_$AppDatabase, $ChartSeriesTable> {
  $$ChartSeriesTableFilterComposer({
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

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visible => $composableBuilder(
    column: $table.visible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sensorCount => $composableBuilder(
    column: $table.sensorCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fillColor => $composableBuilder(
    column: $table.fillColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emptyColor => $composableBuilder(
    column: $table.emptyColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bgColor => $composableBuilder(
    column: $table.bgColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fgColor => $composableBuilder(
    column: $table.fgColor,
    builder: (column) => ColumnFilters(column),
  );

  $$ChartsTableFilterComposer get chartId {
    final $$ChartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chartId,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.id,
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

class $$ChartSeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartSeriesTable> {
  $$ChartSeriesTableOrderingComposer({
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

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visible => $composableBuilder(
    column: $table.visible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sensorCount => $composableBuilder(
    column: $table.sensorCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fillColor => $composableBuilder(
    column: $table.fillColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emptyColor => $composableBuilder(
    column: $table.emptyColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bgColor => $composableBuilder(
    column: $table.bgColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fgColor => $composableBuilder(
    column: $table.fgColor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChartsTableOrderingComposer get chartId {
    final $$ChartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chartId,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartsTableOrderingComposer(
            $db: $db,
            $table: $db.charts,
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

class $$ChartSeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartSeriesTable> {
  $$ChartSeriesTableAnnotationComposer({
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

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get visible =>
      $composableBuilder(column: $table.visible, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get sensorCount => $composableBuilder(
    column: $table.sensorCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fillColor =>
      $composableBuilder(column: $table.fillColor, builder: (column) => column);

  GeneratedColumn<int> get emptyColor => $composableBuilder(
    column: $table.emptyColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get bgColor =>
      $composableBuilder(column: $table.bgColor, builder: (column) => column);

  GeneratedColumn<int> get fgColor =>
      $composableBuilder(column: $table.fgColor, builder: (column) => column);

  $$ChartsTableAnnotationComposer get chartId {
    final $$ChartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chartId,
      referencedTable: $db.charts,
      getReferencedColumn: (t) => t.id,
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

class $$ChartSeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartSeriesTable,
          ChartSeriesRow,
          $$ChartSeriesTableFilterComposer,
          $$ChartSeriesTableOrderingComposer,
          $$ChartSeriesTableAnnotationComposer,
          $$ChartSeriesTableCreateCompanionBuilder,
          $$ChartSeriesTableUpdateCompanionBuilder,
          (ChartSeriesRow, $$ChartSeriesTableReferences),
          ChartSeriesRow,
          PrefetchHooks Function({bool chartId, bool metricId})
        > {
  $$ChartSeriesTableTableManager(_$AppDatabase db, $ChartSeriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChartSeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChartSeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChartSeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chartId = const Value.absent(),
                Value<int> metricId = const Value.absent(),
                Value<ChartType> type = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> visible = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int?> sensorCount = const Value.absent(),
                Value<int?> fillColor = const Value.absent(),
                Value<int?> emptyColor = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int?> bgColor = const Value.absent(),
                Value<int?> fgColor = const Value.absent(),
              }) => ChartSeriesCompanion(
                id: id,
                chartId: chartId,
                metricId: metricId,
                type: type,
                color: color,
                visible: visible,
                position: position,
                sensorCount: sensorCount,
                fillColor: fillColor,
                emptyColor: emptyColor,
                unit: unit,
                bgColor: bgColor,
                fgColor: fgColor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chartId,
                required int metricId,
                required ChartType type,
                required int color,
                Value<bool> visible = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int?> sensorCount = const Value.absent(),
                Value<int?> fillColor = const Value.absent(),
                Value<int?> emptyColor = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int?> bgColor = const Value.absent(),
                Value<int?> fgColor = const Value.absent(),
              }) => ChartSeriesCompanion.insert(
                id: id,
                chartId: chartId,
                metricId: metricId,
                type: type,
                color: color,
                visible: visible,
                position: position,
                sensorCount: sensorCount,
                fillColor: fillColor,
                emptyColor: emptyColor,
                unit: unit,
                bgColor: bgColor,
                fgColor: fgColor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChartSeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chartId = false, metricId = false}) {
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
                    if (chartId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chartId,
                                referencedTable: $$ChartSeriesTableReferences
                                    ._chartIdTable(db),
                                referencedColumn: $$ChartSeriesTableReferences
                                    ._chartIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (metricId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.metricId,
                                referencedTable: $$ChartSeriesTableReferences
                                    ._metricIdTable(db),
                                referencedColumn: $$ChartSeriesTableReferences
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

typedef $$ChartSeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartSeriesTable,
      ChartSeriesRow,
      $$ChartSeriesTableFilterComposer,
      $$ChartSeriesTableOrderingComposer,
      $$ChartSeriesTableAnnotationComposer,
      $$ChartSeriesTableCreateCompanionBuilder,
      $$ChartSeriesTableUpdateCompanionBuilder,
      (ChartSeriesRow, $$ChartSeriesTableReferences),
      ChartSeriesRow,
      PrefetchHooks Function({bool chartId, bool metricId})
    >;
typedef $$ReadingsTableCreateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      required int metricId,
      required double value,
      required DateTime timestamp,
      Value<String?> raw,
    });
typedef $$ReadingsTableUpdateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      Value<int> metricId,
      Value<double> value,
      Value<DateTime> timestamp,
      Value<String?> raw,
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

  ColumnFilters<String> get raw => $composableBuilder(
    column: $table.raw,
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

  ColumnOrderings<String> get raw => $composableBuilder(
    column: $table.raw,
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

  GeneratedColumn<String> get raw =>
      $composableBuilder(column: $table.raw, builder: (column) => column);

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
                Value<String?> raw = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                metricId: metricId,
                value: value,
                timestamp: timestamp,
                raw: raw,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int metricId,
                required double value,
                required DateTime timestamp,
                Value<String?> raw = const Value.absent(),
              }) => ReadingsCompanion.insert(
                id: id,
                metricId: metricId,
                value: value,
                timestamp: timestamp,
                raw: raw,
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
typedef $$SmsMessagesTableCreateCompanionBuilder =
    SmsMessagesCompanion Function({
      Value<int> id,
      required int smsSourceId,
      required String sender,
      required String body,
      required DateTime receivedAt,
      required SmsParseStatus status,
      Value<int> readingsCreated,
    });
typedef $$SmsMessagesTableUpdateCompanionBuilder =
    SmsMessagesCompanion Function({
      Value<int> id,
      Value<int> smsSourceId,
      Value<String> sender,
      Value<String> body,
      Value<DateTime> receivedAt,
      Value<SmsParseStatus> status,
      Value<int> readingsCreated,
    });

final class $$SmsMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $SmsMessagesTable, SmsMessage> {
  $$SmsMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SmsSourcesTable _smsSourceIdTable(_$AppDatabase db) =>
      db.smsSources.createAlias(
        $_aliasNameGenerator(db.smsMessages.smsSourceId, db.smsSources.id),
      );

  $$SmsSourcesTableProcessedTableManager get smsSourceId {
    final $_column = $_itemColumn<int>('sms_source_id')!;

    final manager = $$SmsSourcesTableTableManager(
      $_db,
      $_db.smsSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_smsSourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SmsMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $SmsMessagesTable> {
  $$SmsMessagesTableFilterComposer({
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

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SmsParseStatus, SmsParseStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get readingsCreated => $composableBuilder(
    column: $table.readingsCreated,
    builder: (column) => ColumnFilters(column),
  );

  $$SmsSourcesTableFilterComposer get smsSourceId {
    final $$SmsSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsSourceId,
      referencedTable: $db.smsSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSourcesTableFilterComposer(
            $db: $db,
            $table: $db.smsSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsMessagesTable> {
  $$SmsMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readingsCreated => $composableBuilder(
    column: $table.readingsCreated,
    builder: (column) => ColumnOrderings(column),
  );

  $$SmsSourcesTableOrderingComposer get smsSourceId {
    final $$SmsSourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsSourceId,
      referencedTable: $db.smsSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSourcesTableOrderingComposer(
            $db: $db,
            $table: $db.smsSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsMessagesTable> {
  $$SmsMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SmsParseStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get readingsCreated => $composableBuilder(
    column: $table.readingsCreated,
    builder: (column) => column,
  );

  $$SmsSourcesTableAnnotationComposer get smsSourceId {
    final $$SmsSourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsSourceId,
      referencedTable: $db.smsSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsSourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.smsSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsMessagesTable,
          SmsMessage,
          $$SmsMessagesTableFilterComposer,
          $$SmsMessagesTableOrderingComposer,
          $$SmsMessagesTableAnnotationComposer,
          $$SmsMessagesTableCreateCompanionBuilder,
          $$SmsMessagesTableUpdateCompanionBuilder,
          (SmsMessage, $$SmsMessagesTableReferences),
          SmsMessage,
          PrefetchHooks Function({bool smsSourceId})
        > {
  $$SmsMessagesTableTableManager(_$AppDatabase db, $SmsMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> smsSourceId = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<SmsParseStatus> status = const Value.absent(),
                Value<int> readingsCreated = const Value.absent(),
              }) => SmsMessagesCompanion(
                id: id,
                smsSourceId: smsSourceId,
                sender: sender,
                body: body,
                receivedAt: receivedAt,
                status: status,
                readingsCreated: readingsCreated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int smsSourceId,
                required String sender,
                required String body,
                required DateTime receivedAt,
                required SmsParseStatus status,
                Value<int> readingsCreated = const Value.absent(),
              }) => SmsMessagesCompanion.insert(
                id: id,
                smsSourceId: smsSourceId,
                sender: sender,
                body: body,
                receivedAt: receivedAt,
                status: status,
                readingsCreated: readingsCreated,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmsMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({smsSourceId = false}) {
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
                    if (smsSourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.smsSourceId,
                                referencedTable: $$SmsMessagesTableReferences
                                    ._smsSourceIdTable(db),
                                referencedColumn: $$SmsMessagesTableReferences
                                    ._smsSourceIdTable(db)
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

typedef $$SmsMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsMessagesTable,
      SmsMessage,
      $$SmsMessagesTableFilterComposer,
      $$SmsMessagesTableOrderingComposer,
      $$SmsMessagesTableAnnotationComposer,
      $$SmsMessagesTableCreateCompanionBuilder,
      $$SmsMessagesTableUpdateCompanionBuilder,
      (SmsMessage, $$SmsMessagesTableReferences),
      SmsMessage,
      PrefetchHooks Function({bool smsSourceId})
    >;
typedef $$SmsTopicPresetsTableCreateCompanionBuilder =
    SmsTopicPresetsCompanion Function({
      Value<int> id,
      required String label,
      Value<DateTime> createdAt,
    });
typedef $$SmsTopicPresetsTableUpdateCompanionBuilder =
    SmsTopicPresetsCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<DateTime> createdAt,
    });

class $$SmsTopicPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $SmsTopicPresetsTable> {
  $$SmsTopicPresetsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SmsTopicPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsTopicPresetsTable> {
  $$SmsTopicPresetsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmsTopicPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsTopicPresetsTable> {
  $$SmsTopicPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SmsTopicPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsTopicPresetsTable,
          SmsTopicPreset,
          $$SmsTopicPresetsTableFilterComposer,
          $$SmsTopicPresetsTableOrderingComposer,
          $$SmsTopicPresetsTableAnnotationComposer,
          $$SmsTopicPresetsTableCreateCompanionBuilder,
          $$SmsTopicPresetsTableUpdateCompanionBuilder,
          (
            SmsTopicPreset,
            BaseReferences<
              _$AppDatabase,
              $SmsTopicPresetsTable,
              SmsTopicPreset
            >,
          ),
          SmsTopicPreset,
          PrefetchHooks Function()
        > {
  $$SmsTopicPresetsTableTableManager(
    _$AppDatabase db,
    $SmsTopicPresetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsTopicPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsTopicPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsTopicPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SmsTopicPresetsCompanion(
                id: id,
                label: label,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SmsTopicPresetsCompanion.insert(
                id: id,
                label: label,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmsTopicPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsTopicPresetsTable,
      SmsTopicPreset,
      $$SmsTopicPresetsTableFilterComposer,
      $$SmsTopicPresetsTableOrderingComposer,
      $$SmsTopicPresetsTableAnnotationComposer,
      $$SmsTopicPresetsTableCreateCompanionBuilder,
      $$SmsTopicPresetsTableUpdateCompanionBuilder,
      (
        SmsTopicPreset,
        BaseReferences<_$AppDatabase, $SmsTopicPresetsTable, SmsTopicPreset>,
      ),
      SmsTopicPreset,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BrokersTableTableManager get brokers =>
      $$BrokersTableTableManager(_db, _db.brokers);
  $$SmsSourcesTableTableManager get smsSources =>
      $$SmsSourcesTableTableManager(_db, _db.smsSources);
  $$MetricsTableTableManager get metrics =>
      $$MetricsTableTableManager(_db, _db.metrics);
  $$DashboardsTableTableManager get dashboards =>
      $$DashboardsTableTableManager(_db, _db.dashboards);
  $$ChartsTableTableManager get charts =>
      $$ChartsTableTableManager(_db, _db.charts);
  $$ChartSeriesTableTableManager get chartSeries =>
      $$ChartSeriesTableTableManager(_db, _db.chartSeries);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
  $$SmsMessagesTableTableManager get smsMessages =>
      $$SmsMessagesTableTableManager(_db, _db.smsMessages);
  $$SmsTopicPresetsTableTableManager get smsTopicPresets =>
      $$SmsTopicPresetsTableTableManager(_db, _db.smsTopicPresets);
}
