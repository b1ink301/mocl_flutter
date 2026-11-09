part of 'mocl_app_pages.dart';

abstract class Routes._() {
  static const home = '/';
  static const main = '/main';
  static const list = '/list';
  static const search = '/search';
  static const detail = '/detail';
  static const mute = '/mute';
  static const keywordAlerts = '/keyword-alerts';
  static const issueDetail = '/issue';
  static const login = '/login';
  static const video = '/video';
  static const viewPhotoDlg = 'viewPhotoDlg';
  static const viewPhotoDlgFull = '$detail/$viewPhotoDlg';
  static const setMainDlg = 'setMainDlg';
  static const setMainDlgFull = '$main/$setMainDlg';
}
