# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI='git://github.com/the3dfxdude/7kaa.git'

inherit git-r3 autotools

DESCRIPTION="Seven Kingdoms: Ancient Adversaries"
HOMEPAGE="https://www.7kfans.com/"
SRC_URI="https://www.7kfans.com/downloads/7kaa-music.tar.bz2"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/openal
media-libs/libsdl2[video,sound]"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cd "${S}"
	unpack ${A}
}

src_prepare() {
	eapply -p0 ${FILESDIR}/fix-intl-9999.patch
	eapply_user

	sh ./autogen.sh
	intltoolize --copy --force
	eautoreconf
	eautomake
}

src_compile() {
	econf
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /usr/share/7kaa/music
	doins 7kaa-music/music/*
}

