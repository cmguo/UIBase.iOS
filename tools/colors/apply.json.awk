#!/usr/local/bin/gawk -f

BEGIN {
  system("rm -f map.txt")
}

BEGINFILE {
  print FILENAME
  delete records
  replace = 0
}

{
  if (NR == FNR) {
    map[$1] = $4
    print $1 " -> " $4
  } else {
    if (match($0, /"(\w+)"\s*: "#[0-9A-F]+"/, result) > 0) {
      c = result[1]
      r = "Line " NR ": " c;
      if (c in map && map[c] != "") {
        r = r " <deleted> by " map[c] "."
        records[NR] = r
        replace++
        next
      }
    } else if (match($0, /public var (\w+): UIColor \{/, result) > 0) {
      L1 = $0
      C = result[1]
      getline
      L2 = $0
      if (match($0, /return ThemeColor\.color\(path: "(\w+)", defaultColor/, result) > 0) {
        c = result[1]
        r = "Line " NR ": " C;
        if (c in map && map[c] != "") {
          print C "\t" map[c] > "map.txt"
          r = r " <deleted> by " map[c] "."
          records[NR] = r
          getline
          getline
          replace++
        } else {
          print L1 > FILENAME ".temp"
          print L2 > FILENAME ".temp"
        }
      } else {
        print L1 > FILENAME ".temp"
      }
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
