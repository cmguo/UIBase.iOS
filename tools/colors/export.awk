#!/usr/local/bin/gawk -f Resources/Default.bundle/style.json Resources/Default.bundle/style.json

BEGIN {

}

{
  k = ""
  if (substr($0, 5, 1) == " ") {
  } else if (substr($2, 2, 1) == "#") {
    k = $1
    v = $2
  } else if (substr($3, 2, 1) == "#") {
    k = $1
    v = $3
  }
  if (k != "") {
    gsub(/[":]/, "", k);
    gsub(/[",]/, "", v);
    if (NR == FNR) {
      map[k] = v;
    } else if (k in map) {
      map[k] = map[k] "\t" v;
    } else {
      map[k] = "-------\t" v;
    }
  }
}

END {
  for (k in map) {
    print k "\t" map[k]
  }
}
