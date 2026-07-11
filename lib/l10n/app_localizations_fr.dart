// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TEKKIM Dash';

  @override
  String get brokers => 'Brokers';

  @override
  String get noBrokers => 'Aucun broker. Appuyez sur + pour en ajouter un.';

  @override
  String get addBroker => 'Ajouter un broker';

  @override
  String get editBroker => 'Modifier';

  @override
  String get duplicate => 'Dupliquer';

  @override
  String copyOf(String name) {
    return '$name (copie)';
  }

  @override
  String get brokerName => 'Nom du broker';

  @override
  String get brokerAddress => 'Adresse';

  @override
  String get brokerPort => 'Port';

  @override
  String get username => 'Nom d\'utilisateur (optionnel)';

  @override
  String get password => 'Mot de passe (optionnel)';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get delete => 'Supprimer';

  @override
  String get connect => 'Connecter';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get connected => 'Connecté';

  @override
  String connectedTo(String broker) {
    return 'Connecté à $broker';
  }

  @override
  String get disconnected => 'Déconnecté';

  @override
  String get connecting => 'Connexion…';

  @override
  String get connectionFailed => 'Échec de la connexion';

  @override
  String unableToConnect(String reason) {
    return 'Connexion impossible : $reason';
  }

  @override
  String get reasonNetwork =>
      'impossible de joindre le broker — vérifiez l\'adresse, le port et votre réseau';

  @override
  String get reasonBadCredentials =>
      'le nom d\'utilisateur ou le mot de passe a été rejeté';

  @override
  String get reasonBrokerUnavailable => 'le broker est indisponible';

  @override
  String get reasonRejected => 'le broker a refusé la demande de connexion';

  @override
  String get reasonUnknown => 'erreur inconnue';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String get testing => 'Test en cours…';

  @override
  String get connectionSuccessful => 'Connexion réussie';

  @override
  String get secureTls => 'Sécurisé (TLS)';

  @override
  String get advanced => 'Avancé';

  @override
  String get qos => 'QoS';

  @override
  String get retain => 'Conserver les messages publiés';

  @override
  String get keepAliveSeconds => 'Keep-alive (s)';

  @override
  String get timeoutSeconds => 'Délai d\'expiration (s)';

  @override
  String get invalidValue => 'Entrez un nombre positif';

  @override
  String get metrics => 'Métriques';

  @override
  String get noMetrics => 'Aucune métrique. Appuyez sur + pour en ajouter une.';

  @override
  String get addMetric => 'Ajouter une métrique';

  @override
  String get editMetric => 'Modifier';

  @override
  String get metricName => 'Nom de la métrique';

  @override
  String get topic => 'Topic';

  @override
  String get enablePublishing => 'Activer la publication';

  @override
  String get minValue => 'Min';

  @override
  String get maxValue => 'Max';

  @override
  String get fixedChartRange => 'Plage de graphique fixe';

  @override
  String get fixedChartRangeOn =>
      'L\'axe Y utilise les valeurs min/max saisies';

  @override
  String get fixedChartRangeOff => 'L\'axe Y s\'adapte aux valeurs reçues';

  @override
  String get rangeRequiresMinMax => 'Saisissez min et max pour une plage fixe';

  @override
  String get publish => 'Publier';

  @override
  String get valueToPublish => 'Valeur à publier';

  @override
  String get published => 'Publié';

  @override
  String get dashboards => 'Tableaux de bord';

  @override
  String get noDashboards =>
      'Aucun tableau de bord. Appuyez sur + pour en ajouter un.';

  @override
  String get addDashboard => 'Ajouter un tableau de bord';

  @override
  String get renameDashboard => 'Renommer le tableau de bord';

  @override
  String get dashboardName => 'Nom du tableau de bord';

  @override
  String get addCurve => 'Ajouter courbe';

  @override
  String get editCurve => 'Modifier';

  @override
  String get noCharts => 'Aucun graphique. Appuyez sur « Ajouter courbe ».';

  @override
  String get chartType => 'Type de graphique';

  @override
  String get histogram => 'Histogramme';

  @override
  String get column => 'Colonne';

  @override
  String get bar => 'Barre';

  @override
  String get rangeArea => 'Aire de plage';

  @override
  String get stackedColumn => 'Colonne empilée';

  @override
  String get stackedBar => 'Barre empilée';

  @override
  String get stackedColumn100 => 'Colonne empilée 100%';

  @override
  String get boxAndWhisker => 'Boîte à moustaches';

  @override
  String get radialBar => 'Barre radiale';

  @override
  String get doughnut => 'Anneau';

  @override
  String get pie => 'Camembert';

  @override
  String get errorBar => 'Barre d\'erreur';

  @override
  String get spline => 'Courbe (spline)';

  @override
  String get line => 'Ligne';

  @override
  String get color => 'Couleur';

  @override
  String get showInChart => 'Afficher dans le graphique';

  @override
  String get addMetricSeries => 'Ajouter une métrique';

  @override
  String get selectMetric => 'Sélectionner une métrique';

  @override
  String get chartTitle => 'Titre du graphique (optionnel)';

  @override
  String get day => 'Jour';

  @override
  String get month => 'Mois';

  @override
  String get year => 'Année';

  @override
  String get ok => 'OK';

  @override
  String get pickPeriod => 'Choisir la période';

  @override
  String get selectMonth => 'Choisir le mois';

  @override
  String get selectYear => 'Choisir l\'année';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String get exportPdf => 'Exporter PDF';

  @override
  String get fullscreen => 'Plein écran';

  @override
  String get moveUp => 'Monter';

  @override
  String get moveDown => 'Descendre';

  @override
  String get noData => 'Aucune donnée pour cette période';

  @override
  String get fieldRequired => 'Requis';

  @override
  String get invalidNumber => 'Entrez un nombre valide';

  @override
  String get invalidPort => 'Entrez un port valide (1-65535)';

  @override
  String get dataSource => 'Source de données';

  @override
  String get sms => 'SMS';

  @override
  String get smsComingSoon => 'Sources de données SMS à venir.';

  @override
  String get noSmsSources =>
      'Aucune source SMS. Appuyez sur + pour en ajouter une.';

  @override
  String get addSmsSource => 'Ajouter une source SMS';

  @override
  String get editSmsSource => 'Modifier la source SMS';

  @override
  String get smsSourceName => 'Nom de la source';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneNumberHint => 'Numéro expéditeur — +216 puis 8 chiffres';

  @override
  String get invalidTunisianNumber =>
      'Saisissez un numéro tunisien valide (+216 puis 8 chiffres)';

  @override
  String deleteSmsSourceBody(String name) {
    return 'Supprimer « $name » ? Ses métriques et relevés seront aussi supprimés définitivement.';
  }

  @override
  String get smsStationName => 'Nom de la station';

  @override
  String get smsStationNameHint => 'Correspond à la première ligne du message';

  @override
  String get valueMode => 'Mode de valeur';

  @override
  String get valueModeAuto => 'Détection auto';

  @override
  String get valueModeNumber => 'Nombre';

  @override
  String get valueModeNumberDesc => 'Utiliser le nombre entre crochets';

  @override
  String get valueModeCount => 'Nombre d\'entrées actives';

  @override
  String get valueModeCountDesc => 'Compter les entrées actives (OK = 0)';

  @override
  String get valueModePresence => 'Présence';

  @override
  String get valueModePresenceDesc => '1 en alerte, sinon 0';

  @override
  String get smsRawLog => 'Journal SMS brut';

  @override
  String get noSmsMessages => 'Aucun message reçu pour l\'instant.';

  @override
  String get smsStatusMatched => 'Associé';

  @override
  String get smsStatusUnmatched => 'Non associé';

  @override
  String get smsStatusError => 'Erreur d\'analyse';

  @override
  String smsReadings(int count) {
    return '$count relevés';
  }

  @override
  String get smsPermissionRequired => 'Autorisation SMS requise';

  @override
  String get smsPermissionRationale =>
      'Autorisez la lecture des SMS pour transformer les messages de vos sources en relevés.';

  @override
  String get grantPermission => 'Autoriser';

  @override
  String get smsPermissionDenied =>
      'Autorisation refusée. Activez l\'accès aux SMS dans les paramètres système.';

  @override
  String get smsAndroidOnly =>
      'Les sources de données SMS ne sont disponibles que sur Android.';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Système';

  @override
  String get settings => 'Paramètres';

  @override
  String get smsSettings => 'SMS';

  @override
  String get smsTopicPresets => 'Topics prédéfinis';

  @override
  String get smsTopicPresetsSubtitle =>
      'Libellés de topic réutilisables pour les métriques SMS';

  @override
  String get addSmsTopic => 'Ajouter un topic';

  @override
  String get smsTopicLabel => 'Libellé du topic';

  @override
  String get noSmsTopics => 'Aucun topic prédéfini pour le moment';

  @override
  String get appVersion => 'Version de l’application';

  @override
  String get deleteConfirmTitle => 'Supprimer ?';

  @override
  String get deleteConfirmBody => 'Cette action est irréversible.';

  @override
  String deleteNamedBody(String name) {
    return 'Supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String deleteBrokerBody(String name) {
    return 'Supprimer « $name » ? Ses métriques, tableaux de bord, graphiques et relevés seront aussi supprimés définitivement.';
  }

  @override
  String exportTitle(String name) {
    return 'Export des données $name';
  }

  @override
  String get timestamp => 'Horodatage';

  @override
  String get value => 'Valeur';

  @override
  String get liveConsole => 'Console en direct';

  @override
  String get consoleWaiting => 'En attente de messages…';

  @override
  String get clear => 'Effacer';

  @override
  String get publishMessage => 'Publier un message';

  @override
  String get publishDisabled =>
      'La publication est désactivée pour cette métrique';

  @override
  String get add => 'Ajouter';

  @override
  String get name => 'Nom';

  @override
  String get leakGrid => 'Grille de capteurs';

  @override
  String get statTile => 'Tuile de statistique';

  @override
  String get addLeakGrid => 'Ajouter une grille';

  @override
  String get editLeakGrid => 'Modifier';

  @override
  String get addStatTile => 'Ajouter une tuile';

  @override
  String get editStatTile => 'Modifier';

  @override
  String get alertDuration => 'Durée d\'alerte';

  @override
  String get addAlertDuration => 'Ajouter une durée d\'alerte';

  @override
  String get editAlertDuration => 'Modifier la durée d\'alerte';

  @override
  String get totalAlertTime => 'Temps en alerte';

  @override
  String get noAlerts => 'Aucune alerte';

  @override
  String alertCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertes',
      one: '1 alerte',
    );
    return '$_temp0';
  }

  @override
  String openSince(String time) {
    return 'Ouvert depuis $time';
  }

  @override
  String get sensorCount => 'Nombre de capteurs';

  @override
  String get fillColor => 'Couleur d\'alerte';

  @override
  String get emptyColor => 'Couleur vide / OK';

  @override
  String get unit => 'Unité';

  @override
  String get backgroundColor => 'Couleur de fond';

  @override
  String get foregroundColor => 'Couleur du texte';

  @override
  String get setpointOne => 'Consigne 1';

  @override
  String get setpointTwo => 'Consigne 2';

  @override
  String get avgPerDay => 'Moy./jour';

  @override
  String get noInternet => 'Pas de connexion Internet';

  @override
  String get noInternetBody => 'Vérifiez votre réseau et réessayez.';

  @override
  String get background => 'Arrière-plan';

  @override
  String get bgKeepConnected => 'Garder les brokers connectés en arrière-plan';

  @override
  String get bgKeepConnectedSubtitle =>
      'Continuer à recevoir des lectures quand l’application est fermée. Consomme plus de batterie.';

  @override
  String get bgNotificationTitle => 'TEKKIM Dash actif';

  @override
  String bgNotificationBody(String broker) {
    return 'Connexion à $broker maintenue';
  }
}
