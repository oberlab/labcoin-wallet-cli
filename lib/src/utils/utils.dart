bool isInteger(String s) {
  if(s == null) {
    return false;
  }
  try {
    int.parse(s);
    return true;
  } catch (e) {
    return false;
  }
}