# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Amide's a Medical Image Data Examiner: Amide is a tool for viewing, registering, and analyzing anatomical and functional volumetric medical imaging data sets."
HOMEPAGE="http://amide.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/amide/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc +dicom ffmpeg libgsl libfame"

RDEPEND="
	>=x11-libs/gtk+-2.16:2
	dicom? ( sci-libs/dcmtk )
	ffmpeg? ( virtual/ffmpeg )
	libgsl? ( sci-libs/gsl )
	libfame? ( media-libs/libfame )"
DEPEND="${RDEPEND}
	doc? (
		app-text/gnome-doc-utils
		app-text/scrollkeeper
	)"

src_configure() {
	econf $(use_enable doc) $(use_enable dicom libdcmdata) $(use_enable ffmpeg) $(use_enable libfame) $(use_enable libgsl)
}

src_compile() {
	emake -j1
}
