final linkPattern = r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$';
final linkRegExp = RegExp(linkPattern);

bool validateIsLink(String input) {
  return linkRegExp.hasMatch(input);
}