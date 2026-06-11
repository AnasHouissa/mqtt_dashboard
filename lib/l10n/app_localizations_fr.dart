// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tableau de bord MQTT';

  @override
  String get brokers => 'Brokers';

  @override
  String get noBrokers => 'Aucun broker. Appuyez sur + pour en ajouter un.';

  @override
  String get addBroker => 'Ajouter un broker';

  @override
  String get editBroker => 'Modifier le broker';

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
  String get delete => 'Supprimer';

  @override
  String get connect => 'Connecter';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get connected => 'Connecté';

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
  String get metrics => 'Métriques';

  @override
  String get noMetrics => 'Aucune métrique. Appuyez sur + pour en ajouter une.';

  @override
  String get addMetric => 'Ajouter une métrique';

  @override
  String get editMetric => 'Modifier la métrique';

  @override
  String get metricName => 'Nom de la métrique';

  @override
  String get topic => 'Topic';

  @override
  String get enablePublishing => 'Activer la publication';

  @override
  String get minValue => 'Valeur min';

  @override
  String get maxValue => 'Valeur max';

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
  String get dashboardName => 'Nom du tableau de bord';

  @override
  String get addCurve => 'Ajouter courbe';

  @override
  String get noCharts => 'Aucun graphique. Appuyez sur « Ajouter courbe ».';

  @override
  String get chartType => 'Type de graphique';

  @override
  String get curve => 'Courbe';

  @override
  String get histogram => 'Histogramme';

  @override
  String get spline => 'Spline';

  @override
  String get area => 'Aire';

  @override
  String get scatter => 'Nuage de points';

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
  String get today => 'Aujourd\'hui';

  @override
  String get day => 'Jour';

  @override
  String get month => 'Mois';

  @override
  String get year => 'Année';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String get exportPdf => 'Exporter PDF';

  @override
  String get fullscreen => 'Plein écran';

  @override
  String get noData => 'Aucune donnée pour cette période';

  @override
  String get fieldRequired => 'Requis';

  @override
  String get invalidNumber => 'Entrez un nombre valide';

  @override
  String get invalidPort => 'Entrez un port valide (1-65535)';

  @override
  String get language => 'Langue';

  @override
  String get settings => 'Paramètres';

  @override
  String get deleteConfirmTitle => 'Supprimer ?';

  @override
  String get deleteConfirmBody => 'Cette action est irréversible.';

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
  String get seedMockData => 'Générer 30 jours de données fictives';

  @override
  String get mockDataSeeded =>
      'Données fictives ajoutées pour les 30 derniers jours';
}
