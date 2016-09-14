# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 go

DESCRIPTION="wego is a weather client for the terminal."
EGO_PACKAGE_PATH="github.com/schachmat/wego"
HOMEPAGE="https://${EGO_PACKAGE_PATH}/"
EGIT_REPO_URI=$HOMEPAGE

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="apparmor"

DEPEND="$DEPEND
	dev-go/go-colorable
	dev-go/go-runewidth
	dev-go/ingo"

QA_FLAGS_IGNORED="usr/bin/wego"

src_install() {
	dobin wego
	dodoc README.md

	use apparmor && insinto /etc/apparmor.d && doins $FILESDIR/usr.bin.wego
}
