#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# rewrite-paths.sh — swap remote image URLs (Drive + cocoonflexspaces.com)
# in index.html for the local paths produced by fetch-images.sh.
# Run after fetch-images.sh has completed cleanly.
# ─────────────────────────────────────────────────────────────────────

set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f index.html ]; then
  echo "  ✗ index.html not found — run from inside the proposal folder."
  exit 1
fi

cp index.html index.html.bak
echo "  ✓ Backup written to index.html.bak"

sed_inplace() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

DRIVE="https://drive.google.com/thumbnail?id="
SZ="&sz=w1600"

swap_drive() {
  local id="$1" local_path="$2"
  sed_inplace "s|${DRIVE}${id}${SZ}|${local_path}|g" index.html
}

# Casa Panorama
swap_drive 1UA7i8nE4w-Pt-KeLOgqTt7Yu4K4sqeCl img/panorama/lower/01-hero.jpg
swap_drive 1o7SyGDZbukawkpn25JMzrDBCv-MxskSz img/panorama/lower/02.jpg
swap_drive 1KuoY-Moco_kWut2yEDvIvadiTAyovZWF img/panorama/lower/03.jpg
swap_drive 15YCvnO8B7jkzrbfrTs4Z_rWXIypUfoX1 img/panorama/lower/04.jpg
swap_drive 1-rD5zL62wNyjjBOCenbvrSPIj9ZFVBJv img/panorama/upper/01.jpg
swap_drive 1qa0BQ4eOUHosCovdKJ9mXfL2ojhTePk5 img/panorama/upper/02.jpg
swap_drive 1_88zu1jLgI-Vpj3F5V9Wm13W17B5sIR5 img/panorama/upper/03.jpg
swap_drive 15J_N-QN05LldndORpFGYRiy2ezLJrAOg img/panorama/rooftop/01-hero.jpg
swap_drive 1W6JzMEZJhYu_-J6PtHdMhQTpmdOO708W img/panorama/rooftop/02.jpg
swap_drive 1fVSjKj3W69FiuazJjAlSuA5d4zfJHocC img/panorama/rooftop/03.jpg

# Casa Luz
sed_inplace "s|https://cocoonflexspaces.com/wp-content/uploads/2026/04/45Howard_42741-scaled.jpg|img/luz/lower/00-cover-hero.jpg|g" index.html
swap_drive 1sM8-EoIaPgl4PGYzXVInzWqigv8vQslr img/luz/lower/01-hero.jpg
swap_drive 1lGBBJYbUiD7ejSGVXZ1LlbvkMW-LdfQh img/luz/lower/02.jpg
swap_drive 1W-ToX7uu7crYajVttmULJXT0GnUsdQr8 img/luz/lower/03.jpg
swap_drive 1m_6_b8rB0YNGi2T7Qmu5MgEY7iziF5s2 img/luz/lower/04.jpg
swap_drive 1qtLJcFpH8rEN2ah2D6m3GNAOUeb16181 img/luz/upper/01.jpg
swap_drive 1xSzQW6DfHTX0epHkVeT52G1eF7PuwwNL img/luz/upper/02.jpg
swap_drive 1ImJjY2jmrI3AijiYHRbIgXLQFBlJIFok img/luz/upper/03.jpg
swap_drive 1Gv5RFV7ICViuqVIAjMmNZ_rvc0Ws5--X img/luz/facade/01-hero.jpg
swap_drive 1zfLPSMNGo0p2RdCfBS2llBff_goRM22C img/luz/facade/02.jpg
swap_drive 1UQb-ORvm86RAvJ5qTO3xnqHjfZhVAnR6 img/luz/facade/03.jpg

# Casa Brutal · cocoonflexspaces.com
BASE="https://cocoonflexspaces.com/wp-content/uploads"
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-double-staircase-architectural-brutalist-horizontal-1.jpg|img/brutal/01-hero-staircase.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-exterior-brick-brutalist-facade-1.jpg|img/brutal/02-exterior-facade.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-first-level-arts-center-gallery-white-walls-1-scaled.jpg|img/brutal/03-ground-gallery.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-first-level-arts-center-long-bar-1.jpg|img/brutal/04-long-bar.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-first-level-art-gallery-columns-diagonal-view.jpg|img/brutal/05-ground-columns.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-lower-level-gallery-white-walls-concrete-floor-1-scaled.jpg|img/brutal/06-lower-gallery.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-lower-level-screening-room-projection-screen-1.jpg|img/brutal/07-screening-room.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-upper-level-gallery-white-walls-large-window-1-scaled.jpg|img/brutal/08-upper-gallery.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-street-level-sculpture-garden-conversation-1.jpg|img/brutal/09-sculpture-garden.jpg|g" index.html
sed_inplace "s|$BASE/2025/09/cocoon-casa-brutal-staircase-architectural-brutalist-1-scaled.jpg|img/brutal/10-staircase-detail.jpg|g" index.html

# Casa Arbus · cocoonflexspaces.com
sed_inplace "s|$BASE/2025/02/cocoon-casa-arbus-Studio-A-open-layout-large-windows-two-walls-1.jpg|img/arbus/01-hero-studio-a.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-A-open-layout-large-windows-1.jpg|img/arbus/02-studio-a-columns.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-A-kitchenette-light-on.jpg|img/arbus/03-kitchenette.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-D-large-windows-two-columns-front-view.jpg|img/arbus/04-studio-d.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-A-open-layout-large-desk-two-columns.jpg|img/arbus/05-studio-a-desk.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-B-two-large-windows-1.jpg|img/arbus/06-studio-b.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-C-large-windows-open-office-diagonal-view.jpg|img/arbus/07-studio-c.jpg|g" index.html
sed_inplace "s|$BASE/2025/01/cocoon-casa-arbus-Studio-D-large-windows-two-columns-diagonal-view.jpg|img/arbus/08-studio-d-diagonal.jpg|g" index.html

echo "  ✓ Paths rewritten in index.html. Original kept at index.html.bak."
echo "  → Reload the deck in your browser to verify all images render from local img/."
