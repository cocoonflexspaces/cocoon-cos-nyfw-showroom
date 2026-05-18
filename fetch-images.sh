#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# fetch-images.sh — pull Casa Panorama + Casa Luz photos from the
# public Google Drive folders to local files, plus the original
# Casa Brutal + Casa Arbus assets from cocoonflexspaces.com.
#
# Run once from this folder:
#   bash fetch-images.sh
#
# After it completes, run rewrite-paths.sh to swap remote URLs for
# the local img/<venue>/<floor>/ paths in index.html.
# ─────────────────────────────────────────────────────────────────────

set -euo pipefail
cd "$(dirname "$0")"

mkdir -p img/panorama/lower img/panorama/upper img/panorama/rooftop
mkdir -p img/luz/lower img/luz/upper img/luz/facade
mkdir -p img/brutal img/arbus

UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15'
COOKIE_JAR="$(mktemp)"
trap 'rm -f "$COOKIE_JAR"' EXIT

valid_image() {
  [ -f "$1" ] && [ "$(stat -f%z "$1" 2>/dev/null || stat -c%s "$1")" -gt 1024 ] && \
    file "$1" | grep -qiE 'image|jpeg|png|webp'
}

# Download a Google Drive file by ID via the lh3 CDN (works for public files).
gdrive() {
  local id="$1" out="$2"
  if valid_image "$out"; then
    echo "  ✓ $out (already downloaded)"
    return
  fi
  echo "  → $out"
  curl -sSL --fail -A "$UA" \
    -o "$out" "https://lh3.googleusercontent.com/d/${id}=w1600" \
    || { echo "    ✗ failed: drive id $id"; rm -f "$out"; return; }
  if ! valid_image "$out"; then
    echo "    ✗ non-image response for $id"; rm -f "$out"
  fi
}

# Download a cocoonflexspaces.com asset (Brutal + Arbus).
dl() {
  local url="$1" out="$2" referer="${3:-}"
  if valid_image "$out"; then
    echo "  ✓ $out (already downloaded)"
    return
  fi
  echo "  → $out"
  curl -sSL --fail -A "$UA" \
    ${referer:+-e "$referer"} \
    -H 'Accept: image/avif,image/webp,image/png,image/jpeg,*/*;q=0.8' \
    -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
    -o "$out" "$url" \
    || { echo "    ✗ failed: $url"; rm -f "$out"; return; }
  if ! valid_image "$out"; then
    echo "    ✗ non-image response (likely WAF challenge): $url"; rm -f "$out"
  fi
}

warm() {
  local slug="$1"
  curl -sSL -A "$UA" -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
    -H 'Accept: text/html' \
    -o /dev/null "https://cocoonflexspaces.com/$slug/" || true
}

echo "──────────────────────────────────────────"
echo "  Casa Panorama · Drive"
echo "──────────────────────────────────────────"
# Lower Floor
gdrive 1UA7i8nE4w-Pt-KeLOgqTt7Yu4K4sqeCl img/panorama/lower/01-hero.jpg
gdrive 1o7SyGDZbukawkpn25JMzrDBCv-MxskSz img/panorama/lower/02.jpg
gdrive 1KuoY-Moco_kWut2yEDvIvadiTAyovZWF img/panorama/lower/03.jpg
gdrive 15YCvnO8B7jkzrbfrTs4Z_rWXIypUfoX1 img/panorama/lower/04.jpg
# Upper Floor
gdrive 1-rD5zL62wNyjjBOCenbvrSPIj9ZFVBJv img/panorama/upper/01.jpg
gdrive 1qa0BQ4eOUHosCovdKJ9mXfL2ojhTePk5 img/panorama/upper/02.jpg
gdrive 1_88zu1jLgI-Vpj3F5V9Wm13W17B5sIR5 img/panorama/upper/03.jpg
# Rooftop
gdrive 15J_N-QN05LldndORpFGYRiy2ezLJrAOg img/panorama/rooftop/01-hero.jpg
gdrive 1W6JzMEZJhYu_-J6PtHdMhQTpmdOO708W img/panorama/rooftop/02.jpg
gdrive 1fVSjKj3W69FiuazJjAlSuA5d4zfJHocC img/panorama/rooftop/03.jpg

echo ""
echo "──────────────────────────────────────────"
echo "  Casa Luz · Drive"
echo "──────────────────────────────────────────"
# Cover hero (also used as deck cover)
gdrive 1frhhOFPhQiip19_fmeSTbZt_sAfFmhuI img/luz/lower/00-cover-hero.jpg
# Lower Floor
gdrive 1sM8-EoIaPgl4PGYzXVInzWqigv8vQslr img/luz/lower/01-hero.jpg
gdrive 1lGBBJYbUiD7ejSGVXZ1LlbvkMW-LdfQh img/luz/lower/02.jpg
gdrive 1W-ToX7uu7crYajVttmULJXT0GnUsdQr8 img/luz/lower/03.jpg
gdrive 1m_6_b8rB0YNGi2T7Qmu5MgEY7iziF5s2 img/luz/lower/04.jpg
# Upper Floor
gdrive 1qtLJcFpH8rEN2ah2D6m3GNAOUeb16181 img/luz/upper/01.jpg
gdrive 1xSzQW6DfHTX0epHkVeT52G1eF7PuwwNL img/luz/upper/02.jpg
gdrive 1ImJjY2jmrI3AijiYHRbIgXLQFBlJIFok img/luz/upper/03.jpg
# Facade
gdrive 1Gv5RFV7ICViuqVIAjMmNZ_rvc0Ws5--X img/luz/facade/01-hero.jpg
gdrive 1zfLPSMNGo0p2RdCfBS2llBff_goRM22C img/luz/facade/02.jpg
gdrive 1UQb-ORvm86RAvJ5qTO3xnqHjfZhVAnR6 img/luz/facade/03.jpg

echo ""
echo "──────────────────────────────────────────"
echo "  Casa Brutal · cocoonflexspaces.com"
echo "──────────────────────────────────────────"
warm "casa-brutal"
BASE="https://cocoonflexspaces.com/wp-content/uploads"
REF="https://cocoonflexspaces.com/casa-brutal/"
dl "$BASE/2025/09/cocoon-casa-brutal-double-staircase-architectural-brutalist-horizontal-1.jpg"   "img/brutal/01-hero-staircase.jpg"   "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-exterior-brick-brutalist-facade-1.jpg"                        "img/brutal/02-exterior-facade.jpg"  "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-first-level-arts-center-gallery-white-walls-1-scaled.jpg"     "img/brutal/03-ground-gallery.jpg"   "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-first-level-arts-center-long-bar-1.jpg"                       "img/brutal/04-long-bar.jpg"         "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-first-level-art-gallery-columns-diagonal-view.jpg"            "img/brutal/05-ground-columns.jpg"   "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-lower-level-gallery-white-walls-concrete-floor-1-scaled.jpg"  "img/brutal/06-lower-gallery.jpg"    "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-lower-level-screening-room-projection-screen-1.jpg"           "img/brutal/07-screening-room.jpg"   "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-upper-level-gallery-white-walls-large-window-1-scaled.jpg"    "img/brutal/08-upper-gallery.jpg"    "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-street-level-sculpture-garden-conversation-1.jpg"             "img/brutal/09-sculpture-garden.jpg" "$REF"
dl "$BASE/2025/09/cocoon-casa-brutal-staircase-architectural-brutalist-1-scaled.jpg"               "img/brutal/10-staircase-detail.jpg" "$REF"

echo ""
echo "──────────────────────────────────────────"
echo "  Casa Arbus · cocoonflexspaces.com"
echo "──────────────────────────────────────────"
warm "casa-arbus"
REF="https://cocoonflexspaces.com/casa-arbus/"
dl "$BASE/2025/02/cocoon-casa-arbus-Studio-A-open-layout-large-windows-two-walls-1.jpg"   "img/arbus/01-hero-studio-a.jpg"     "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-A-open-layout-large-windows-1.jpg"             "img/arbus/02-studio-a-columns.jpg"  "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-A-kitchenette-light-on.jpg"                    "img/arbus/03-kitchenette.jpg"       "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-D-large-windows-two-columns-front-view.jpg"    "img/arbus/04-studio-d.jpg"          "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-A-open-layout-large-desk-two-columns.jpg"      "img/arbus/05-studio-a-desk.jpg"     "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-B-two-large-windows-1.jpg"                     "img/arbus/06-studio-b.jpg"          "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-C-large-windows-open-office-diagonal-view.jpg" "img/arbus/07-studio-c.jpg"          "$REF"
dl "$BASE/2025/01/cocoon-casa-arbus-Studio-D-large-windows-two-columns-diagonal-view.jpg" "img/arbus/08-studio-d-diagonal.jpg" "$REF"

echo ""
echo "──────────────────────────────────────────"
echo "  Resizing to ≤1600px and stripping metadata"
echo "──────────────────────────────────────────"
if command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1; then
  CMD="magick"; command -v $CMD >/dev/null 2>&1 || CMD="convert"
  find img/panorama img/luz img/brutal img/arbus -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) | while read -r f; do
    $CMD "$f" -resize "1600x1600>" -strip -quality 84 "$f.tmp" && mv "$f.tmp" "$f"
    echo "  ✓ $f"
  done
else
  echo "  (ImageMagick not installed — skipping resize. brew install imagemagick to enable.)"
fi

echo ""
echo "  ✓ Done. Run rewrite-paths.sh to localize the deck."
echo ""
