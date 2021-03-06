# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit autotools eutils gnome2-utils python-any-r1 git-r3

DESCRIPTION="A modification of the classical Freedroid engine into an RPG"
HOMEPAGE="http://www.freedroid.org"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.com/freedroid/freedroid-src.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug devtools nls opengl profile sanitize sound"

RDEPEND="
	sys-libs/zlib
	virtual/jpeg:0
	media-libs/libpng:0
	media-libs/libsdl[opengl?,sound?,video]
	media-libs/sdl-image[jpeg,png]
	>=media-libs/sdl-gfx-2.0.21
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )
	sound? (
		media-libs/libogg
		media-libs/libvorbis
		media-libs/sdl-mixer[vorbis] )
	devtools? ( media-libs/sdl-ttf )"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	nls? ( sys-devel/gettext )
	sanitize? ( || ( sys-devel/gcc[sanitize] sys-devel/clang-runtime[sanitize] ) )"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default

	sed -i \
		-e '/^dist_doc_DATA/d' \
		-e '/-pipe/d' \
		-e '/^SUBDIRS/s/pkgs//' \
		Makefile.am || die
	python_fix_shebang src data/sound
	eautoreconf
}

src_configure() {
	# this can produce strange results due to 'imprecise' math computations
	filter-flags -ffast-math

	local myconf=(
		--disable-fastmath
		--with-embedded-lua
		--localedir="${EPREFIX}/usr/share/locale"
		$(use_enable nls)
		$(use_enable opengl)
		$(use_enable sound)
		$(use_enable debug)
		$(use_with debug extra-warnings)
		$(use_enable debug backtrace)
		$(use_enable sanitize sanitize-address)
		$(use_enable profile rtprof)
		$(use_enable devtools dev-tools)
	)
	econf "${myconf[@]}"
}

src_install() {
	local i

	default
	for i in 48 64 96 128
	do
		doicon -s ${i} pkgs/freedesktop/icons/hicolor/${i}x${i}/apps/"${PN}".png
	done
	doicon -s scalable pkgs/freedesktop/icons/hicolor/scalable/apps/freedroidRPG.svg
	make_desktop_entry "${PN}" "Freedroid RPG" "${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	local v min="1.0_rc1"
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt "${min}"; then
			echo
			ewarn "${P} is not compatible with save games before ${min}."
			ewarn "Please start a new character."
			echo
		fi
	done
}
