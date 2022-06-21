// GENERATED FILE, do not edit!
import 'package:i18n/i18n.dart' as i18n;

String get _languageCode => 'en';
String _plural(int count,
        {String? zero,
        String? one,
        String? two,
        String? few,
        String? many,
        String? other}) =>
    i18n.plural(count, _languageCode,
        zero: zero, one: one, two: two, few: few, many: many, other: other);
String _ordinal(int count,
        {String? zero,
        String? one,
        String? two,
        String? few,
        String? many,
        String? other}) =>
    i18n.ordinal(count, _languageCode,
        zero: zero, one: one, two: two, few: few, many: many, other: other);
String _cardinal(int count,
        {String? zero,
        String? one,
        String? two,
        String? few,
        String? many,
        String? other}) =>
    i18n.cardinal(count, _languageCode,
        zero: zero, one: one, two: two, few: few, many: many, other: other);

class Messages {
  const Messages();
  String get locale => "en";
  String get languageCode => "en";
  String get app_title => """Maya Flutter App""";
  String get page_title => """Maya""";
  String get sign_up_message => """${page_title}に新規登録""";
  String get phone_auth_title => """Phone Number Authentication""";
  String get reCaptcha_loading_text => """認証中です...""";
  String get phone_auth_code_label => """電話番号を入力""";
  String get phone_auth_code_hint => """例) 080XXXXXXXX""";
  String get phone_auth_code_button => """電話番号を認証""";
  String get phone_auth_error_title => """認証に失敗しました""";
  String get phone_auth_error_message => """電話番号が正しいか、認証番号を正しく入力したかご確認ください。""";
  String get phone_auth_error_wrong_phone_number => """電話番号が正しいかご確認ください。""";
  String get phone_auth_error_return => """戻る""";
  String get phone_auth_input_auth_code => """認証番号を入力してください""";
  String get phone_auth_input_continue => """決定""";
  String get phone_auth_input_wrong_number => """認証番号が違います。""";
  String get phone_auth_input_code_title => """認証番号を入力してください""";
  String get sign_up_name_register => """名前を登録""";
  String get sign_up_name_first_name => """苗字""";
  String get sign_up_name_last_name => """名前""";
  String get sign_up_name_submit => """名前を登録""";
  String get sign_up_name_register_confirm => """名前情報の確認""";
  String sign_up_name_register_confirm_body(String first, String last) =>
      """入力した名前情報が間違いないことを確認してください。
正しい場合は「${sign_up_name_confirm}」を押してください。

苗字: ${first}
名前: ${last}""";
  String get sign_up_name_confirm => """決定""";
  String get sign_up_name_edit => """訂正する""";
  String get sign_up_name_register_complete_message_title => """名前情報を登録しました""";
  String get sign_up_name_register_complete_message_body =>
      """正常に名前情報を登録しました。""";
  String get sign_up_name_register_failed_message_title =>
      """名前情報を登録できませんでした""";
  String sign_up_name_register_failed_message_body(String error_message) =>
      """正常に名前情報を登録できませんでした。
エラーメッセージ:${error_message}""";
  String get sign_up_name_register_not_inputted => """名前を入力してください""";
}

Map<String, String> get messagesMap => {
      """app_title""": """Maya Flutter App""",
      """page_title""": """Maya""",
      """phone_auth_title""": """Phone Number Authentication""",
      """reCaptcha_loading_text""": """認証中です...""",
      """phone_auth_code_label""": """電話番号を入力""",
      """phone_auth_code_hint""": """例) 080XXXXXXXX""",
      """phone_auth_code_button""": """電話番号を認証""",
      """phone_auth_error_title""": """認証に失敗しました""",
      """phone_auth_error_message""": """電話番号が正しいか、認証番号を正しく入力したかご確認ください。""",
      """phone_auth_error_wrong_phone_number""": """電話番号が正しいかご確認ください。""",
      """phone_auth_error_return""": """戻る""",
      """phone_auth_input_auth_code""": """認証番号を入力してください""",
      """phone_auth_input_continue""": """決定""",
      """phone_auth_input_wrong_number""": """認証番号が違います。""",
      """phone_auth_input_code_title""": """認証番号を入力してください""",
      """sign_up_name_register""": """名前を登録""",
      """sign_up_name_first_name""": """苗字""",
      """sign_up_name_last_name""": """名前""",
      """sign_up_name_submit""": """名前を登録""",
      """sign_up_name_register_confirm""": """名前情報の確認""",
      """sign_up_name_confirm""": """決定""",
      """sign_up_name_edit""": """訂正する""",
      """sign_up_name_register_complete_message_title""": """名前情報を登録しました""",
      """sign_up_name_register_complete_message_body""": """正常に名前情報を登録しました。""",
      """sign_up_name_register_failed_message_title""": """名前情報を登録できませんでした""",
      """sign_up_name_register_not_inputted""": """名前を入力してください""",
    };
