# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 qmake-utils

DESCRIPTION="OpenBoard is an open source cross-platform interactive white board application designed primarily for use in schools.
It was originally forked from Open-Sankoré, which was itself based on Uniboard.

Supported platforms are Windows (7+), OS X (10.9+) and Linux (tested on Ubuntu 14.04 and 16.04)."
HOMEPAGE="http://openboard.ch/"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
#SRC_URI="
#	https://github.com/${PN}-org/${PN}/archive/master.zip -> ${P}.zip
#	https://github.com/${PN}-org/${PN}-ThirdParty/archive/master.zip -> ${PN}-ThirdParty-${PV}.zip
#"

SRC_URI="
	https://raw.githubusercontent.com/cloc3/${PN}/master/distfiles/${P}.tar.zip
	https://raw.githubusercontent.com/cloc3/${PN}/master/distfiles/${PN}-ThirdyParty-${PV}.tar.zip
"

KEYWORDS="amd64 ~arm x86"
IUSE=""

PROPERTIES="interactive"

DEPEND="
	app-arch/unzip
	media-libs/freetype
	dev-libs/openssl
	sys-libs/zlib
	dev-qt/qtlockedfile
	dev-qt/qtsingleapplication
"

RDEPEND="${DEPEND}
"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	mv "${PN}-master" "${P}"
	mv "${PN}-ThirdParty-master" "${PN}-ThirdParty"
}

src_configure() {
	# xpdf ThirdParty build is the only one needed to make OpenBoard 
	cd ../OpenBoard-ThirdParty/xpdf/xpdf-3.04
	econf
}

src_compile() {
	cd ../OpenBoard-ThirdParty/xpdf
	eqmake5 xpdf.pro -spec linux-g++
	emake
	cd $S
	eqmake5 OpenBoard.pro -spec linux-g++
	emake
}

src_install() {
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake DESTDIR="${D}" install
	fi
	einstalldocs
	P_INSTALL_PATH="/usr/lib/${PN}"
	PRODUCT_DIR="${S}/build/linux/release/product/"
	EXE="${P_INSTALL_PATH}/${PN}"
	exeinto "${P_INSTALL_PATH}"
	doexe "${PRODUCT_DIR}/${PN}"
	insinto "${P_INSTALL_PATH}"
	doins -r "${PRODUCT_DIR}/library" "${PRODUCT_DIR}/etc"
	dosym "${D}${EXE}" "/usr/bin/${PN}"
}
