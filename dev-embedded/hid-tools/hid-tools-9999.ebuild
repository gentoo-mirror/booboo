# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{5..13} )
DISTUTILS_USE_PEP517=hatchling

inherit git-r3 distutils-r1

EGIT_REPO_URI="https://gitlab.freedesktop.org/bentiss/hid-tools"

DESCRIPTION="a set of tools to interact with the kernel's HID subsystem"
HOMEPAGE="https://gitlab.freedesktop.org/bentiss/hid-tools"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-python/parse[${PYTHON_USEDEP}]"
