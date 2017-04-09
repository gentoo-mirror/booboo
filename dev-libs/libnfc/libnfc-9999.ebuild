# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs autotools

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nfc-tools/${PN}/"
else
	SRC_URI="https://github.com/nfc-tools/${PN}/releases/download/${P}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="doc pcsc-lite readline static-libs usb"

RDEPEND="pcsc-lite? ( sys-apps/pcsc-lite )
	readline? ( sys-libs/readline:0 )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	eautoreconf
	local drivers="arygon,pn532_uart,pn532_spi,pn532_i2c,acr122s"
	use pcsc-lite && drivers+=",acr122_pcsc"
	use usb && drivers+=",pn53x_usb,acr122_usb"
	econf \
		--with-drivers="${drivers}" \
		$(use_enable doc) \
		$(use_with readline) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && doxygen
}

src_install() {
	default
	use static-libs || find "${ED}" -name 'lib*.la' -delete
	use doc && dohtml "${S}"/doc/html/*
}
