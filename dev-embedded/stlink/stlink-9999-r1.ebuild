# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 autotools flag-o-matic linux-info

DESCRIPTION="On board debugger driver for stm32-discovery boards"
HOMEPAGE="https://github.com/burjui/stlink"
EGIT_REPO_URI="https://github.com/karlp/stlink.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/libusb"
DEPEND="$RDEPEND
	virtual/libusb
	virtual/pkgconfig"

pkg_pretend() {
	if ! linux_chkconfig_module USB_STORAGE; then
		ewarn "You will need to rebuild usb-storage as a module for v1 stlink to work."
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto /etc/udev/rules.d
	doins 49-stlinkv*.rules
	insinto /etc/modprobe.d
	doins stlink_v1.modprobe.conf
	einfo "You may want to run \`udevadm control --reload-rules'."
	dodoc README
}
