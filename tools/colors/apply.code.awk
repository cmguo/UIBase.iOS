#!/usr/local/bin/gawk -f

BEGIN {

}

BEGINFILE {
  print FILENAME
  delete records
  replace = 0
}

{
  if (NR == FNR) {
    map[$1] = $2
  } else {
    start = 1
    while (match(substr($0, start), /ThemeColor\.shared\.(\w+)/, result) > 0) {
      s = result[1, "start"] + start - 1
      l = result[1, "length"]
      c = result[1]
      r = "Line " NR ": " c;
      start = s + l;
      if (c in map) {
        d = map[c]
        if (d == "") {
          r = r " <skip>"
        } else {
          $0 = substr($0, 1, s - 1) map[c] substr($0, s + l);
          r = r " -> " map[c]
          start = s + length(map[c])
          replace++
        }
      } else {
        r = r " <not found>"
      }
      records[length(records) + 1] = r
    }
    print $0 > FILENAME ".temp"
  }
}

ENDFILE {
  for (r in records) {
    print records[r]
  }
  if (replace > 0) {
    print "modify " FILENAME
    system("mv " FILENAME ".temp " FILENAME)
  } else {
    system("rm -f " FILENAME ".temp")
  }
}
